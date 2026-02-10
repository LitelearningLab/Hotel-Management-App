import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/model/feedback_form_model.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<FeedbackFormModel> _feedbackFormFuture;

  final Map<String, String> _selectedAnswers = {};
  final Map<String, String> _answers = {};
  final Map<String, TextEditingController> _commentControllers = {};

  OverlayEntry? _bottomMessageEntry;

  bool submitted = false;
  String? existingDocId;
  bool isLoading = true;
  var form;
  final Set<String> missingFields = {};

  // ------------- NEW YEAR FIELD ---------------
  String? selectedYear;

  // --------------------------------------------

  @override
  void initState() {
    super.initState();
    _feedbackFormFuture = _loadFeedbackForm();
  }

  Future<FeedbackFormModel> _loadFeedbackForm() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "unknown_user";

    // Get form
    final formSnap = await _firestore.collection('feedbackform').limit(1).get();

    if (formSnap.docs.isEmpty) {
      throw Exception("No feedback form found");
    }

    final formData = formSnap.docs.first.data() as Map<String, dynamic>;
    form = FeedbackFormModel.fromJson(formData).sorted();

    // Load existing response
    final existingFeedback = await _firestore
        .collection('feedbackResponses')
        .where('_id', isEqualTo: userId)
        .limit(1)
        .get();

    if (existingFeedback.docs.isNotEmpty) {
      existingDocId = existingFeedback.docs.first.id;
      final existingData =
          existingFeedback.docs.first.data() as Map<String, dynamic>;

      // Load saved year
      if (existingData["year"] != null) {
        selectedYear = existingData["year"];
      }

      if (existingData['answers'] != null) {
        final previousAnswers =
            Map<String, dynamic>.from(existingData['answers']);

        for (var sectionEntry in previousAnswers.entries) {
          final sectionTitle = sectionEntry.key;
          final questions = List<Map<String, dynamic>>.from(sectionEntry.value);

          for (var q in questions) {
            final questionText = q['question'];
            final answer = q['answer'];

            final combinedKey = "$sectionTitle-$questionText";
            _answers[combinedKey] = answer;

            // refill comment controllers
            _commentControllers[combinedKey] =
                TextEditingController(text: answer);

            // refill mcq selected options
            for (var section in form.sections) {
              for (var question in section.questions) {
                if (question.text == questionText &&
                    question.options.contains(answer)) {
                  _selectedAnswers[
                          "${form.sections.indexOf(section)}-${section.questions.indexOf(question)}"] =
                      answer;
                }
              }
            }
          }
        }
      }
    }

    isLoading = false;
    setState(() {});

    return form;
  }

  // ------------------- GROUP ANSWERS ---------------------
  Map<String, List<Map<String, String>>> _buildAnswerGroupedMap(
      FeedbackFormModel form) {
    final Map<String, List<Map<String, String>>> groupedAnswers = {};

    for (var section in form.sections) {
      final sectionList = <Map<String, String>>[];

      for (var question in section.questions) {
        final key = "${section.title}-${question.text}";
        final answer = _answers[key];

        if (answer != null && answer.trim().isNotEmpty) {
          sectionList.add({
            "question": question.text ?? "Untitled Question",
            "answer": answer,
          });
        }
      }

      if (sectionList.isNotEmpty) {
        groupedAnswers[section.title ?? "Untitled Section"] = sectionList;
      }
    }
    return groupedAnswers;
  }

  // ------------------- NEW ORDERED VALIDATION --------------------
  Future<void> submit(FeedbackFormModel form) async {
    // YEAR REQUIRED
    if (selectedYear == null) {
      showBottomStickyMessage(context, "Please select your year.");
      return;
    }

    missingFields.clear(); // reset

    bool hasError = false;

    for (var section in form.sections) {
      for (var question in section.questions) {
        // skip comment-only questions
        if (question.options.isEmpty) continue;

        final sectionTitle = section.title ?? "";
        final questionText = question.text ?? "";
        final combinedKey = "$sectionTitle-$questionText";

        final answer = _answers[combinedKey];

        if (answer == null || answer.trim().isEmpty) {
          missingFields.add(questionText); // store missing question
          hasError = true;
        }
      }
    }

// YEAR CHECK
    if (selectedYear == null) {
      missingFields.add("Select Your Year");
      hasError = true;
    }

    if (hasError) {
      _showMissingFieldsPopup(); // new popup method
      setState(() {}); // refresh UI to show red marks
      return;
    }

    // GROUP ANSWERS
    final groupedAnswers = _buildAnswerGroupedMap(form);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("userId") ?? "unknown_user";
      final userName = prefs.getString("userName") ?? "Anonymous";
      final collegeId = prefs.getString("collegeId") ?? "empty";

      final city = prefs.getString("city");
      final course = prefs.getString("course");

      final feedbackData = {
        "_id": userId,
        "userName": userName,
        "submittedAt": FieldValue.serverTimestamp(),
        "answers": groupedAnswers,
        "collegeId": collegeId,
        "city": city,
        "course": course,
        "year": selectedYear, // NEW FIELD
      };

      if (existingDocId != null) {
        await _firestore
            .collection('feedbackResponses')
            .doc(existingDocId)
            .update(feedbackData);
      } else {
        await _firestore.collection('feedbackResponses').add(feedbackData);
      }

      showBottomStickyMessage(
          context, "Your feedback has been submitted successfully.");
      submitted = true;
      setState(() {});
    } catch (e) {
      showBottomStickyMessage(context, "Error submitting feedback: $e");
    }
  }

  void _showMissingFieldsPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Required Fields Missing"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: missingFields.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                          child: Text(
                        item,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      )),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actionsPadding: EdgeInsets.all(8),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: TextStyle(color: linearColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // ------------------- BOTTOM STICKY MESSAGE --------------------
  void showBottomStickyMessage(BuildContext context, String message) {
    _bottomMessageEntry?.remove();

    _bottomMessageEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        top: 40,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _bottomMessageEntry?.remove();
                    _bottomMessageEntry = null;
                  },
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_bottomMessageEntry!);
  }

  // --------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Feedback Form",
          textAlign: TextAlign.left,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () => kIsWeb
              ? Get.rootDelegate.offNamed(AppRoutes.home)
              : Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<FeedbackFormModel>(
        future: _feedbackFormFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: linearColor));
          }

          final form = snapshot.data!;

          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Profluent Hotelier – Feedback Form",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Divider(),

                // ----------------- YEAR SELECTION -----------------
                const SizedBox(height: 10),
                // ----------------- YEAR SELECTION -----------------
                const SizedBox(height: 10),
                Text(
                  "Select Your Year",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ["1st Year", "2nd Year", "3rd Year"].map((year) {
                    final isSelected = selectedYear == year;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedYear = year;
                          missingFields.remove("Select Your Year");
                        });
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color:
                              isSelected ? Colors.blue.shade50 : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: isSelected ? Colors.blue : Colors.grey,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              year,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.blue.shade900
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Divider(color: Colors.grey.shade400, thickness: 0.8),

                // --------------- FEEDBACK SECTIONS ----------------
                ...List.generate(form.sections.length, (sectionIndex) {
                  final section = form.sections[sectionIndex];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(section.title ?? "",
                          style: TextStyle(
                              color: primaryDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      if (section.subTitle != null)
                        Text(section.subTitle ?? "",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700])),
                      const SizedBox(height: 6),

                      // -------- Questions Loop --------
                      ...List.generate(section.questions.length, (qIndex) {
                        final question = section.questions[qIndex];
                        final key = "$sectionIndex-$qIndex";
                        final selectedOption = _selectedAnswers[key];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${question.order}. ${question.text}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),

                                    // RED ! INDICATOR
                                    if (missingFields.contains(question.text))
                                      Icon(Icons.error,
                                          color: Colors.red, size: 22),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // ---------- MCQ ----------
                                if (question.options.isNotEmpty)
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: question.options.map((option) {
                                      final isSelected =
                                          selectedOption == option;

                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedAnswers[key] = option;

                                            final combinedKey =
                                                "${section.title}-${question.text}";
                                            _answers[combinedKey] = option;

                                            // REMOVE ERROR WHEN ANSWERED
                                            missingFields.remove(question.text);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: isSelected
                                                ? Colors.blue.shade50
                                                : Colors.white,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isSelected
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                                size: 18,
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.grey,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(option),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )

                                // ---------- COMMENT ----------
                                else
                                  Builder(builder: (context) {
                                    final combinedKey =
                                        "${section.title}-${question.text}";

                                    _commentControllers.putIfAbsent(
                                        combinedKey,
                                        () => TextEditingController(
                                            text: _answers[combinedKey] ?? ""));

                                    final controller =
                                        _commentControllers[combinedKey]!;

                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 5,
                                            color: Colors.black26,
                                          )
                                        ],
                                      ),
                                      child: TextField(
                                        cursorColor: Colors.black,
                                        controller: controller,
                                        maxLines: 3,
                                        onChanged: (value) {
                                          _answers[combinedKey] = value;

                                          if (value.trim().isNotEmpty) {
                                            missingFields.remove(question.text);
                                          }
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Enter your comments...",
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 14),
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.all(12),
                                        ),
                                      ),
                                    );
                                  }),
                              ]),
                        );
                      }),

                      Divider(),

                      // if (form.sections.length - 1 == sectionIndex)
                      //   Padding(
                      //     padding: const EdgeInsets.only(bottom: 25),
                      //     child: SizedBox(
                      //       height: 45,
                      //       width: displayWidth(context),
                      //       child: submitted
                      //           ? const Center(
                      //               child: Text("Feedback Submitted",
                      //                   style: TextStyle(
                      //                       color: Colors.black,
                      //                       fontSize: 16,
                      //                       fontWeight: FontWeight.w500)),
                      //             )
                      //           : CustomButton(
                      //               onPressed: () => submit(form),
                      //               buttonText: existingDocId != null
                      //                   ? "Update Feedback"
                      //                   : "Submit Feedback",
                      //             ),
                      //     ),
                      //   )
                    ],
                  );
                }),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -2),
              blurRadius: 6,
            )
          ],
        ),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: submitted
              ? const Center(
                  child: Text(
                    "Feedback Submitted",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : CustomButton(
                  onPressed: () => submit(form),
                  buttonText: existingDocId != null
                      ? "Update Feedback"
                      : "Submit Feedback",
                ),
        ),
      ),
    );
  }
}

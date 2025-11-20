import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
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

  @override
  void initState() {
    super.initState();
    _feedbackFormFuture = _loadFeedbackForm();
  }

  Future<FeedbackFormModel> _loadFeedbackForm() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId") ?? "unknown_user";

    // Load feedback form
    final formSnap = await _firestore.collection('feedbackform').limit(1).get();
    if (formSnap.docs.isEmpty) {
      throw Exception("No feedback form found");
    }
    final formData = formSnap.docs.first.data() as Map<String, dynamic>;
    final form = FeedbackFormModel.fromJson(formData).sorted();

    // Check existing feedback by user
    final existingFeedback = await _firestore
        .collection('feedbackResponses')
        .where('_id', isEqualTo: userId)
        .limit(1)
        .get();

    if (existingFeedback.docs.isNotEmpty) {
      existingDocId = existingFeedback.docs.first.id;
      final existingData =
          existingFeedback.docs.first.data() as Map<String, dynamic>;

      if (existingData['answers'] != null) {
        final Map<String, dynamic> previousAnswers =
            Map<String, dynamic>.from(existingData['answers']);

        // Populate local answer maps
        for (var sectionEntry in previousAnswers.entries) {
          final sectionTitle = sectionEntry.key;
          final questions = List<Map<String, dynamic>>.from(sectionEntry.value);

          for (var q in questions) {
            final questionText = q['question'] ?? 'Untitled Question';
            final answer = q['answer'] ?? '';
            final combinedKey = "$sectionTitle-$questionText";

            _answers[combinedKey] = answer;

            // Refill comment fields
            if (!_commentControllers.containsKey(combinedKey)) {
              _commentControllers[combinedKey] =
                  TextEditingController(text: answer);
            }

            // Refill multiple-choice
            for (var section in form.sections) {
              for (var question in section.questions) {
                if (question.text == questionText &&
                    question.options.contains(answer)) {
                  final qKey =
                      "${form.sections.indexOf(section)}-${section.questions.indexOf(question)}";
                  _selectedAnswers[qKey] = answer;
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
            "question": question.text ?? 'Untitled Question',
            "answer": answer,
          });
        }
      }

      if (sectionList.isNotEmpty) {
        groupedAnswers[section.title ?? 'Untitled Section'] = sectionList;
      }
    }

    return groupedAnswers;
  }

  Future<void> submit(FeedbackFormModel form) async {
    // NEW VALIDATION: Only MCQ questions are required
    int requiredQuestions = 0;
    int requiredAnswered = 0;

    for (var section in form.sections) {
      for (var question in section.questions) {
        // MCQ = question.options not empty
        if (question.options.isNotEmpty) {
          requiredQuestions++;

          final sectionTitle = section.title ?? "";
          final questionText = question.text ?? "";
          final combinedKey = "$sectionTitle-$questionText";

          if (_answers[combinedKey] != null &&
              _answers[combinedKey]!.trim().isNotEmpty) {
            requiredAnswered++;
          }
        }
      }
    }

    if (requiredAnswered < requiredQuestions) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Incomplete Feedback",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            "Please answer all multiple-choice questions before submitting your feedback.",
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
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
        "course": course
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
          context, "Your feedback has been submitted successfully. Thank you!");
      submitted = true;
      setState(() {});
    } catch (e) {
      showBottomStickyMessage(context, "Error while submitting feedback: $e");
    }
  }

  void showBottomStickyMessage(BuildContext context, String message) {
    // If a message is already showing, remove it first
    _bottomMessageEntry?.remove();

    _bottomMessageEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        // bottom: 0,
        top: 40,
        child: Material(
          color: Colors.transparent,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            offset: const Offset(0, 0),
            child: Container(
              // height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryDark,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );

    Overlay.of(context).insert(_bottomMessageEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          forceMaterialTransparency: true,
          titleSpacing: 0,
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: linearColor,
              ));
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red)),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("No feedback form found"));
            }

            final form = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [
                // 🧾 Intro Header
                Padding(
                  padding: kIsWeb
                      ? const EdgeInsets.symmetric(horizontal: 40)
                      : const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Profluent Hotelier – Feedback Form",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87, height: 1.5),
                          children: [
                            const TextSpan(
                              text:
                                  "We’d love to know your thoughts about your ongoing experience with the ",
                            ),
                            TextSpan(
                              text: "Profluent Hotelier App. ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: linearColor,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  "Please share your honest feedback to help us enhance your learning journey.",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey.shade400, thickness: 0.8),
                    ],
                  ),
                ),

                // 🧩 Feedback Sections
                ...List.generate(form.sections.length, (sectionIndex) {
                  final section = form.sections[sectionIndex];
                  return Padding(
                    padding: kIsWeb
                        ? const EdgeInsets.symmetric(horizontal: 40)
                        : const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(height: 10),
                        Text(
                          section.title ?? '',
                          style: TextStyle(
                            color: primaryDark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        section.subTitle != null
                            ? Text(
                                section.subTitle ?? '',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            : SizedBox.shrink(),
                        const SizedBox(height: 6),
                        ...List.generate(section.questions.length, (qIndex) {
                          final question = section.questions[qIndex];
                          final key = "$sectionIndex-$qIndex";
                          final selectedOption = _selectedAnswers[key];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${question.order}. ${question.text}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // 🎯 Options or Comment Box
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

                                            final sectionTitle =
                                                section.title ??
                                                    'Untitled Section';
                                            final questionText =
                                                question.text ??
                                                    'Untitled Question';
                                            final combinedKey =
                                                "$sectionTitle-$questionText";
                                            _answers[combinedKey] = option;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(6),
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
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.grey,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                option,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isSelected
                                                      ? Colors.blue.shade900
                                                      : Colors.black87,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                else
                                  Builder(builder: (context) {
                                    final sectionTitle =
                                        section.title ?? 'Untitled Section';
                                    final questionText =
                                        question.text ?? 'Untitled Question';
                                    final combinedKey =
                                        "$sectionTitle-$questionText";

                                    if (!_commentControllers
                                        .containsKey(combinedKey)) {
                                      _commentControllers[combinedKey] =
                                          TextEditingController(
                                              text:
                                                  _answers[combinedKey] ?? '');
                                    }

                                    final controller =
                                        _commentControllers[combinedKey]!;

                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.25),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: TextField(
                                        controller: controller,
                                        cursorColor: Colors.black,
                                        cursorWidth: 1.3,
                                        decoration: InputDecoration(
                                          hintText: "Enter your comments...",
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 13),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 14, vertical: 12),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        maxLines: 3,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.black),
                                        onChanged: (value) {
                                          _answers[combinedKey] = value;
                                        },
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          );
                        }),
                        Divider(color: Colors.grey.shade400, thickness: 0.8),
                        if (form.sections.length - 1 == sectionIndex)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: displayWidth(context),
                                height: 45,
                                child: submitted
                                    ? Center(
                                        child: Text(
                                          "Feedback Submitted",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
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
                          ),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}

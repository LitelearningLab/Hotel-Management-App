import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/public/shared_pref.dart';
import 'package:http/http.dart' as http;

class SentenceResultDialog extends StatefulWidget {
  SentenceResultDialog(
      {Key? key,
      required this.isCorrect,
      required this.word,
      required this.score,
      required this.correctedWidget,
      required this.practiceType})
      : super(key: key);
  final String word;
  final double score;
  final List<Widget> correctedWidget;
  final String practiceType;

  final bool isCorrect;

  @override
  _SentenceResultDialogState createState() {
    return _SentenceResultDialogState();
  }
}

class _SentenceResultDialogState extends State<SentenceResultDialog> {
  late String resultText;

  @override
  void initState() {
    if (kDebugMode) {
      print("init state called");
    }
    super.initState();
    endPractice(practiceType: widget.practiceType);
    if (widget.score >= 90) {
      if (kDebugMode) {
        print("scoreee:${widget.score}");
      }
      resultText = "WELL DONE!";
    } else {
      if (kDebugMode) {
        print("scoreee:${widget.score}");
      }
      resultText = "Need More Practice!";
    }
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    // getIsSplit(context);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  endPractice({required practiceType}) async {
    if (kDebugMode) {
      print("practice Type: $practiceType");
      print("end practice Tappeddd");
    }
    String userId = await SharedPref.getSavedString('userId');
    if (kDebugMode) {
      print("userIddd:$userId");
    }
    String url = "baseUrl" + "endPracticeApi";
    if (kDebugMode) {
      print("url : $url");
    }
    if (kDebugMode) {
      print("scoreeeeetypeee:${widget.score.runtimeType}");
      print("scoreeee:${widget.score}");
    }
    try {
      var response = await http.post(Uri.parse(url), body: {
        "userid": userId,
        "practicetype": practiceType,
        "score": widget.score.toString(),
        "action": "practice"
      });

      if (kDebugMode) {
        print("response : ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("error login : $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: getWidgetHeight(height: 15)),
      //height: 265,
      decoration: new BoxDecoration(
        color: Colors.white,
        //color: Color(0xFF37496C),
        //color: Colors.yellow,
        // Color(0XFF34425D)
        borderRadius: new BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: getWidgetWidth(width: 10),
                vertical: getWidgetHeight(height: 5)),
            decoration: new BoxDecoration(
              color: primaryDark,
              // color: Color(0xff333a40),
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0)),
            ),
            child: Align(
              child: Text("Pronunciation Analysis Report",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: kText.scale(20),
                      fontFamily: Keys.fontFamily,
                      color: Colors.white)),
              alignment: Alignment.center,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getWidgetWidth(width: 15)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: getWidgetWidth(width: 85),
                      padding: EdgeInsets.symmetric(
                        horizontal: getWidgetWidth(width: 5),
                        vertical: getWidgetHeight(height: 7),
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.1), // subtle soft shadow
                            blurRadius: 8,
                            offset: Offset(0, 4), // vertical shadow
                          ),
                        ],
                      ),
                      child: Text(
                        "SCORE: ${widget.score.toStringAsFixed(0)}%",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: kText.scale(12),
                          fontWeight: FontWeight.w500,
                          fontFamily: Keys.fontFamily,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      width: getWidgetWidth(width: 130),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: getWidgetWidth(width: 5),
                        vertical: getWidgetHeight(height: 7),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.1), // subtle soft shadow
                            blurRadius: 8,
                            offset: Offset(0, 4), // vertical shadow
                          ),
                        ], // use instead of BorderRadius.all(Radius.circular(20))
                      ),
                      child: Text(resultText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: kText.scale(12),
                              fontWeight: FontWeight.w500,
                              fontFamily: Keys.fontFamily,
                              color: Colors.black)),
                    ),
                  ],
                ),
                SizedBox(
                  height: getWidgetHeight(height: 20),
                ),
                Container(
                  //color: Colors.yellow,
                  child: Wrap(
                    children: widget.correctedWidget,
                  ),
                ),
                SizedBox(height: getWidgetHeight(height: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: getWidgetHeight(height: 30),
                      width: getWidgetWidth(width: 110),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green[500]!,
                          ),
                          borderRadius: BorderRadius.circular(
                              10) // use instead of BorderRadius.all(Radius.circular(20))
                          ),
                      child: Text("CORRECT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: kText.scale(12),
                              fontFamily: Keys.fontFamily,
                              color: Colors.green[500])),
                    ),
                    Container(
                      height: getWidgetHeight(height: 30),
                      width: getWidgetWidth(width: 115),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red[500]!,
                          ),
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(
                              10) // use instead of BorderRadius.all(Radius.circular(20))
                          ),
                      child: Text("WRONG/MISSED",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: kText.scale(12),
                              fontFamily: Keys.fontFamily,
                              color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(
                  height: getWidgetHeight(height: 20),
                ),
                Text(
                  "Note: This result only indicates intelligibility and does not confirm the accuracy of pronunciation.",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: kText.scale(10),
                      fontFamily: Keys.fontFamily),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

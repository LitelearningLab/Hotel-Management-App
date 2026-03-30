import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:after_layout/after_layout.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/close_value_model.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/public/shared_pref.dart';
import 'package:hotelmanagementapp/public/size_helpers.dart';
import 'package:hotelmanagementapp/public/spacing.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

class SpeechAnalyticsDialog extends StatefulWidget {
  SpeechAnalyticsDialog(
    this.isWord, {
    Key? key,
    required this.word,
    this.title,
    this.load,
    this.isCallflow = false,
    required this.isShowDidNotCatch,
    this.main,
    //  this.pronunciation,
  }) : super(key: key);
  final String word;
  final String? title;
  final String? load;
  final bool isWord;
  final bool isCallflow;
  final bool isShowDidNotCatch;
  final String? main;
  // final String? pronunciation;

  @override
  SpeechAnalyticsDialogState createState() {
    return SpeechAnalyticsDialogState();
  }
}

class SpeechAnalyticsDialogState extends State<SpeechAnalyticsDialog>
    with AfterLayoutMixin<SpeechAnalyticsDialog> {
  bool _isShowDidNotCatch = false;
  bool _isDismissed = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  final SpeechToText speech = SpeechToText();
  bool _isCorrect = false;
  // FirebaseHelper db = new FirebaseHelper();
  late Timer _timer;
  int _start = 0;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    _isShowDidNotCatch = widget.isShowDidNotCatch;
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    // getIsSplit(context);
    setState(() {});
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    // speech.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        _start++;
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _initSpeechState();
  }

  // void closeDialog(String isCorrect) {
  //   stopListening();
  //   Navigator.pop(context, isCorrect.toString());
  // }

  Future<void> _initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale!.localeId;
    } else {
      RecorderPermissionPopup(context);
      // DeniedAlertDialogFunction();
    }

    if (!mounted) return;
    if (!_isShowDidNotCatch) startListening();
  }

  endPractice({required practiceType, required successCount}) async {
    String userId = await SharedPref.getSavedString('userId');
    String url = "baseUrl" + "endPracticeApi";

    try {
      var response = await http.post(Uri.parse(url), body: {
        "userid": userId,
        "practicetype": practiceType,
        //"score": "",
        "action": "practice",
        "successCount": successCount
      });
    } catch (e) {
      print("error login : $e");
    }
  }

  double kHeight = 0.0;
  double kWidth = 0.0;
  late TextScaler kText;

  void RecorderPermissionPopup(BuildContext context) {
    kHeight = MediaQuery.of(context).size.height;
    kWidth = MediaQuery.of(context).size.width;
    kText = MediaQuery.of(context).textScaler;

    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        // var controller = Provider.of<AuthState>(context, listen: false);
        return AlertDialog(
            insetPadding:
                EdgeInsets.only(left: kWidth / 32.35, right: kWidth / 32.75),
            actionsPadding: EdgeInsets.only(
                right: kWidth / 26.2,
                left: kWidth / 26.2,
                bottom: kHeight / 28.4),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            title: Text(
              'Permission Required',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            content: Text(
              'Cannot proceed without permission',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black87, fontWeight: FontWeight.w500),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryDark),
                    onPressed: () async {
                      await openAppSettings();
                      //Navigator.pop(context);
                    },
                    child: Text(
                      'Go',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 15),
                    )),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.white);
      },
    );
  }

  void startListening() async {
    setState(() => _isListening = true);
    Timer(Duration(seconds: 13), () {
      dev.log("stopssss");
      // stopListening();
      // // Navigator.pop(context);
      _isShowDidNotCatch = true;
      setState(() {});
    });

    lastWords = "";
    lastError = "";
    await speech.listen(
      onResult: resultListener,
      listenFor: Duration(minutes: 3),
      pauseFor: Duration(seconds: 10),
      localeId: _currentLocaleId,
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
        listenMode: ListenMode.dictation,
      ),
      onSoundLevelChange: soundLevelListener,
      // cancelOnError: false,
      // partialResults: true,
//       onDevice: true,
      // listenMode: ListenMode.confirmation,
      // sampleRate: 44100,
    );

    Timer(Duration(seconds: 60), () {
      if (speech.isListening) {
        stopListening();
        _isShowDidNotCatch = true;
        if (mounted) {
          setState(() {});
        }
      }
    });

    setState(() {});
  }

  void stopListening() async {
    await speech.stop();
    level = 0.0;
  }

  String convertSpecialChars(String input) {
    final Map<String, String> specialCharMap = {
      '!': ' exclamation mark',
      '@': ' at ',
      '#': ' number',
      '%': ' percent ',
      '^': ' caret ',
      '&': ' ampersand ',
      '*': ' asterisk ',
      '(': ' open parenthesis ',
      ')': ' close parenthesis ',
      '_': ' underscore',
      '+': ' plus ',
      '=': ' equals ',
      '{': ' open brace ',
      '}': ' close brace ',
      '[': ' open bracket ',
      ']': ' close bracket ',
      '|': ' vertical bar ',
      '\\': ' backslash ',
      ':': ' colon ',
      ';': ' semicolon ',
      '"': ' quotation mark ',
      '\'': ' apostrophe ',
      '<': ' less than ',
      '>': ' greater than ',
      ',': ' comma ',
      '.': ' dot ',
      '?': ' question mark ',
      '/': ' slash ',
      '`': ' backtick ',
      '~': ' tilde ',
      '§': ' section ',
      '°': ' degree ',
      // '€': ' euro ',
      // '£': ' pound sterling ',
      // '¥': ' yen ',
      '•': ' bullet ',
      '…': ' ellipsis ',
      '¡': ' inverted exclamation mark ',
      '¢': ' cent ',
      '∞': ' infinity ',
      '≠': ' not equal to ',
      '≤': ' less than or equal to ',
      '≥': ' greater than or equal to ',
      '÷': ' division ',
      '×': ' multiplication ',
      '±': ' plus-minus ',
      '™': ' trademark ',
      '®': ' registered trademark ',
      '©': ' copyright ',
      '¶': ' pilcrow ',
      '‰': ' per mille ',
      // '₹': ' rupee '
    };

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      if (char == '\$') {
        // Handle specific case for $ followed by text
        int start = i + 1;
        while (start < input.length && input[start] == ' ') {
          start++;
        }
        int end = start;
        while (end < input.length && input[end] != ' ') {
          end++;
        }
        if (start < input.length) {
          buffer.write(input.substring(start, end).trim());
          buffer.write(' dollars ');
          i = end - 1; // Move the index to the end of the processed part
        } else {
          buffer.write('dollars ');
        }
      } else if (char == '₹') {
        // Handle specific case for $ followed by text
        int start = i + 1;
        while (start < input.length && input[start] == ' ') {
          start++;
        }
        int end = start;
        while (end < input.length && input[end] != ' ') {
          end++;
        }
        if (start < input.length) {
          buffer.write(input.substring(start, end).trim());
          buffer.write(' rupee ');
          i = end - 1; // Move the index to the end of the processed part
        } else {
          buffer.write('rupee ');
        }
      } else if (char == '€') {
        // Handle specific case for $ followed by text
        int start = i + 1;
        while (start < input.length && input[start] == ' ') {
          start++;
        }
        int end = start;
        while (end < input.length && input[end] != ' ') {
          end++;
        }
        if (start < input.length) {
          buffer.write(input.substring(start, end).trim());
          buffer.write(' euro ');
          i = end - 1; // Move the index to the end of the processed part
        } else {
          buffer.write('euro ');
        }
      } else if (char == '£') {
        // Handle specific case for $ followed by text
        int start = i + 1;
        while (start < input.length && input[start] == ' ') {
          start++;
        }
        int end = start;
        while (end < input.length && input[end] != ' ') {
          end++;
        }
        if (start < input.length) {
          buffer.write(input.substring(start, end).trim());
          buffer.write(' pound sterling ');
          i = end - 1; // Move the index to the end of the processed part
        } else {
          buffer.write('pound sterling ');
        }
      } else if (char == '¥') {
        // Handle specific case for $ followed by text
        int start = i + 1;
        while (start < input.length && input[start] == ' ') {
          start++;
        }
        int end = start;
        while (end < input.length && input[end] != ' ') {
          end++;
        }
        if (start < input.length) {
          buffer.write(input.substring(start, end).trim());
          buffer.write(' yen ');
          i = end - 1; // Move the index to the end of the processed part
        } else {
          buffer.write('yen ');
        }
      } else if (specialCharMap.containsKey(char)) {
        buffer.write(specialCharMap[char]);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString().trim();
  }

  String convertNumbersToText(String inputString) {
    final numberPattern = RegExp(r'\d+'); // Matches one or more digits

    final StringBuffer outputBuffer = StringBuffer();
    int startIndex = 0;

    for (final match in numberPattern.allMatches(inputString)) {
      final int number =
          int.parse(match.group(0)!); // Extract and parse the number
      final String numberText = convertToWordsWithAnd(
          number); // Use the modified method to convert number to words with "and"

      // Append the text before the number
      outputBuffer.write(inputString.substring(startIndex, match.start));
      // Append the converted text instead of the number
      outputBuffer.write(numberText + ' ');

      startIndex = match.end; // Update start index for remaining string
    }

    // Append the remaining string after the last number
    outputBuffer.write(inputString.substring(startIndex));

    return outputBuffer.toString();
  }

  String convertToWordsWithAnd(int number) {
    // Convert the number to words using a hypothetical NumberToWordsEnglish.convert method
    final String numberText = NumberToWordsEnglish.convert(number);

    // Add "and" appropriately for British English
    if (number >= 100) {
      final StringBuffer resultBuffer = StringBuffer();
      final parts = numberText.split(' ');

      for (int i = 0; i < parts.length; i++) {
        resultBuffer.write(parts[i]);
        if (i == 1 && number % 100 != 0) {
          resultBuffer.write(' and');
        }
        if (i < parts.length - 1) {
          resultBuffer.write(' ');
        }
      }

      return resultBuffer.toString();
    } else {
      return numberText;
    }
  }

  List<List<String>> compareAndAlignSegments(
      List<String> actual, List<String> heard) {
    List<List<String>> result = [];
    int heardIndex = 0; // Pointer for `heard` list
    for (int i = 0; i < actual.length; i++) {
      if (heardIndex >= heard.length) {
        // If no more items in `heard`, append empty segment
        result.add([]);
        continue;
      }
      String actualWord = actual[i];
      String heardWord = heard[heardIndex];
      // Check for direct match
      if (actualWord == heardWord) {
        result.add([actualWord]); // Add correct segment
        heardIndex++; // Move to next heard word
      }
      // Handle combined or split numbers
      else if (isNumeric(actualWord)) {
        String combinedActual = "";
        int tempIndex = i;
        // Combine consecutive numeric segments in actual
        while (tempIndex < actual.length && isNumeric(actual[tempIndex])) {
          combinedActual += actual[tempIndex];
          tempIndex++;
        }
        // Compare combined actual number with heard word
        if (combinedActual == heardWord) {
          // If the combined numbers match the heard word, add the segment
          result.add([combinedActual]);
          i = tempIndex - 1; // Adjust actual pointer
          heardIndex++; // Move to next heard word
        } else if (heardWord.startsWith(combinedActual)) {
          // If the combined numbers partially match, add the current segment
          result.add([actualWord]);
          heardIndex++; // Move to next heard word
        } else {
          result.add([]); // No match
        }
      } else {
        result.add([]); // No match for non-numeric word
        heardIndex++; // Skip the unmatched word in heard
      }
    }
    return result;
  }

// Helper to check if a string is numeric
  bool isNumeric(String str) {
    return int.tryParse(str) != null;
  }

// Helper to check if a string is numeric

  void resultListener(SpeechRecognitionResult result) async {
    if (!result.finalResult) {
      setState(() {
        lastWords += result.recognizedWords + " ";
      });
      return;
    }
    setState(() {
      lastWords += result.recognizedWords;
    });
    List<Widget> formatedWords = [];
    List<String> correct = [];
    List<String> focusWords = [];
    List<String> correctWords = [];
    List<String> heard = [];
    double correctPer = 0;

    if (result.finalResult) {
      List<String> actual =
          widget.word.trim().split(" ").where((e) => e.isNotEmpty).toList();
      heard = result.recognizedWords
          .trim()
          .split(" ")
          .where((e) => e.isNotEmpty)
          .toList();

      // Clean up the heard words
      // for (int i = 0; i < heard.length; i++) {
      //   heard[i] = heard[i].replaceAll(RegExp(r'[^\w\s\$]+'), '');
      // }

      // Clean up the actual words
      for (int i = 0; i < actual.length; i++) {
        actual[i] = actual[i].replaceAll(RegExp(r'[^\w\s\$]+'), '');
      }
      var testing = compareAndAlignSegments(actual, heard);

      // Iterate through actual words and match with heard words
      for (int i = 0; i < actual.length; i++) {
        String actWord = actual[i];
        bool isFound = false;
        for (int j = 0; j < heard.length; j++) {
          if (actWord.trim().toLowerCase() == heard[j].trim().toLowerCase()) {
            correct.add(actual[i]);
            Widget wi = Padding(
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: AutoSizeText(
                actWord,
                minFontSize: 15,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: Keys.fontFamily,
                    color: Colors.green),
              ),
            ); /*Text(
              actWord,
              style: TextStyle(fontSize: isSplitScreen?12:15, fontFamily: Keys.fontFamily, color: Colors.green),
            );*/
            formatedWords.add(wi);
            correctWords.add(actWord);
            heard.removeAt(j); // Remove the matched word from heard
            isFound = true;
            break;
          }
        }

        if (!isFound) {
          focusWords.add(actWord);
          Widget wi = Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: Text(
                actWord,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: Keys.fontFamily,
                    color: Colors.white),
              ));
          formatedWords.add(wi);
        } else {
          if (!focusWords.contains('NA')) focusWords.add('NA');
        }
      }

      correctPer = (correct.length / actual.length) * 100;

      _isCorrect = correctPer == 100.0;
      _isCorrect
          ? endPractice(
              practiceType: "Pronunciation Sound Lab Report",
              successCount: "correct")
          : endPractice(
              practiceType: "Pronunciation Sound Lab Report",
              successCount: "wrong");
    }

    if (result.finalResult && !_isDismissed) {
      _isDismissed = true;
      // AuthState userDatas = Provider.of<AuthState>(context, listen: false);

      if (_timer.isActive) {
        _timer.cancel();
      } else {}

      CloseValue closeValue = CloseValue();

      closeValue.formatedWords = formatedWords;
      closeValue.correctWords = correctWords; // ✅ Added this line
      closeValue.wordPer = correctPer;
      closeValue.heard = heard.join(' ');
      closeValue.word = convertNumbersToText(convertSpecialChars(widget.word));
      closeValue.isCorrect = _isCorrect.toString();
      Get.back(result: closeValue);
    }
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
  }

  void errorListener(SpeechRecognitionError error) {
    if (!speech.isListening) {
      _isDismissed = true;
      // _isShowDidNotCatch = true;
      //  stopListening();
      // print(_isShowDidNotCatch);
      // setState(() {});
      //print(dialogContext);
      //_speechAnalyticsDialogState.currentState.closeDialog();
      // Navigator.pop(context, "notCatch");
      // widget.closeDialog("notCatch", "", 0, null);
      CloseValue closeValue = CloseValue();
      closeValue.isCorrect = "notCatch";

      Get.back(result: closeValue);

      // Navigator.pop(widget.context, "notCatch");
    }

    // setState(() {
    //   lastError = "${error.errorMsg} - ${error.permanent}";
    // });
  }

  void statusListener(String status) {
    if (status == 'done' || status == 'notListening') {
      setState(() => _isListening = false);
      startListening();
    }
    print("statusListener");
    print(
        "Received listener status: $status, listening: ${speech.isListening}");

//    print(_context);
//     setState(() {
//
//     });

    // CloseValue closeValue = CloseValue();
    // closeValue.isCorrect = "notCatch";

    // Get.back(result: closeValue);

    lastStatus = "$status";
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(Radius.circular(10.0)),
        // color: AppColors.c262626,
        color: Colors.white,
      ),
      // height: _isShowDidNotCatch ? 170 : 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isShowDidNotCatch)
            Container(
              height: 75,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
                color: Color.fromARGB(255, 74, 148, 168),
                // boxShadow: [new BoxShadow(color: Colors.grey, blurRadius: 3.0, offset: new Offset(1.0, 1.0))],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Recording is ON",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: Keys.fontFamily,
                            fontSize: globalFontSize(11, context),
                            fontWeight: FontWeight.w600),
                      ),
                      SPH(7),
                      Text(
                        "Speak Now!",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: Keys.fontFamily,
                          fontSize: globalFontSize(18, context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SPW(displayWidth(context) / 46.875),
                  SizedBox(
                      height: displayHeight(context) / 16.24,
                      width: displayWidth(context) / 7.5,
                      child: Image.asset(AllAssets.speakBubble))
                ],
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SPH(15),
              // if (!_isShowDidNotCatch)
              //   Image.asset(
              //     AllAssets.speakani,
              //     color: Color(0xff7ab800),
              //     width: 70,
              //   ),
              if (!_isShowDidNotCatch) SizedBox(height: 10),

              if (!_isShowDidNotCatch)
                Container(
                  alignment: Alignment.center,
                  //height: 180,
                  padding:
                      EdgeInsets.only(right: 5, left: 5, top: 20, bottom: 20),
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage(AllAssets.wordbackk),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(widget.word,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: Keys.fontFamily,
                                fontSize: globalFontSize(20, context),
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ), /* add child content here */
                ),
              // if(!_isShowDidNotCatch)Text('PRONUNCIATION',style: TextStyle(color: AppColors.green),),
              // if(!_isShowDidNotCatch)Text(widget.pronunciation!,style: TextStyle(color: AppColors.green),),
              if (!_isShowDidNotCatch) SizedBox(height: 15),

              // if (!_isShowDidNotCatch)
              //   Text("Analyzing Speech for English (US)",
              //       style: TextStyle(
              //           color: AppColors.white,
              //           fontFamily: Keys.fontFamily,
              //           fontSize: 10)),
              if (_isShowDidNotCatch)
                Container(
                  color: Color(0xFF61B3CA),
                  width: 400,
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: 5, left: 5, top: 20, bottom: 15),
                    child: Text("Didn't catch that.\nTry speaking again!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: Keys.fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              if (_isShowDidNotCatch)
                SizedBox(
                  height: 10,
                ),
              if (_isShowDidNotCatch)
                IconButton(
                    icon: Icon(
                      Icons.mic,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      CloseValue closeValue = CloseValue();
                      closeValue.isCorrect = "openDialog";
                      Get.back(result: closeValue);

                      // widget.closeDialog("openDialog", "", 0, null);
                      //  Navigator.pop(widget.context, "openDialog");
                      // if (!speech.isListening) {
                      //   _isShowDidNotCatch = false;
                      //   startListening();
                      // }
                    }),
              if (_isShowDidNotCatch)
                SizedBox(
                  height: 10,
                ),
              if (_isShowDidNotCatch)
                Text("Touch mic when ready",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: Keys.fontFamily,
                        fontSize: 12)),
              SizedBox(
                height: 15,
              )
              // SPH(15),
            ],
          ),
        ],
      ),
    );
  }
}

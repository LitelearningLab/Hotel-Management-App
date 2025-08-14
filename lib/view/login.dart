import 'dart:developer';

import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotelmanagementapp/auth/email_auth_service.dart';
import 'package:hotelmanagementapp/auth/google_auth_service.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/api.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/device_type.dart';
import 'package:hotelmanagementapp/public/utils.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custom_button.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';
import 'package:intl/intl.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailAuth = EmailAuthService();
  final googleAuth = GoogleAuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLogin = false;
  bool error = false;
  String? validateEmail(String? val) {
    if (val == null || val.isEmpty) {
      setState(() {
        error = true;
      });
      return "Please enter an email address";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(val)) {
      setState(() {
        error = true;
      });
      return "Please enter a valid email address";
    }

    setState(() {
      error = false;
    });

    return null;
  }

  login() async {
    if (!_isLogin) {
      if (_formKey.currentState!.validate()) {
        error = false;
        setState(() {});
        await isUserRegistered(emailController.text.toLowerCase());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid email')),
        );
      }
      return;
    }

    _isLoading = true;
    setState(() {});

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('UserNode')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red, content: Text("Invalid password.")),
        );
        // showCenterToast("Invalid password.");
        _isLoading = false;
        setState(() {});
        return;
      }

      final doc = snapshot.docs.first;
      final userData = doc.data();
      final userId = doc.id;

      // 🔹 Step 1: Fetch Company Data
      final companyId = userData['companyid'];
      if (companyId == null || companyId.toString().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Company information missing.")),
        );
        _isLoading = false;
        setState(() {});
        return;
      }

      final companySnapshot = await FirebaseFirestore.instance
          .collection('UserNode')
          .where('_id', isEqualTo: companyId)
          .limit(1)
          .get();

      if (companySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red, content: Text("Company not found.")),
        );
        _isLoading = false;
        setState(() {});
        return;
      }

      final companyData = companySnapshot.docs.first.data();
      log("${companyData['status']} make printing the company status here");

      // 🔹 Step 2: Check company status
      if (companyData['status'] != "1") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Company status is invalid.")),
        );
        _isLoading = false;
        setState(() {});
        return;
      }

      // 🔹 Step 3: Check subscription dates
      final userSubDate =
          DateTime.tryParse(userData['subscriptionenddate'] ?? '');
      final companySubDate =
          DateTime.tryParse(companyData['subscriptionenddate'] ?? '');
      final now = DateTime.now();
      log("user sub date $userSubDate company sub date $companySubDate  now $now");

      bool isUserActive = userSubDate != null && userSubDate.isAfter(now);
      bool isCompanyActive =
          companySubDate != null && companySubDate.isAfter(now);

      if (!isUserActive && !isCompanyActive) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Subscription date has been finished.")),
        );
        _isLoading = false;
        setState(() {});
        return;
      }

      // 🔹 Step 4: Device verification (same as before)
      final prefs = await SharedPreferences.getInstance();
      if (!kIsWeb) {
        final deviceId = await const AndroidId().getId();
        final deviceName = await DeviceScreenInfo.getModelName();

        if (userData.containsKey('imei')) {
          if (userData['imei'] != deviceId) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("Login denied: Device not recognized.")),
            );
            _isLoading = false;
            setState(() {});
            return;
          }
        } else {
          await doc.reference.update({
            'imei': deviceId,
            'model': deviceName,
            'firstTImeLogin': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          });
        }
      }

      // 🔹 Step 5: Save prefs
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool("loginInfo", true);
      await prefs.setString("userId", userId);
      await prefs.setString("collegeId", userData['collegeId'] ?? '');
      await prefs.setString("batchName", userData['batchName'] ?? '');
      await prefs.setString("userName", userData['username'] ?? '');
      await prefs.setString("collegeName", userData['college'] ?? '');
      await prefs.setString("city", userData['city'] ?? '');
      await prefs.setString("country", userData['country'] ?? '');
      await prefs.setString("mobile", userData['mobile'] ?? '');
      await prefs.setString("joindate", userData['joindate'] ?? '');
      await prefs.setString("enddate", userData['subscriptionenddate'] ?? '');

      log("User ID saved: $userId");
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      log("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text("Login failed. Please try again.")),
      );
    }

    _isLoading = false;
    setState(() {});
  }

  Future<bool> isUserRegistered(String email) async {
    _isLoading = true;
    setState(() {});
    log("Checking email: $email");

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('UserNode')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      _isLoading = false;
      setState(() {});

      if (snapshot.docs.isNotEmpty) {
        _isLogin = true;
        _isLoading = false;
        setState(() {});
        log("User exists in database");
        return true;
      } else {
        log("User not found in database");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not registered.")),
        );
        return false;
      }
    } catch (e) {
      log("Error checking registration: $e");
      _isLoading = false;
      setState(() {});
      return false;
    }
  }

  void showCenterToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SizedBox(
        height: kHeight,
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.only(
                  top:
                      //  isSplitScreen
                      //     ? getFullWidgetHeight(height: 30)
                      //     :
                      getWidgetHeight(height: 30),
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              width: kWidth,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidgetHeight(height: 25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: getWidgetHeight(height: 120),
                          width: getWidgetWidth(width: 200),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            // radius: 25,
                            child: ClipOval(
                              child: Image.asset(
                                AllAssets.splashLogo,
                                fit: BoxFit.contain,
                                // width: getWidgetWidth(width: 200),
                                height: getWidgetHeight(height: 200),
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //     height: 40,
                        //     width: 40,
                        //     child: Image.asset(
                        //         "assets/images/profluent_ar_icon.png"))
                      ],
                    ),
                  ),
                  SizedBox(height: getWidgetHeight(height: 30)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidgetHeight(height: 25),
                    ),
                    child: SizedBox(
                        height:
                            //  isSplitScreen
                            //     ? getFullWidgetHeight(height: 280)
                            //     :
                            getWidgetHeight(height: 200),
                        child: Image.asset(!_isLogin
                            ? 'assets/images/undraw_Messaging_app_re_aytg.png'
                            : 'assets/images/SMSOTP.png')),
                  ),
                  SizedBox(height: getWidgetHeight(height: 20)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidgetHeight(height: 25),
                    ),
                    child: Text(
                      _isLogin
                          ? "Enter Your Password"
                          : "Enter Your Email Address",
                      style: TextStyle(color: Color(0XFFF8F8F8F)),
                    ),
                  ),
                  SizedBox(height: getWidgetHeight(height: 23)),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidgetHeight(height: 25),
                    ),
                    child: SizedBox(
                      height: getWidgetHeight(height: error ? 75 : 50),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller:
                            _isLogin ? passwordController : emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          !_isLogin ? validateEmail(val) : null;
                        },
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: _isLogin ? "Password" : "Email Address",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          fillColor: Color(0XFFE8E8E8),
                          filled: true,
                          prefixIcon:
                              Icon(Icons.email, color: Colors.grey), // Optional
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0XFFE8E8E8)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0XFFE8E8E8)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 23),
                  // if (!_isLoading)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidgetHeight(height: 25),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: linearColor,
                          )
                        : CustomButton(
                            buttonText:
                                _isLogin ? "Verify Login" : "Verify & Login",
                            onPressed: () async {
                              login();
                            },
                          ),
                  ),
                  if (_isLogin)
                    TextButton(
                      onPressed: () {
                        passwordController.clear();
                        _isLogin = false;
                        setState(() {});
                      },
                      child: const Text(
                        "<< Back",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: () async {
                        Get.toNamed(AppRoutes.inAppWebView, arguments: {
                          "url": ApiRoutes.privacyPolicy,
                        });
                      },
                      child: Text(
                        "Privacy & Policy",
                        style: GoogleFonts.inter(
                          height: 0.5,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: lightWhite,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

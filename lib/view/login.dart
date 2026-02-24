import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:hotelmanagementapp/public/sessio_service.dart';
import 'package:hotelmanagementapp/public/size_helpers.dart';
import 'package:hotelmanagementapp/public/utils.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custom_button.dart';
import 'package:hotelmanagementapp/utility/in_aapp_web.dart';
import 'package:hotelmanagementapp/view/blocked_device_screen.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailAuth = EmailAuthService();
  OverlayEntry? _bottomMessageEntry;
  // final googleAuth = GoogleAuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLogin = false;
  bool error = false;
  bool isLoading = true;
  bool _obscurePassword = true;
  String? appVersion;
  Timer? _hideTimer;

  Future<void> _loadAppVersion() async {
    if (Platform.isIOS) {
      setState(() {
        appVersion = "1.0.0";
      });
    } else {
      // For Android and others, fetch from package info
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version; // e.g. "1.0.3"
      });
    }
  }

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

  void showBottomStickyMessage(BuildContext context, String message) {
    // If a message is already showing, remove it first
    _bottomMessageEntry?.remove();

    _bottomMessageEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        bottom: 40,
        // top: displayHeight(context) / 18,
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
                color: const Color.fromARGB(132, 212, 15, 1),
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

  Future<void> login() async {
    if (!_isLogin) {
      if (_formKey.currentState!.validate()) {
        error = false;
        setState(() {});
        await isUserRegistered(emailController.text.toLowerCase());
      } else {
        showBottomStickyMessage(context, "Please enter a valid email address.");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Please enter a valid email')),
        // );
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
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       backgroundColor: Colors.red, content: Text("Invalid password.")),
        // );
        showBottomStickyMessage(context, "Invalid password.");
        // showCenterToast("Invalid password.");
        _isLoading = false;
        isLoading = true;
        setState(() {});
        return;
      }

      final doc = snapshot.docs.first;
      final userData = doc.data();
      final userId = doc.id;

      // 🔹 Step 1: Fetch Company Data
      final companyId = userData['companyid'];
      if (companyId == null || companyId.toString().isEmpty) {
        showBottomStickyMessage(context, "Company information missing.");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       backgroundColor: Colors.red,
        //       content: Text("Company information missing.")),
        // );
        _isLoading = false;
        isLoading = true;
        setState(() {});
        return;
      }

      final companySnapshot = await FirebaseFirestore.instance
          .collection('UserNode')
          .where('_id', isEqualTo: companyId)
          .limit(1)
          .get();

      if (companySnapshot.docs.isEmpty) {
        showBottomStickyMessage(context, "Company not found.");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       backgroundColor: Colors.red, content: Text("Company not found.")),
        // );
        _isLoading = false;
        isLoading = true;
        setState(() {});
        return;
      }

      final companyData = companySnapshot.docs.first.data();
      log("${companyData['status']} make printing the company status here and here im printing the imei ${userData["imei"]}");

      // 🔹 Step 2: Check company status
      if (companyData['status'] != "1") {
        showBottomStickyMessage(context, "Company status is invalid.");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       backgroundColor: Colors.red,
        //       content: Text("Company status is invalid.")),
        // );
        _isLoading = false;
        isLoading = true;
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
        showBottomStickyMessage(
            context, "Subscription date has been finished.");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       backgroundColor: Colors.red,
        //       content: Text("Subscription date has been finished.")),
        // );
        _isLoading = false;
        isLoading = true;
        setState(() {});
        return;
      }

      // 🔹 Step 4: Device verification (same as before)
      final prefs = await SharedPreferences.getInstance();
      if (!kIsWeb) {
        final deviceId = Platform.isAndroid
            ? await const AndroidId().getId()
            : await getPermanentDeviceId();
        final deviceName = await DeviceScreenInfo.getModelName();

        if (userData.containsKey('imei')) {
          if (userData['imei'] != deviceId) {
            showBottomStickyMessage(context,
                "Your account is linked to another mobile device. Contact your administrator to register a new device.");
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //       backgroundColor: Colors.red,
            //       content: Text("Login denied: Device not recognized.")),
            // );
            _isLoading = false;
            isLoading = true;
            setState(() {});
            return;
          }
        } else {
          log("checking whether is going now");
          await doc.reference.update({
            'imei': deviceId,
            'model': deviceName,
            // 'firstTImeLogin': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          });
        }
      }

      // 🔹 Step 5: Save prefs
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool("loginInfo", true);
      await prefs.setString("userId", userId);
      await prefs.setString("collegeId", userData['companyid'] ?? '');
      print(
          "Here im printing the user data company id ${userData['companyid']}");
      await prefs.setString("batchName", userData['batchName'] ?? '');
      await prefs.setString("userName", userData['username'] ?? '');
      await prefs.setString("collegeName", userData['college'] ?? '');
      await prefs.setString("city", userData['city'] ?? '');
      await prefs.setString("country", userData['country'] ?? '');
      await prefs.setString("mobile", userData['mobile'] ?? '');
      await prefs.setString("joindate", userData['joindate'] ?? '');
      await prefs.setString("enddate", userData['subscriptionenddate'] ?? '');
      await prefs.setString('course', userData['course'] ?? "");

      log("User ID saved: $userId");
      bool session = true; // default for mobile

      if (kIsWeb) {
        // Only run login session logic on Web
        session = await SessionService.loginUser(email, password);
      }
      if (session) {
        kIsWeb
            ? Get.rootDelegate.offNamed(AppRoutes.home)
            : Get.offAllNamed(AppRoutes.home);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlockedDeviceScreen(
                      reason:
                          "Your account is already active on another device.",
                    )));
      }

      // Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      print("Login error: $e");
      log("Login error: $e");
      isLoading = true;
      setState(() {});
      showBottomStickyMessage(context, "Login failed. Please try again.");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       backgroundColor: Colors.red,
      //       content: Text("Login failed. Please try again.")),
      // );
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
        showBottomStickyMessage(context, "User not registered.");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("User not registered.")),
        // );
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

  Future<void> _loginFailed() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final lastRoute = prefs.getString('lastFailedRoute');
      if (lastRoute != null && lastRoute.isNotEmpty) {
        debugPrint("printing where it is coming here or not");
        Get.snackbar(
          'Load Failed',
          'Please log in first.',
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
        prefs.remove('lastFailedRoute');
      }
    });
  }

  @override
  void initState() {
    _loginFailed();
    _loadAppVersion();
    super.initState();
  }

  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// LOGO
                      Image.asset(
                        AllAssets.splashLogo,
                        height: 70,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 24),

                      /// TITLE
                      /// HEADER (Back + Title)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_isLogin)
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  size: 18),
                              onPressed: () {
                                passwordController.clear();
                                setState(() {
                                  _isLogin = false;
                                  error = false;
                                });
                              },
                            )
                          else
                            const SizedBox(
                                width: 40), // keeps alignment balanced

                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  _isLogin
                                      ? "Welcome back"
                                      : "Login to continue",
                                  style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _isLogin
                                      ? "Enter your password"
                                      : "Enter your registered email address",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 40), // balance space on right
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Text(
                      //   _isLogin
                      //       ? "Enter your password"
                      //       : "Enter your registered email address",
                      //   style: GoogleFonts.inter(
                      //     fontSize: 14,
                      //     color: Colors.grey.shade600,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),

                      const SizedBox(height: 28),

                      /// SVG ILLUSTRATION
                      if (!isWeb)
                        SizedBox(
                          height: 160,
                          child: SvgPicture.asset(
                            _isLogin
                                ? 'assets/pasScreen.svg'
                                : 'assets/emailScreen.svg',
                          ),
                        ),

                      if (!isWeb) const SizedBox(height: 24),

                      /// INPUT FIELD
                      TextFormField(
                        controller:
                            _isLogin ? passwordController : emailController,
                        obscureText: _isLogin ? _obscurePassword : false,
                        keyboardType: _isLogin
                            ? TextInputType.text
                            : TextInputType.emailAddress,
                        cursorColor: Colors.black,
                        validator: (val) {
                          if (!_isLogin) return validateEmail(val);
                          return null;
                        },
                        onFieldSubmitted: (_) => login(),
                        decoration: InputDecoration(
                          hintText: _isLogin ? "Password" : "Email address",
                          prefixIcon: Icon(
                            _isLogin
                                ? Icons.lock_outline
                                : Icons.email_outlined,
                          ),
                          suffixIcon: _isLogin
                              ? IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                    // if (!_obscurePassword) {
                                    //   _hideTimer?.cancel();
                                    //   _hideTimer =
                                    //       Timer(const Duration(seconds: 1), () {
                                    //     if (mounted) {
                                    //       setState(() {
                                    //         _obscurePassword = true;
                                    //       });
                                    //     }
                                    //   });
                                    // }
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: const Color(0xFFF1F1F1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// BUTTON
                      _isLoading
                          ? CircularProgressIndicator(color: linearColor)
                          : SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: CustomButton(
                                buttonText: _isLogin
                                    ? "Verify Login"
                                    : "Verify & Login",
                                onPressed: login,
                              ),
                            ),

                      if (_isLogin && isLoading)
                        TextButton(
                          onPressed: () {
                            passwordController.clear();
                            _isLogin = false;
                            setState(() {});
                          },
                          child: const Text("← Back"),
                        ),

                      const SizedBox(height: 24),

                      /// FOOTER
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              isWeb
                                  ? Get.rootDelegate.offNamed(
                                      AppRoutes.inAppWebView,
                                      arguments: {
                                        "url": ApiRoutes.privacyPolicy,
                                      },
                                    )
                                  : Get.to(() => InAppWebViewPage(),
                                      arguments: {
                                          "url": ApiRoutes.privacyPolicy,
                                        });
                            },
                            child: const Text(
                              "Privacy & Policy",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          if (!isWeb && appVersion != null)
                            Text(
                              "App version $appVersion",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

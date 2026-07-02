import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;

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
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLogin = false;
  bool error = false;
  bool isLoading = true;
  bool _obscurePassword = true;
  String? appVersion;
  Timer? _hideTimer;

  Future<void> _loadAppVersion() async {
    if (kIsWeb) {
      setState(() {
        appVersion = "1.0.4";
      });
      return;
    }
    try {
      if (Platform.isIOS) {
        setState(() {
          appVersion = "1.0.0";
        });
      } else {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        setState(() {
          appVersion = packageInfo.version;
        });
      }
    } catch (_) {
      setState(() {
        appVersion = "1.0.0";
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
    _bottomMessageEntry?.remove();

    _bottomMessageEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        bottom: 40,
        child: Material(
          color: Colors.transparent,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            offset: const Offset(0, 0),
            child: Container(
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

  String _safeString(dynamic value) {
    if (value == null) return '';
    if (value is List) return value.join(', ');
    return value.toString();
  }

  Future<void> login() async {
    if (!_isLogin) {
      if (_formKey.currentState!.validate()) {
        error = false;
        setState(() {});
        await isUserRegistered(emailController.text.toLowerCase());
      } else {
        showBottomStickyMessage(context, "Please enter a valid email address.");
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
        showBottomStickyMessage(context, "Invalid password.");
        _isLoading = false;
        isLoading = true;
        setState(() {});
        return;
      }

      final doc = snapshot.docs.first;
      final userData = doc.data();
      final userId = doc.id;

      final String? access = userData['access'];
      final String companyId;
      final Map<String, dynamic> companyData;
      final companyId = userData['companyid'];
      if (companyId == null || companyId.toString().isEmpty) {
        showBottomStickyMessage(context, "Company information missing.");
        _isLoading = false;
        isLoading = true;
        setState(() {});
        return;
      }

      if (access == "company") {
        companyId = userId;
        companyData = userData;
      } else {
        final rawCompanyId = userData['companyid'];
        if (rawCompanyId == null || rawCompanyId.toString().isEmpty) {
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
        companyId = rawCompanyId.toString();

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

        companyData = companySnapshot.docs.first.data();
      }

      // 🔹 Step 2: Check company status
      if (companySnapshot.docs.isEmpty) {
        showBottomStickyMessage(context, "Company not found.");
        _isLoading = false;
        isLoading = true;
        setState(() {});
        return;
      }

      final companyData = companySnapshot.docs.first.data();

      if (companyData['status'] != "1") {
        showBottomStickyMessage(context, "Company status is invalid.");
        _isLoading = false;
        isLoading = true;
        setState(() {});
        return;
      }

      if (access == "Trainer Login" || access == "company") {
        // Skip subscription date validation for Trainer Login and company
      } else {
        // Check subscription end date as usual for "App User" and other/null accesses
        final userSubDate =
            DateTime.tryParse(_safeString(userData['subscriptionenddate']));
        final companySubDate =
            DateTime.tryParse(_safeString(companyData['subscriptionenddate']));
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
      }

      final prefs = await SharedPreferences.getInstance();
      if (!kIsWeb) {
        try {
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
        } catch (_) {}
      }

      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool("loginInfo", true);
      await prefs.setString("userId", userId);
      await prefs.setString("collegeId", companyId);
      await prefs.setString("batchName", _safeString(userData['batchName']));
      String userName = '';
      if (access == "company") {
        final compName = _safeString(userData['companyname']);
        userName =
            compName.isNotEmpty ? compName : _safeString(userData['college']);
      } else if (access == "Trainer Login") {
        userName = _safeString(userData['name']);
      } else {
        userName = _safeString(userData['username']);
      }
      await prefs.setString("userName", userName);
      String collegeName = _safeString(userData['college']);
      if (access == "Trainer Login" || access == "company") {
        try {
          final univSnapshot = await FirebaseFirestore.instance
              .collection('UniversityCollection')
              .where('collegeId', isEqualTo: companyId)
              .limit(1)
              .get();
          if (univSnapshot.docs.isNotEmpty) {
            collegeName =
                _safeString(univSnapshot.docs.first.data()['collegeName']);
          }
        } catch (e) {
          log("Error fetching collegeName from UniversityCollection: $e");
        }
      }
      await prefs.setString("collegeName", collegeName);
      await prefs.setString("city", _safeString(userData['city']));
      await prefs.setString("country", _safeString(userData['country']));
      await prefs.setString("mobile", _safeString(userData['mobile']));
      await prefs.setString("joindate", _safeString(userData['joindate']));
      await prefs.setString(
          "enddate", _safeString(userData['subscriptionenddate']));
      await prefs.setString('course', _safeString(userData['course']));
      await prefs.setString('access', _safeString(userData['access']));

      bool session = true;

      if (kIsWeb) {
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
    } catch (e) {
      log("Login error: $e");
      isLoading = true;
      setState(() {});
      showBottomStickyMessage(context, "Login failed. Please try again.");
    }

    _isLoading = false;
    setState(() {});
  }

  Future<bool> isUserRegistered(String email) async {
    _isLoading = true;
    setState(() {});

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
        return true;
      } else {
        showBottomStickyMessage(context, "User not registered.");
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

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString("email");
      String? password = prefs.getString("password");

      if (email != null && email.isNotEmpty) {
        emailController.text = email;
        setState(() {
          _isLogin = true;
        });
      }

      if (password != null && password.isNotEmpty) {
        passwordController.text = password;
      }
    } catch (e) {
      log("Error loading saved credentials: $e");
    }
  }

  @override
  void initState() {
    _loginFailed();
    _loadAppVersion();
    _loadSavedCredentials();
    super.initState();
  }

  Widget build(BuildContext context) {
    final isWeb = kIsWeb;

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
                      Image.asset(
                        AllAssets.splashLogo,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),
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
                            const SizedBox(width: 40),
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
                          const SizedBox(width: 40),
                        ],
                      ),
                      const SizedBox(height: 28),
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

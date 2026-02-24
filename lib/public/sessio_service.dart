import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
// import 'dart:html' as html;

class WebStorageHelper {
  static String? getDeviceSessionId() {
    // return html.window.localStorage['deviceSessionId'];
  }

  static void setDeviceSessionId(String id) {
    // html.window.localStorage['deviceSessionId'] = id;
  }
}

class SessionService {
  static Timer? _heartbeatTimer;

  // ======================================================
  // LOGIN
  // ======================================================
  static Future<bool> loginUser(String email, String password) async {
    if (kDebugMode) {
      print("==== LOGIN START ====");
      print("Email: $email");
    }

    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore
        .collection('UserNode')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      if (kDebugMode) {
        print("❌ No user found with email=$email");
      }
      return false;
    }

    final doc = snapshot.docs.first;
    final docRef = firestore.collection("UserNode").doc(doc.id);

    int now = DateTime.now().millisecondsSinceEpoch;

    // 🔥 1. Check if there is an existing session
    int? lastActive =
        doc.data().containsKey('lastActive') ? doc['lastActive'] as int? : null;

    bool isSessionExpired = true;

    if (lastActive != null) {
      int diff = now - lastActive;
      isSessionExpired = diff > 45000; // 30 sec
    }

    // ==================================================================================
    // FIXED: Web MULTIPLE TAB SUPPORT — use SAME deviceSessionId for all tabs
    // ==================================================================================
    String? existingDeviceSessionId = WebStorageHelper.getDeviceSessionId();
    String deviceSessionId = existingDeviceSessionId ?? const Uuid().v4();

    WebStorageHelper.setDeviceSessionId(deviceSessionId);
    if (kDebugMode) {
      print("Device Session ID: $deviceSessionId");
      print("Server Session ID: ${doc['sessionId']}");
      print("Is session expired? $isSessionExpired");
    }

    // ==================================================================================
    // If server already has same sessionId → ALLOW MULTIPLE TAB LOGIN
    // ==================================================================================
    if (!isSessionExpired && doc['sessionId'] == deviceSessionId) {
      if (kDebugMode) {
        print("✔ Same device session active — ALLOW");
      }
    } else if (!isSessionExpired && doc['sessionId'] != deviceSessionId) {
      if (kDebugMode) {
        print("❌ Another device is active — BLOCK");
      }
      return false;
    }

    // ==================================================================================
    // UPDATE FIRESTORE SESSION (fresh login OR continuing same browser session)
    // ==================================================================================
    await docRef.update({
      "sessionId": deviceSessionId,
      "lastActive": now,
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("sessionId", deviceSessionId);
    await prefs.setString("email", email);
    await prefs.setString("password", password);

    print("🎉 Login Success (Web multiple tabs supported)");

    return true;
  }

  // ======================================================
  // VALIDATE SESSION
  // ======================================================
  static Future<bool> validateSession() async {
    if (kDebugMode) {
      print("==== VALIDATE SESSION START ====");
    }

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");
    final localSessionId = prefs.getString("sessionId");
    final browserSessionId = WebStorageHelper.getDeviceSessionId();

    if (email == null || localSessionId == null || browserSessionId == null) {
      if (kDebugMode) {
        print("❌ Missing session data in local storage");
      }
      return false;
    }

    final doc = await FirebaseFirestore.instance
        .collection("UserNode")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    if (doc.docs.isEmpty) {
      return false;
    }

    final serverSessionId = doc.docs.first["sessionId"];

    // ==================================================================================
    // FIXED: Only block if serverSessionId != browserSessionId
    // ==================================================================================
    if (serverSessionId != browserSessionId) {
      if (kDebugMode) {
        print("❌ Session mismatch → different device → block");
      }
      await logoutUser();
      return false;
    }

    if (kDebugMode) {
      print("✔ Session Valid");
    }
    return true;
  }

  // ======================================================
  // HEARTBEAT
  // ======================================================
  static void startHeartbeat() async {
    if (kDebugMode) {
      print("==== START HEARTBEAT ====");
    }

    stopHeartbeat();

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");
    final password = prefs.getString("password");

    if (email == null || password == null) return;

    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (_) async {
      final now = DateTime.now().millisecondsSinceEpoch;

      final snapshot = await FirebaseFirestore.instance
          .collection('UserNode')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return;

      final doc = snapshot.docs.first;

      await FirebaseFirestore.instance
          .collection("UserNode")
          .doc(doc.id)
          .update({"lastActive": now});

      if (kDebugMode) {
        print("💓 Heartbeat sent at ${DateTime.now()}");
      }
    });

    if (kDebugMode) {
      print("🚀 Heartbeat started");
    }
  }

  static void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  // ======================================================
  // LOGOUT
  // ======================================================
  static Future<void> logoutUser() async {
    stopHeartbeat();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (kIsWeb) {
      // Clear browser localStorage
      html.window.localStorage.clear();

      // Clear sessionStorage (if used anywhere)
      html.window.sessionStorage.clear();
    }
  }
}

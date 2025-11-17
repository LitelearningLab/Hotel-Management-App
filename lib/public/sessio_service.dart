import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SessionService {
  static Timer? _heartbeatTimer;

  static Future<bool> loginUser(String email, String password) async {
    print("💡 loginUser() called");
    print("➡️ Email: $email");
    print("➡️ Password: $password");

    final firestore = FirebaseFirestore.instance;

    // Fetch user using your snapshot method
    final snapshot = await firestore
        .collection('UserNode')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    print("📥 Query executed. Docs found: ${snapshot.docs.length}");

    if (snapshot.docs.isEmpty) {
      print("❌ No user found OR wrong password");
      return false;
    }

    final doc = snapshot.docs.first;
    final docRef = firestore.collection("UserNode").doc(doc.id);

    print("✅ User document fetched: ${doc.id}");

    // Handling missing lastActive safely
    int? lastActive;

    if (doc.data().containsKey("lastActive")) {
      lastActive = doc['lastActive'];
      print("🕒 lastActive found: $lastActive");
    } else {
      print("⚠️ lastActive field NOT found! It will be created.");
    }

    int now = DateTime.now().millisecondsSinceEpoch;

    bool isSessionExpired;

    if (lastActive == null) {
      // No previous activity → mark as expired so login continues
      isSessionExpired = true;
      print("⏳ No lastActive → Treating as expired session.");
    } else {
      int difference = now - lastActive;
      isSessionExpired = difference > 120000;
      print("🕒 now: $now");
      print("🕒 Difference: $difference");
      print("⏳ isSessionExpired: $isSessionExpired");
    }

    if (!isSessionExpired) {
      print("❌ Session not expired → User already active");
      return false;
    }

    // Create new session
    final String newSessionId = const Uuid().v4();
    print("🆕 New sessionId generated: $newSessionId");

    // Update OR create missing fields
    await docRef.update({
      "sessionId": newSessionId,
      "lastActive": now,
    }).then((_) {
      print("📤 sessionId + lastActive updated on server");
    }).catchError((error) {
      print("❌ Error updating Firestore: $error");
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("sessionId", newSessionId);

    print("💾 sessionId saved to SharedPreferences");
    print("🎉 Login successful");

    return true;
  }

  static Future<bool> validateSession() async {
    print("==== VALIDATE SESSION START ====");

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");
    final storedSessionId = prefs.getString("sessionId");

    print("A → Local Email: ${email ?? ""}");
    print("B → Local SessionId: ${storedSessionId ?? ""}");

    // If local data missing → treat as not logged in
    if (email == null || storedSessionId == null) {
      print(
          "C → Local email/session is NULL → Returning TRUE (no session to validate)");
      return true;
    }

    print("D → Fetching Firestore user document…");

    final doc = await FirebaseFirestore.instance
        .collection("UserNode")
        .doc(email)
        .get();

    print("E → Firestore doc exists: ${doc.exists}");

    if (!doc.exists) {
      print("F → Firestore doc NOT found → Returning FALSE");
      return false;
    }

    final serverSessionId = doc["sessionId"];
    print("G → Server SessionId: $serverSessionId");

    // Compare sessions
    if (serverSessionId != storedSessionId) {
      print("H → SESSION MISMATCH ❌");
      print("H1 → Local: $storedSessionId");
      print("H2 → Server: $serverSessionId");
      print("H3 → Logging user out…");

      await logoutUser();
      print("H4 → Logout complete");

      return false;
    }

    print("I → SESSION VALID ✔");
    print("==== VALIDATE SESSION END ====");

    return true;
  }

  static void startHeartbeat() async {
    print("💓 startHeartbeat() called");

    stopHeartbeat();
    print("🛑 Previous heartbeat stopped (if any)");

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");
    final password = prefs.getString("password");

    if (email == null || password == null) {
      print(
          "❌ No email/password found in SharedPreferences → Heartbeat NOT started");
      return;
    }

    print("📧 Heartbeat for: $email");

    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (_) async {
      final now = DateTime.now().millisecondsSinceEpoch;
      print("💓 Heartbeat tick → Updating lastActive = $now");

      try {
        // Fetch user via QUERY (because you do not use doc(email))
        final snapshot = await FirebaseFirestore.instance
            .collection('UserNode')
            .where('email', isEqualTo: email)
            .where('password', isEqualTo: password)
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          print("⚠️ No matching user found for heartbeat.");
          return;
        }

        // We have the correct document
        final doc = snapshot.docs.first;
        final docId = doc.id;

        print("📄 Heartbeat updating doc ID: $docId");

        await FirebaseFirestore.instance
            .collection("UserNode")
            .doc(docId)
            .update({"lastActive": now});

        print("✅ lastActive updated successfully");
      } catch (e) {
        print("❌ Heartbeat update failed: $e");
      }
    });

    print("🚀 Heartbeat started (every 30 seconds)");
  }

  static void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  static Future<void> logoutUser() async {
    stopHeartbeat();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

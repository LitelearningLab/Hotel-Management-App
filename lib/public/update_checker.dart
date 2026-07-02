import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  static Future<void> checkForUpdate(BuildContext context) async {
    if (kIsWeb) return;

    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      log("$currentVersion showing printing the current version");

      DocumentSnapshot versionDoc = await FirebaseFirestore.instance
          .collection('app_settings')
          .doc('version_info')
          .get();

      String latestVersion = Platform.isIOS
          ? versionDoc['latest_version_app_store']
          : versionDoc['latest_version'];
      String updateMessage = versionDoc['update_message'];
      log("$currentVersion showing printing the current version $latestVersion");

      // Compare versions
      if (_isNewerVersion(latestVersion, currentVersion)) {
        _showUpdatePopup(context, updateMessage);
      }
    } catch (e) {
      log("Update check failed: $e");
    }
  }

  static bool _isNewerVersion(String latest, String current) {
    try {
      List<int> latestParts = latest.split('.').map(int.parse).toList();
      List<int> currentParts = current.split('.').map(int.parse).toList();
      for (int i = 0; i < latestParts.length; i++) {
        if (i >= currentParts.length) return true;
        if (latestParts[i] > currentParts[i]) return true;
        if (latestParts[i] < currentParts[i]) return false;
      }
    } catch (_) {}
    return false;
  }

  static void _showUpdatePopup(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text('New Update Available!'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () async {
                const androidAppId = "com.profluent.hotelier.app";
                const iOSAppId = "6754444749";

                final url = Platform.isIOS
                    ? Uri.parse("https://apps.apple.com/app/id$iOSAppId")
                    : Uri.parse("market://details?id=$androidAppId");

                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  final webUrl = Platform.isIOS
                      ? Uri.parse("https://apps.apple.com/app/id$iOSAppId")
                      : Uri.parse(
                          "https://play.google.com/store/apps/details?id=$androidAppId");
                  await launchUrl(webUrl, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                'Update Now',
                style: TextStyle(color: linearColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

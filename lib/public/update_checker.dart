import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Example using Firestore

class UpdateChecker {
  static Future<void> checkForUpdate(BuildContext context) async {
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
  }

  static bool _isNewerVersion(String latest, String current) {
    List<int> latestParts = latest.split('.').map(int.parse).toList();
    List<int> currentParts = current.split('.').map(int.parse).toList();
    for (int i = 0; i < latestParts.length; i++) {
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }

  static void _showUpdatePopup(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Force user to interact
      builder: (context) => AlertDialog(
        title: const Text('New Update Available!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              const appId = "com.profluent.hotelier.app";
              final url = Uri.parse("market://details?id=$appId");
              launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
            },
            child: Text(
              'Update Now',
              style: TextStyle(color: linearColor),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';

class BlockedDeviceScreen extends StatelessWidget {
  final String? reason; // 💡 dynamic message from outside

  const BlockedDeviceScreen({super.key, this.reason});

  @override
  Widget build(BuildContext context) {
    kHeight = MediaQuery.of(context).size.height;
    kWidth = MediaQuery.of(context).size.width;
    kText = MediaQuery.of(context).textScaler;

    // Default message
    String message =
        "Access restricted — please use a PC or laptop to open this website.";

    // If custom reason provided → override message
    if (reason != null && reason!.isNotEmpty) {
      message = reason!;
    }

    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: kHeight,
          width: kWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: getWidgetHeight(height: 100),
                width: getWidgetWidth(width: 100),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    AllAssets.splashLogo,
                    fit: BoxFit.contain,
                    height: getWidgetHeight(height: 100),
                  ),
                ),
              ),
              SizedBox(height: getWidgetHeight(height: 20)),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

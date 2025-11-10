import 'package:flutter/material.dart';
import 'package:hotelmanagementapp/public/all_asset.dart';
import 'package:hotelmanagementapp/public/common_function.dart';

class BlockedDeviceScreen extends StatelessWidget {
  const BlockedDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    kHeight = MediaQuery.of(context).size.height;
    kWidth = MediaQuery.of(context).size.width;
    kText = MediaQuery.of(context).textScaler;
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
                // color: Colors.amber,
                height: getWidgetHeight(height: 100),
                width: getWidgetWidth(width: 100),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  // radius: 25,
                  child: Image.asset(
                    AllAssets.splashLogo,
                    fit: BoxFit.contain,
                    // width: getWidgetWidth(width: 200),
                    height: getWidgetHeight(height: 100),
                  ),
                ),
              ),
              SizedBox(
                height: getWidgetHeight(height: 20),
              ),
              Text(
                'Access restricted — please use a PC or laptop to open this website.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// view/no_internet.dart
import 'package:flutter/material.dart';
import 'package:hotelmanagementapp/view/splash.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (did) async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.wifi_off, size: 100, color: Colors.grey),
              SizedBox(height: 20),
              Text("No Internet Connection",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Please check your network and try again."),
            ],
          ),
        ),
      ),
    );
  }
}

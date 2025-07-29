// connectivity_wrapper.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hotelmanagementapp/view/no_internet_page.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(
            _updateConnection as void Function(List<ConnectivityResult> event)?)
        as StreamSubscription<ConnectivityResult>;
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnection(result as ConnectivityResult);
  }

  void _updateConnection(ConnectivityResult result) {
    final isOffline = result == ConnectivityResult.none;
    if (mounted) {
      setState(() => _isOffline = isOffline);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isOffline) {
      return const NoInternetPage();
    }
    return widget.child;
  }
}

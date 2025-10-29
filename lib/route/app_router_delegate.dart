import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/nav2/get_router_delegate.dart';

class AppRouterDelegate extends GetDelegate {
  @override
  Widget build(BuildContext context) {
    final page = currentConfiguration?.currentPage;
    return Navigator(
      onPopPage: (route, result) => route.didPop(result),
      pages: page != null ? [page] : [],
    );
  }
}

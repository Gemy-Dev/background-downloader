import 'dart:developer';

import 'package:flutter/material.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // App is in the foreground
        break;
      case AppLifecycleState.paused:
        // App is in the background
        break;
      case AppLifecycleState.inactive:
        // App is inactive (probably transitioning between foreground & background)
        break;
      case AppLifecycleState.detached:
        // App is detached (for example, iOS app entering background or terminated)
        break;
      case AppLifecycleState.hidden:
    }
  }
}

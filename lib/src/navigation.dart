import 'package:balady_host_sdk/src/balady_host_core.dart';
import 'package:flutter/services.dart';

/// Navigation helper for Mini Apps
class BaladyNavigator {
  static MethodChannel get _channel => BaladyHostSDK.channel;

  /// Close the mini app and return to SuperApp
  static Future<void> close([Map<String, dynamic>? result]) async {
    await BaladyHostSDK.sendToSuperApp('close', result ?? {});
  }

  /// Request navigation within SuperApp
  static Future<void> navigateTo(
    String route, {
    Map<String, dynamic>? params,
  }) async {
    await BaladyHostSDK.sendToSuperApp('navigate', {
      'route': route,
      'params': params,
    });
  }

  /// Show toast message in SuperApp
  static Future<void> showToast(String message) async {
    await BaladyHostSDK.sendToSuperApp('showToast', {
      'message': message,
    });
  }

  /// Open external URL in SuperApp's browser
  static Future<void> openUrl(String url) async {
    await BaladyHostSDK.sendToSuperApp('openUrl', {
      'url': url,
    });
  }
}

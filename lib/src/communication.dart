import 'package:balady_host_sdk/src/balady_host_core.dart';
import 'package:flutter/cupertino.dart';

/// Communication helpers for Mini Apps
class BaladyCommunication {
  /// Get user information from SuperApp
  static Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final result = await BaladyHostSDK.channel.invokeMethod('getUserInfo');
      return result as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('Failed to get user info: $e');
      return null;
    }
  }

  /// Get app configuration from SuperApp
  static Future<Map<String, dynamic>?> getConfig() async {
    try {
      final result = await BaladyHostSDK.channel.invokeMethod('getConfig');
      return result as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('Failed to get config: $e');
      return null;
    }
  }

  /// Store data in SuperApp's persistent storage
  static Future<bool> storeData(String key, dynamic value) async {
    try {
      await BaladyHostSDK.channel.invokeMethod('storeData', {
        'key': key,
        'value': value,
      });
      return true;
    } catch (e) {
      debugPrint('Failed to store data: $e');
      return false;
    }
  }

  /// Retrieve data from SuperApp's persistent storage
  static Future<dynamic> retrieveData(String key) async {
    try {
      return await BaladyHostSDK.channel.invokeMethod('retrieveData', {
        'key': key,
      });
    } catch (e) {
      debugPrint('Failed to retrieve data: $e');
      return null;
    }
  }
}

import 'package:balady_host_sdk/src/balady_host_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Permission manager for Mini Apps
/// Replaces permission_handler package
class HostPermissions {
  static MethodChannel get _channel => BaladyHostSDK.channel;

  /// Request permission
  /// Returns true if granted
  static Future<bool> request(Permission permission) async {
    try {
      final result = await _channel.invokeMethod('requestPermission', {
        'permission': permission.value,
      });
      return result as bool;
    } catch (e) {
      debugPrint('Permission request failed: $e');
      return false;
    }
  }

  /// Check permission status
  static Future<PermissionStatus> check(Permission permission) async {
    try {
      final result = await _channel.invokeMethod('checkPermission', {
        'permission': permission.value,
      });
      return result == true
          ? PermissionStatus.granted
          : PermissionStatus.denied;
    } catch (e) {
      debugPrint('Permission check failed: $e');
      return PermissionStatus.denied;
    }
  }

  /// Request multiple permissions
  static Future<Map<Permission, bool>> requestMultiple(
    List<Permission> permissions,
  ) async {
    final results = <Permission, bool>{};

    for (final permission in permissions) {
      results[permission] = await request(permission);
    }

    return results;
  }
}

/// Permission types
enum Permission {
  camera('camera'),
  photos('photos'),
  location('location'),
  microphone('microphone'),
  contacts('contacts'),
  storage('storage');

  final String value;
  const Permission(this.value);
}

/// Permission status
enum PermissionStatus {
  granted,
  denied,
  permanentlyDenied,
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaladyHostSDK {
  static late MethodChannel _channel;
  static String? _miniAppId;
  static bool _isInitialized = false;

  /// Initialize the mini app
  /// Call this in main() before runApp()
  static Future<void> initialize(String miniAppId) async {
    if (_isInitialized) {
      throw StateError('MiniAppSDK already initialized');
    }

    _miniAppId = miniAppId;
    _channel = MethodChannel('com.superapp/mini_app_$miniAppId');

    // Listen for initialization and events from SuperApp
    _channel.setMethodCallHandler(_handleMethodCall);

    _isInitialized = true;
    debugPrint('MiniAppSDK initialized: $miniAppId');
  }

  /// Run the mini app
  /// Use this instead of Flutter's runApp()
  static void run(Widget app) {
    if (!_isInitialized) {
      throw StateError('MiniAppSDK not initialized. Call initialize() first.');
    }

    runApp(app);
    debugPrint('MiniApp started: $_miniAppId');
  }

  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'init':
        /// Handle initialization data from SuperApp
        final data = call.arguments as Map<String, dynamic>?;
        _onInitCallbacks.forEach((callback) => callback(data));
        break;

      case 'onEvent':
        // Handle events from SuperApp
        final eventName = call.arguments['eventName'] as String;
        final data = call.arguments['data'];
        _onEventCallbacks[eventName]?.forEach((callback) => callback(data));
        break;

      case 'onResume':
        // Handle app resume
        _onResumeCallbacks.forEach((callback) => callback());
        break;

      case 'onPause':
        // Handle app pause
        _onPauseCallbacks.forEach((callback) => callback());
        break;
    }
  }

  /// Callbacks
  static final List<Function(Map<String, dynamic>?)> _onInitCallbacks = [];
  static final Map<String, List<Function(dynamic)>> _onEventCallbacks = {};
  static final List<Function()> _onResumeCallbacks = [];
  static final List<Function()> _onPauseCallbacks = [];

  /// Listen for initialization from SuperApp
  static void onInit(Function(Map<String, dynamic>?) callback) {
    _onInitCallbacks.add(callback);
  }

  /// Listen for events from SuperApp
  static void onEvent(String eventName, Function(dynamic) callback) {
    _onEventCallbacks.putIfAbsent(eventName, () => []).add(callback);
  }

  /// Listen for app resume
  static void onResume(Function() callback) {
    _onResumeCallbacks.add(callback);
  }

  /// Listen for app pause
  static void onPause(Function() callback) {
    _onPauseCallbacks.add(callback);
  }

  /// Send event to SuperApp
  static Future<void> sendToSuperApp(
    String eventName,
    Map<String, dynamic> data,
  ) async {
    _ensureInitialized();

    try {
      await _channel.invokeMethod('sendToSuperApp', {
        'eventName': eventName,
        'data': data,
      });
    } catch (e) {
      debugPrint('Failed to send to SuperApp: $e');
    }
  }

  /// Get mini app ID
  static String get miniAppId {
    _ensureInitialized();
    return _miniAppId!;
  }

  /// Get method channel
  static MethodChannel get channel {
    _ensureInitialized();
    return _channel;
  }

  static void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('MiniAppSDK not initialized');
    }
  }
}

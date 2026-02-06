import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NativeIOSService extends GetxService {
  static const MethodChannel _channel =
      MethodChannel('com.example/silent_push');

  /// Set auth token for native iOS socket operations
  Future<bool> setAuthToken(String token) async {
    if (token.isEmpty) {
      print('❌ Cannot set auth token: empty token provided');
      return false;
    }
    try {
      await _channel.invokeMethod('setAuthToken', token);
      print(
          '✅ Auth token set successfully in native iOS: ${token.substring(0, token.length > 10 ? 10 : token.length)}...');
      return true;
    } catch (e) {
      print('❌ Failed to set auth token in native iOS: $e');
      return false;
    }
  }

  /// Get current auth token status from native iOS
  Future<Map<String, dynamic>?> getAuthTokenStatus() async {
    try {
      final result = await _channel.invokeMethod('getAuthTokenStatus');
      if (result is Map) {
        print('🔍 Auth token status: $result');
        return Map<String, dynamic>.from(result);
      } else {
        print(
            '❌ Unexpected result type for getAuthTokenStatus: ${result.runtimeType}');
        return null;
      }
    } catch (e) {
      print('❌ Failed to get auth token status: $e');
      return null;
    }
  }

  /// Refresh token from storage in native iOS
  Future<Map<String, dynamic>?> refreshTokenFromStorage() async {
    try {
      final result = await _channel.invokeMethod('refreshTokenFromStorage');
      if (result is Map) {
        print('🔄 Token refreshed from storage: $result');
        return Map<String, dynamic>.from(result);
      } else {
        print(
            '❌ Unexpected result type for refreshTokenFromStorage: ${result.runtimeType}');
        return null;
      }
    } catch (e) {
      print('❌ Failed to refresh token from storage: $e');
      return null;
    }
  }

  /// Clear auth token from native iOS
  Future<bool> clearAuthToken() async {
    try {
      await _channel.invokeMethod('clearAuthToken');
      print('🗑️ Auth token cleared from native iOS');
      return true;
    } catch (e) {
      print('❌ Failed to clear auth token: $e');
      return false;
    }
  }

  /// Get current location from native iOS
  Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      final result = await _channel.invokeMethod('getCurrentLocation');
      if (result is Map) {
        print('📍 Current location from native iOS: $result');
        return Map<String, dynamic>.from(result);
      } else {
        print(
            '❌ Unexpected result type for getCurrentLocation: ${result.runtimeType}');
        return null;
      }
    } catch (e) {
      print('❌ Failed to get current location: $e');
      return null;
    }
  }

  /// Start location emission timer
  Future<bool> startLocationEmit() async {
    try {
      await _channel.invokeMethod('startLocationEmit');
      print('🚀 Location emission timer started');
      return true;
    } catch (e) {
      print('❌ Failed to start location emission: $e');
      return false;
    }
  }

  /// Stop location emission timer
  Future<bool> stopLocationEmit() async {
    try {
      await _channel.invokeMethod('stopLocationEmit');
      print('⏹️ Location emission timer stopped');
      return true;
    } catch (e) {
      print('❌ Failed to stop location emission: $e');
      return false;
    }
  }

  /// Manually emit location now
  Future<bool> emitLocationNow() async {
    try {
      await _channel.invokeMethod('emitLocationNow');
      print('📍 Manual location emission triggered');
      return true;
    } catch (e) {
      print('❌ Failed to emit location: $e');
      return false;
    }
  }

  /// Get push notification logs
  Future<List<Map<String, dynamic>>> getPushLogs() async {
    try {
      final result = await _channel.invokeMethod('getPushLogs');
      if (result is List) {
        print('📜 Push logs retrieved: ${result.length} entries');
        return result
            .cast<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else {
        print(
            '❌ Unexpected result type for getPushLogs: ${result.runtimeType}');
        return [];
      }
    } catch (e) {
      print('❌ Failed to get push logs: $e');
      return [];
    }
  }

  /// Get location logs
  Future<List<Map<String, dynamic>>> getLocationLogs() async {
    try {
      final result = await _channel.invokeMethod('getLocationLogs');
      if (result is List) {
        print('📍 Location logs retrieved: ${result.length} entries');
        return result
            .cast<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else {
        print(
            '❌ Unexpected result type for getLocationLogs: ${result.runtimeType}');
        return [];
      }
    } catch (e) {
      print('❌ Failed to get location logs: $e');
      return [];
    }
  }

  /// Get silent push logs
  Future<List<Map<String, dynamic>>> getSilentPushLogs() async {
    try {
      final result = await _channel.invokeMethod('getSilentPushLogs');
      if (result is List) {
        print('🤫 Silent push logs retrieved: ${result.length} entries');
        return result
            .cast<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else {
        print(
            '❌ Unexpected result type for getSilentPushLogs: ${result.runtimeType}');
        return [];
      }
    } catch (e) {
      print('❌ Failed to get silent push logs: $e');
      return [];
    }
  }
}

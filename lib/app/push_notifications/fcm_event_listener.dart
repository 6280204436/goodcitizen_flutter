import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:good_citizen/app/push_notifications/fcm_navigator.dart';
import 'package:good_citizen/app/push_notifications/fcm_notifications_controller.dart';
import 'dart:io' show Platform;

import '../export.dart';

class FCMEventListenController extends GetxController {
  final Map<String, Function(RemoteMessage remoteMessage)>
      _onNotificationListeners = {};

  @override
  void onInit() {
    _startListeningNotifications();
    super.onInit();
  }

  /// listen firebase messaging events
  Future<void> _startListeningNotifications() async {
    // iOS के लिए notification permissions request करें
    if (Platform.isIOS) {
      await _requestIOSPermissions();
    }

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      debugPrint('getInitialMessage');
      FcmNavigator.handleNotificationRedirection(message);
    });

    // Foreground messages (जब app active है)
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint('Notification Data >> ${message.data}');
      debugPrint('Message Type: ${message.messageType}');

      // Silent push notification check करें
      if (_isSilentPush(message)) {
        debugPrint('Silent push notification received');
        _handleSilentPush(message);
      } else {
        // Normal notification
        if (Get.isRegistered<FCMNotificationsController>()) {
          Get.find<FCMNotificationsController>()
              .showNotification(message: message);
        }
      }

      _notifyListeners(message);
    });

    // जब app background में है और user notification पर tap करता है
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      FcmNavigator.handleNotificationRedirection(message);
      debugPrint('onMessageOpenedApp');
    });

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// iOS permissions request करने के लिए
  Future<void> _requestIOSPermissions() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
        'iOS Notification Permission Status: ${settings.authorizationStatus}');

    // iOS के लिए APNS token get करें
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    debugPrint('APNS Token: $apnsToken');
  }

  /// Silent push notification check करने के लिए
  bool _isSilentPush(RemoteMessage message) {
    // iOS में silent push की पहचान करने के तरीके:

    // 1. अगर notification field null है या empty है
    if (message.notification == null) {
      return true;
    }

    // 2. अगर data में silent flag है
    if (message.data.containsKey('silent') &&
        message.data['silent'].toString().toLowerCase() == 'true') {
      return true;
    }

    // 3. अगर content-available है (iOS specific)
    if (message.data.containsKey('content-available') &&
        message.data['content-available'] == '1') {
      return true;
    }

    return false;
  }

  /// Silent push को handle करने के लिए
  void _handleSilentPush(RemoteMessage message) {
    debugPrint('Handling silent push notification');

    // यहाँ आप silent push के लिए specific actions perform कर सकते हैं:
    // - Background data sync
    // - Cache update
    // - Database operations
    // - API calls

    // Example: data sync करना
    _performBackgroundSync(message.data);

    // Silent push के लिए भी listeners को notify करें
    _notifyListeners(message);
  }

  /// Background sync operations
  Future<void> _performBackgroundSync(Map<String, dynamic> data) async {
    try {
      // यहाँ आप अपने background operations perform कर सकते हैं
      debugPrint('Performing background sync with data: $data');

      // Example operations:
      // - API calls
      // - Database updates
      // - Cache refresh

      // Note: iOS में background execution time limited है (usually 30 seconds)
    } catch (e) {
      debugPrint('Error in background sync: $e');
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint('Background message received: ${message.messageId}');

    // Dependencies ensure करें
    Get.put(FCMNotificationsController(), permanent: true);

    // Silent push check करें background में भी
    if (_isSilentPush(message)) {
      debugPrint('Silent push in background');
      _handleSilentPush(message);
    }
  }

  void _notifyListeners(RemoteMessage message) {
    for (var fun in _onNotificationListeners.values) {
      fun.call(message);
    }
  }

  void addOnChangeListener(String id, Function(RemoteMessage) listener) {
    _onNotificationListeners.putIfAbsent(id, () => listener);
  }

  void removeOnChangeListener(String id) {
    _onNotificationListeners.remove(id);
  }
}

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:good_citizen/app/push_notifications/fcm_navigator.dart';
// import 'package:good_citizen/app/push_notifications/fcm_notifications_controller.dart';
//
// import '../export.dart';
//
// class FCMEventListenController extends GetxController {
//   final Map<String, Function(RemoteMessage remoteMessage)>
//       _onNotificationListeners = {};
//
//   @override
//   void onInit() {
//     _startListeningNotifications();
//     super.onInit();
//   }
//
//   /// listen firebase messaging events
//
//   Future<void> _startListeningNotifications() async {
//     FirebaseMessaging.instance.getInitialMessage().then((message) async {
//       debugPrint('getInitialMessage');
//       FcmNavigator.handleNotificationRedirection(message);
//     });
//
//     FirebaseMessaging.onMessage.listen((message) async {
//       debugPrint('Notification Data >> ${message.data}');
//       if (Get.isRegistered<FCMNotificationsController>()) {
//         Get.find<FCMNotificationsController>()
//             .showNotification(message: message);
//       }
//       _notifyListeners(message);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) async {
//       FcmNavigator.handleNotificationRedirection(message);
//       debugPrint('onMessageOpenedApp');
//     });
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     // here when app is closed completely and a message is trigger  this function will be called
//   }
//
//   Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     Get.put(FCMNotificationsController(), permanent: true);
//     //here i ensure all dependencies are up
//   }
//
//   void _notifyListeners(RemoteMessage message) {
//     for (var fun in _onNotificationListeners.values) {
//       fun.call(message);
//     }
//   }
//
//   void addOnChangeListener(String id, Function(RemoteMessage) listener) {
//     _onNotificationListeners.putIfAbsent(id, () => listener);
//   }
//
//   void removeOnChangeListener(String id) {
//     _onNotificationListeners.remove(id);
//   }
// }

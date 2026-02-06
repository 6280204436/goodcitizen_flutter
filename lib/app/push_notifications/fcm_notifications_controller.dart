import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:good_citizen/app/common_data.dart';
import 'package:good_citizen/app/core/utils/localizations/localizations.dart';
import '../../main.dart';
import '../core/values/app_strings.dart';
import 'fcm_navigator.dart';

dynamic globalFCMToken;

/// Background handler for silent and regular push
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling background message: ${message.messageId}");

  if (message.notification == null && message.data.isNotEmpty) {
    // Silent push
    debugPrint("Silent push received in background: ${message.data}");
    await _processSilentPush(message.data);
  } else {
    debugPrint("Regular notification received: ${message.notification?.title}");
  }

  // Handle navigation if needed
  FcmNavigator.handleNotificationRedirection(message);
}

/// Helper to process silent push data
Future<void> _processSilentPush(Map<String, dynamic> data) async {
  debugPrint("Processing silent push data: $data");

  // Example: Perform actions based on backend instructions
  if (data['action'] == 'refresh_data') {
    debugPrint("Triggering background data refresh...");
    // TODO: Call your API or sync function here
  } else if (data['action'] == 'log_event') {
    debugPrint("Logging event: ${data['event_name']}");
    // TODO: Save log in DB or analytics
  }
}

/// Background tap handler for local notifications
@pragma('vm:entry-point')
void _notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint(
      "Notification tapped in background: ${notificationResponse.payload}");
  // Handle navigation or action based on payload
}

class FCMNotificationsController extends GetxController {
  RemoteMessage? remoteMessage;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    "com.google.firebase.messaging.default_notification_channel_id",
    keyAppName.tr,
    icon: "@drawable/ic_notification",
    channelAction: AndroidNotificationChannelAction.createIfNotExists,
    importance: Importance.max,
    priority: Priority.max,
  );

  final DarwinNotificationDetails darwinPlatformChannelSpecifics =
      const DarwinNotificationDetails(
    presentAlert: true,
    presentSound: true,
    interruptionLevel: InterruptionLevel.active,
  );

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  /// Initialize local notifications & Firebase
  void _initialize() async {
    await _initializeNotification();
    _initializeFirebaseService();
  }

  Future _initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@drawable/ic_notification");
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsDarwin,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint(
            "Local notification tapped: ${details.id}, payload: ${details.payload}");
        FcmNavigator.handleNotificationRedirection(remoteMessage);
      },
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    if (Platform.isAndroid) {
      _requestAndroidPermissions();
    } else if (Platform.isIOS) {
      _requestIOSPermissions();
    }
  }

  void _requestAndroidPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> _requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Configure Firebase message handlers
  void _initializeFirebaseService() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Retrieve FCM token
    FirebaseMessaging.instance.getToken().then((value) {
      globalFCMToken = value;
      debugPrint("FCM Token: $globalFCMToken");
    });

    // Token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      globalFCMToken = newToken;
      debugPrint("FCM Token Refreshed: $newToken");
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground message received: ${message.messageId}");
      remoteMessage = message;

      if (message.notification != null) {
        showNotification(message: message);
      } else if (message.data.isNotEmpty) {
        debugPrint("Silent push in foreground: ${message.data}");
        handleSilentNotification(message);
      }
    });

    // Background/killed messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // When user taps a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("App opened from notification: ${message.messageId}");
      remoteMessage = message;
      FcmNavigator.handleNotificationRedirection(message);
    });

    // When app launched from terminated state by tapping a notification
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("App launched from notification: ${initialMessage.messageId}");
      remoteMessage = initialMessage;
      FcmNavigator.handleNotificationRedirection(initialMessage);
    }
  }

  /// Show local notification
  void showNotification({required RemoteMessage message}) async {
    remoteMessage = message;
    if (Platform.isIOS) return;

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? "Default Title",
      message.notification?.body ?? "Default Body",
      platformChannelSpecifics,
      payload: message.data['payload'] ?? '',
    );
  }

  /// Handle silent pushes (foreground)
  void handleSilentNotification(RemoteMessage message) async {
    final data = message.data;
    debugPrint("Processing silent push in foreground: $data");
    await _processSilentPush(data);

    // Optional: Show local notification if backend wants
    if (data['show_local_notification'] == 'true') {
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: darwinPlatformChannelSpecifics,
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        data['title'] ?? "Silent Notification",
        data['body'] ?? "New content available",
        platformChannelSpecifics,
        payload: data['payload'] ?? '',
      );
    }
  }
}

// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:good_citizen/app/common_data.dart';
// import 'package:good_citizen/app/core/utils/localizations/localizations.dart';
// import '../../main.dart';
// import '../core/values/app_strings.dart';
// import 'fcm_navigator.dart';
//
// dynamic globalFCMToken;
//
// // Background message handler for both silent and regular notifications
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint("Handling background message: ${message.messageId}");
//   // Check if it's a silent notification (content-available and no notification field)
//   if (message.notification == null && message.data.isNotEmpty) {
//     debugPrint("Silent notification received with data: ${message.data}");
//     // Handle silent notification data (e.g., update app state, fetch data, etc.)
//     // Optionally trigger a local notification based on data
//   } else {
//     debugPrint("Regular notification received: ${message.notification?.title}");
//   }
//   // Call navigator or handle custom logic
//   FcmNavigator.handleNotificationRedirection(message);
// }
//
// // Background tap handler for local notifications
// @pragma('vm:entry-point')
// void _notificationTapBackground(NotificationResponse notificationResponse) {
//   debugPrint(
//       "Notification tapped in background: ${notificationResponse.payload}");
//   // Handle navigation or action based on payload
// }
//
// class FCMNotificationsController extends GetxController {
//   RemoteMessage? remoteMessage;
//
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   final AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     "com.google.firebase.messaging.default_notification_channel_id",
//     keyAppName.tr,
//     icon: "@drawable/ic_notification",
//     channelAction: AndroidNotificationChannelAction.createIfNotExists,
//     importance: Importance.max,
//     priority: Priority.max,
//   );
//
//   final DarwinNotificationDetails darwinPlatformChannelSpecifics =
//       const DarwinNotificationDetails(
//     presentAlert: true,
//     presentSound: true,
//     interruptionLevel: InterruptionLevel.active,
//   );
//
//   @override
//   void onInit() {
//     _initialize();
//     super.onInit();
//   }
//
//   void _initialize() async {
//     /// Configure local notifications
//     await _initializeNotification();
//
//     /// Initialize Firebase service and set up handlers
//     _initializeFirebaseService();
//   }
//
//   Future _initializeNotification() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings("@drawable/ic_notification");
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );
//
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       iOS: initializationSettingsDarwin,
//       android: initializationSettingsAndroid,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (details) {
//         debugPrint(
//             "Local notification tapped: ${details.id}, payload: ${details.payload}");
//         FcmNavigator.handleNotificationRedirection(remoteMessage);
//       },
//       onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
//     );
//
//     if (Platform.isAndroid) {
//       _requestAndroidPermissions();
//     } else if (Platform.isIOS) {
//       _requestIOSPermissions();
//     }
//   }
//
//   void _requestAndroidPermissions() async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//   }
//
//   Future<void> _requestIOSPermissions() async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }
//
//   void _initializeFirebaseService() async {
//     // Set foreground notification presentation options
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       sound: true,
//       badge: true,
//     );
//
//     // Request permission for notifications
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );
//
//     // Retrieve and store FCM token
//     FirebaseMessaging.instance.getToken().then((value) {
//       globalFCMToken = value;
//       debugPrint("FCM Token: $globalFCMToken");
//       // Optionally update token on server
//       // _updateTokenOnServer();
//     });
//
//     // Handle token refresh
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       globalFCMToken = newToken;
//       debugPrint("FCM Token Refreshed: $newToken");
//       // Optionally update token on server
//       // _updateTokenOnServer();
//     });
//
//     // Handle foreground messages (including silent notifications)
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("Foreground message received: ${message.messageId}");
//       remoteMessage = message;
//
//       if (message.notification != null) {
//         // Regular notification with visible content
//         showNotification(message: message);
//       } else if (message.data.isNotEmpty) {
//         // Silent notification
//         debugPrint("Silent notification in foreground: ${message.data}");
//         handleSilentNotification(message);
//       }
//     });
//
//     // Handle background messages (including silent notifications)
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     // Handle notification tap when app is opened from background/terminated
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint("App opened from notification: ${message.messageId}");
//       remoteMessage = message;
//       FcmNavigator.handleNotificationRedirection(message);
//     });
//
//     // Handle initial message when app is launched from terminated state
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       debugPrint("App launched from notification: ${initialMessage.messageId}");
//       remoteMessage = initialMessage;
//       FcmNavigator.handleNotificationRedirection(initialMessage);
//     }
//   }
//
//   // Show local notification for regular notifications
//   void showNotification({required RemoteMessage message}) async {
//     remoteMessage = message;
//     if (Platform.isIOS) {
//       // iOS handles notifications natively, so skip manual display unless needed
//       return;
//     }
//     var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: darwinPlatformChannelSpecifics,
//     );
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? "Default Title",
//       message.notification?.body ?? "Default Body",
//       platformChannelSpecifics,
//       payload: message.data['payload'] ?? '',
//     );
//   }
//
//   // Handle silent notifications
//   void handleSilentNotification(RemoteMessage message) async {
//     debugPrint("Processing silent notification: ${message.data}");
//     // Example: Process data payload
//     final data = message.data;
//     // Perform background tasks, e.g., update local storage, fetch data, etc.
//     // Example: if (data['type'] == 'update_content') { fetchNewContent(); }
//
//     // Optionally show a local notification based on data
//     if (data['show_local_notification'] == 'true') {
//       var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: darwinPlatformChannelSpecifics,
//       );
//       await flutterLocalNotificationsPlugin.show(
//         0,
//         data['title'] ?? "Silent Notification",
//         data['body'] ?? "New content available",
//         platformChannelSpecifics,
//         payload: data['payload'] ?? '',
//       );
//     }
//   }
// }

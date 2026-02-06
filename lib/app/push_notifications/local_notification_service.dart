import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../core/values/app_colors.dart';
import '../core/values/app_strings.dart';
import '../core/utils/localizations/localizations.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription =
      'This channel is used for important notifications.';

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notification response callback
  static NotificationResponse? _notificationResponse;
  static NotificationResponse? get notificationResponse =>
      _notificationResponse;

  // Background notification callback
  @pragma('vm:entry-point')
  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse notificationResponse) {
    _notificationResponse = notificationResponse;
    debugPrint(
        'Background notification tapped: ${notificationResponse.payload}');
    _handleNotificationTap(notificationResponse);
  }

  // Foreground notification callback
  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    _notificationResponse = notificationResponse;
    debugPrint(
        'Foreground notification tapped: ${notificationResponse.payload}');
    _handleNotificationTap(notificationResponse);
  }

  static void _handleNotificationTap(
      NotificationResponse notificationResponse) {
    try {
      if (notificationResponse.payload != null) {
        final Map<String, dynamic> payload =
            json.decode(notificationResponse.payload!);

        // Handle different notification types
        switch (payload['type']) {
          case 'ride_request':
            _handleRideRequestNotification(payload);
            break;
          case 'payment':
            _handlePaymentNotification(payload);
            break;
          case 'general':
            _handleGeneralNotification(payload);
            break;
          default:
            debugPrint('Unknown notification type: ${payload['type']}');
        }
      }
    } catch (e) {
      debugPrint('Error handling notification tap: $e');
    }
  }

  static void _handleRideRequestNotification(Map<String, dynamic> payload) {
    // Navigate to ride request screen
    Get.toNamed('/ride-request', arguments: payload);
  }

  static void _handlePaymentNotification(Map<String, dynamic> payload) {
    // Navigate to payment screen
    Get.toNamed('/payment', arguments: payload);
  }

  static void _handleGeneralNotification(Map<String, dynamic> payload) {
    // Navigate to general notification screen or show dialog
    Get.snackbar(
      'Notification',
      payload['message'] ?? 'New notification received',
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');

    // iOS initialization settings
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    // Request permissions
    await _requestPermissions();

    // Create notification channels
    await _createNotificationChannels();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      // final DarwinFlutterLocalNotificationsPlugin? iOSImplementation =
      //     _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      //         DarwinFlutterLocalNotificationsPlugin>();
      //
      // await iOSImplementation?.requestPermissions(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      //   criticalAlert: true,
      // );
    }
  }

  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        ledColor: Color.fromARGB(255, 255, 0, 0),
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  // Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
    bool playSound = true,
    bool enableVibration = true,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: playSound,
      enableVibration: enableVibration,
      enableLights: true,
      ledColor: AppColors.appColor,
      ledOnMs: 1000,
      ledOffMs: 500,
      icon: '@drawable/ic_notification',
      largeIcon:
          imageUrl != null ? DrawableResourceAndroidBitmap(imageUrl) : null,
      styleInformation: imageUrl != null
          ? BigPictureStyleInformation(
              DrawableResourceAndroidBitmap(imageUrl),
              largeIcon: DrawableResourceAndroidBitmap(imageUrl),
            )
          : null,
    );

    final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: playSound,
      interruptionLevel: InterruptionLevel.active,
      attachments: imageUrl != null
          ? [
              DarwinNotificationAttachment(imageUrl),
            ]
          : null,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Schedule notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String? imageUrl,
    bool playSound = true,
    bool enableVibration = true,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: playSound,
      enableVibration: enableVibration,
      enableLights: true,
      ledOnMs: 1000,
      ledOffMs: 500,
      icon: '@drawable/ic_notification',
      largeIcon:
          imageUrl != null ? DrawableResourceAndroidBitmap(imageUrl) : null,
    );

    final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: playSound,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // Show notification with actions
  Future<void> showNotificationWithActions({
    required int id,
    required String title,
    required String body,
    required List<NotificationAction> actions,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ledOnMs: 1000,
      ledOffMs: 500,
      icon: '@drawable/ic_notification',
      actions: actions
          .map((action) => AndroidNotificationAction(
                action.id,
                action.title,
                showsUserInterface: action.showsUserInterface,
                cancelNotification: action.cancelNotification,
              ))
          .toList(),
    );

    final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Check if notification is enabled
  Future<bool> isNotificationEnabled() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.areNotificationsEnabled() ?? false;
    } else if (Platform.isIOS) {
      // final DarwinFlutterLocalNotificationsPlugin? iOSImplementation =
      //     _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      //         DarwinFlutterLocalNotificationsPlugin>();
      // return await iOSImplementation?.requestPermissions(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // ) ?? false;
    }
    return false;
  }

  // Show ride request notification
  Future<void> showRideRequestNotification({
    required int id,
    required String passengerName,
    required String pickupLocation,
    required String dropLocation,
    required double fare,
  }) async {
    final payload = json.encode({
      'type': 'ride_request',
      'passenger_name': passengerName,
      'pickup_location': pickupLocation,
      'drop_location': dropLocation,
      'fare': fare,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await showNotificationWithActions(
      id: id,
      title: 'New Ride Request',
      body: '$passengerName wants a ride from $pickupLocation to $dropLocation',
      payload: payload,
      actions: [
        NotificationAction(
          id: 'accept_ride',
          title: 'Accept',
          showsUserInterface: true,
          cancelNotification: true,
        ),
        NotificationAction(
          id: 'reject_ride',
          title: 'Reject',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ],
    );
  }

  // Show payment notification
  Future<void> showPaymentNotification({
    required int id,
    required String title,
    required String body,
    required double amount,
  }) async {
    final payload = json.encode({
      'type': 'payment',
      'amount': amount,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }

  // Show general notification
  Future<void> showGeneralNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? additionalData,
  }) async {
    final payload = json.encode({
      'type': 'general',
      'title': title,
      'body': body,
      'additional_data': additionalData,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }

  // Show Firebase push notification as local notification
  Future<void> showFirebaseNotification({
    required RemoteMessage message,
    int? customId,
  }) async {
    final notification = message.notification;
    final data = message.data;

    if (notification == null) return;

    final id = customId ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final payload = json.encode({
      'type': data['type'] ?? 'firebase_push',
      'message_id': message.messageId,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await showNotification(
      id: id,
      title: notification.title ?? 'New Notification',
      body: notification.body ?? '',
      payload: payload,
      imageUrl: notification.android?.imageUrl,
    );
  }
}

// Helper class for notification actions
class NotificationAction {
  final String id;
  final String title;
  final bool showsUserInterface;
  final bool cancelNotification;
  final String? icon;

  NotificationAction({
    required this.id,
    required this.title,
    this.showsUserInterface = false,
    this.cancelNotification = false,
    this.icon,
  });
}

// Global instance
final LocalNotificationService localNotificationService =
    LocalNotificationService();

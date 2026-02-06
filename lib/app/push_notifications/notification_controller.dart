import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:good_citizen/app/common_data.dart';
import 'package:good_citizen/main.dart';

import 'local_notification_service.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  
  final LocalNotificationService _localNotificationService = localNotificationService;
  
  // Observable variables
  RxBool isNotificationEnabled = false.obs;
  RxList<Map<String, dynamic>> notificationHistory = <Map<String, dynamic>>[].obs;
  RxInt unreadNotificationCount = 0.obs;
  
  // Notification IDs
  static const int RIDE_REQUEST_NOTIFICATION_ID = 1001;
  static const int PAYMENT_NOTIFICATION_ID = 1002;
  static const int GENERAL_NOTIFICATION_ID = 1003;
  static const int REMINDER_NOTIFICATION_ID = 1004;
  
  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      // Initialize local notification service
      await _localNotificationService.initialize();
      
      // Check if notifications are enabled
      isNotificationEnabled.value = await _localNotificationService.isNotificationEnabled();
      
      // Set up Firebase messaging handlers
      _setupFirebaseMessaging();
      
      // Load notification history
      await _loadNotificationHistory();
      
      debugPrint('Notification system initialized successfully');
    } catch (e) {
      debugPrint('Error initializing notification system: $e');
    }
  }

  void _setupFirebaseMessaging() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpenedApp);
    
    // Handle initial notification when app is opened from killed state
    FirebaseMessaging.instance.getInitialMessage().then(_handleInitialMessage);
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message received: ${message.messageId}');
    
    // Show local notification for foreground messages
    _showLocalNotificationFromRemote(message);
    
    // Add to notification history
    _addToNotificationHistory(message);
  }

  // Handle notification when app is opened from background
  void _handleNotificationOpenedApp(RemoteMessage message) {
    debugPrint('App opened from notification: ${message.messageId}');
    
    // Add to notification history
    _addToNotificationHistory(message);
    
    // Navigate based on notification type
    _navigateBasedOnNotification(message);
  }

  // Handle initial message when app is opened from killed state
  void _handleInitialMessage(RemoteMessage? message) {
    if (message != null) {
      debugPrint('App opened from killed state with notification: ${message.messageId}');
      
      // Add to notification history
      _addToNotificationHistory(message);
      
      // Navigate based on notification type
      _navigateBasedOnNotification(message);
    }
  }

  // Show local notification from remote message
  void _showLocalNotificationFromRemote(RemoteMessage message) {
    // Use the new showFirebaseNotification method
    _localNotificationService.showFirebaseNotification(
      message: message,
      customId: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  void _addToNotificationHistory(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final notificationData = {
      'id': message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'title': notification.title ?? '',
      'body': notification.body ?? '',
      'data': message.data,
      'timestamp': DateTime.now().toIso8601String(),
      'isRead': false,
    };

    notificationHistory.insert(0, notificationData);
    unreadNotificationCount.value++;
    
    // Save to local storage
    _saveNotificationHistory();
  }

  void _navigateBasedOnNotification(RemoteMessage message) {
    final data = message.data;
    final notificationType = data['type'] ?? 'general';
    
    switch (notificationType) {
      case 'ride_request':
        Get.toNamed('/ride-request', arguments: data);
        break;
      case 'payment':
        Get.toNamed('/payment', arguments: data);
        break;
      case 'reminder':
        Get.toNamed('/reminders', arguments: data);
        break;
      default:
        Get.toNamed('/notifications', arguments: data);
    }
  }

  // Public methods for showing notifications

  // Show ride request notification
  Future<void> showRideRequest({
    required String passengerName,
    required String pickupLocation,
    required String dropLocation,
    required double fare,
  }) async {
    await _localNotificationService.showRideRequestNotification(
      id: RIDE_REQUEST_NOTIFICATION_ID,
      passengerName: passengerName,
      pickupLocation: pickupLocation,
      dropLocation: dropLocation,
      fare: fare,
    );
  }

  // Show payment notification
  Future<void> showPayment({
    required String title,
    required String body,
    required double amount,
  }) async {
    await _localNotificationService.showPaymentNotification(
      id: PAYMENT_NOTIFICATION_ID,
      title: title,
      body: body,
      amount: amount,
    );
  }

  // Show general notification
  Future<void> showGeneral({
    required String title,
    required String body,
    Map<String, dynamic>? additionalData,
  }) async {
    await _localNotificationService.showGeneralNotification(
      id: GENERAL_NOTIFICATION_ID,
      title: title,
      body: body,
      additionalData: additionalData,
    );
  }

  // Schedule reminder notification
  Future<void> scheduleReminder({
    required String title,
    required String body,
    required DateTime scheduledDate,
    Map<String, dynamic>? additionalData,
  }) async {
    await _localNotificationService.scheduleNotification(
      id: REMINDER_NOTIFICATION_ID,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: json.encode({
        'type': 'reminder',
        'data': additionalData,
      }),
    );
  }

  // Show Firebase push notification as local notification
  Future<void> showFirebaseNotification(RemoteMessage message) async {
    await _localNotificationService.showFirebaseNotification(
      message: message,
    );
  }

  // Mark notification as read
  void markNotificationAsRead(String notificationId) {
    final index = notificationHistory.indexWhere((notification) => notification['id'] == notificationId);
    if (index != -1) {
      notificationHistory[index]['isRead'] = true;
      unreadNotificationCount.value = unreadNotificationCount.value > 0 
          ? unreadNotificationCount.value - 1 
          : 0;
      _saveNotificationHistory();
    }
  }

  // Mark all notifications as read
  void markAllNotificationsAsRead() {
    for (var notification in notificationHistory) {
      notification['isRead'] = true;
    }
    unreadNotificationCount.value = 0;
    _saveNotificationHistory();
  }

  // Clear notification history
  void clearNotificationHistory() {
    notificationHistory.clear();
    unreadNotificationCount.value = 0;
    _saveNotificationHistory();
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotificationService.cancelAllNotifications();
  }

  // Get pending notifications
  Future<List<dynamic>> getPendingNotifications() async {
    return await _localNotificationService.getPendingNotifications();
  }

  // Load notification history from local storage
  Future<void> _loadNotificationHistory() async {
    try {
      final String? historyJson = await preferenceManager.getNotificationHistory();
      if (historyJson != null) {
        final List<dynamic> history = json.decode(historyJson);
        notificationHistory.value = history.cast<Map<String, dynamic>>();
        
        // Calculate unread count
        unreadNotificationCount.value = notificationHistory
            .where((notification) => notification['isRead'] == false)
            .length;
      }
    } catch (e) {
      debugPrint('Error loading notification history: $e');
    }
  }

  // Save notification history to local storage
  Future<void> _saveNotificationHistory() async {
    try {
      final String historyJson = json.encode(notificationHistory);
      await preferenceManager.setNotificationHistory(historyJson);
    } catch (e) {
      debugPrint('Error saving notification history: $e');
    }
  }

  // Check notification permissions
  Future<bool> checkNotificationPermissions() async {
    isNotificationEnabled.value = await _localNotificationService.isNotificationEnabled();
    return isNotificationEnabled.value;
  }

  // Request notification permissions
  Future<void> requestNotificationPermissions() async {
    // The permission request is handled in the LocalNotificationService
    isNotificationEnabled.value = await _localNotificationService.isNotificationEnabled();
  }
}

// Background message handler is now defined in main.dart 
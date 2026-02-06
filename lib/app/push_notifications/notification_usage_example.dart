// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'notification_controller.dart';
//
// /// This file contains examples of how to use the notification system
// /// in different scenarios: foreground, background, and kill mode.
// class NotificationUsageExample {
//   static final NotificationController _controller = NotificationController.to;
//
//   /// Example 1: Show a ride request notification
//   /// This will work in foreground, background, and kill mode
//   static Future<void> showRideRequestExample() async {
//     await _controller.showRideRequest(
//       passengerName: 'John Doe',
//       pickupLocation: 'Central Park, New York',
//       dropLocation: 'Times Square, New York',
//       fare: 25.50,
//     );
//   }
//
//   /// Example 2: Show a payment notification
//   static Future<void> showPaymentExample() async {
//     await _controller.showPayment(
//       title: 'Payment Received',
//       body: 'You received \$25.50 for your recent ride',
//       amount: 25.50,
//     );
//   }
//
//   /// Example 3: Show a general notification
//   static Future<void> showGeneralExample() async {
//     await _controller.showGeneral(
//       title: 'App Update',
//       body: 'A new version of the app is available',
//       additionalData: {
//         'version': '2.1.0',
//         'features': ['Bug fixes', 'Performance improvements'],
//       },
//     );
//   }
//
//   /// Example 4: Schedule a reminder notification
//   static Future<void> scheduleReminderExample() async {
//     // Schedule a reminder for 5 minutes from now
//     final scheduledTime = DateTime.now().add(const Duration(minutes: 5));
//
//     await _controller.scheduleReminder(
//       title: 'Ride Reminder',
//       body: 'You have a scheduled ride in 5 minutes',
//       scheduledDate: scheduledTime,
//       additionalData: {
//         'ride_id': '12345',
//         'pickup_time': scheduledTime.toIso8601String(),
//       },
//     );
//   }
//
//   /// Example 5: Show notification with custom actions
//   static Future<void> showNotificationWithActions() async {
//     // This example shows how to create a notification with custom actions
//     // The actions will be handled in the LocalNotificationService
//
//     final payload = {
//       'type': 'custom_action',
//       'action_id': 'unique_action_id',
//       'data': {
//         'message': 'This is a custom action notification',
//         'timestamp': DateTime.now().toIso8601String(),
//       },
//     };
//
//     // You can use the local notification service directly for more control
//     await _controller.l
//       id: 2001,
//       title: 'Custom Action Notification',
//       body: 'Tap to perform custom actions',
//       payload: payload.toString(),
//       actions: [
//         NotificationAction(
//           id: 'action_1',
//           title: 'Action 1',
//           showsUserInterface: true,
//           cancelNotification: false,
//         ),
//         NotificationAction(
//           id: 'action_2',
//           title: 'Action 2',
//           showsUserInterface: false,
//           cancelNotification: true,
//         ),
//       ],
//     );
//   }
//
//   /// Example 6: Handle notification tap in different app states
//   static void handleNotificationTap(String notificationId) {
//     // This method shows how to handle notification taps
//     // The actual handling is done in the LocalNotificationService
//
//     // Mark notification as read
//     _controller.markNotificationAsRead(notificationId);
//
//     // Navigate based on notification type
//     // This is already handled in the LocalNotificationService
//   }
//
//   /// Example 7: Check notification permissions
//   static Future<bool> checkPermissions() async {
//     return await _controller.checkNotificationPermissions();
//   }
//
//   /// Example 8: Request notification permissions
//   static Future<void> requestPermissions() async {
//     await _controller.requestNotificationPermissions();
//   }
//
//   /// Example 9: Get notification history
//   static List<Map<String, dynamic>> getNotificationHistory() {
//     return _controller.notificationHistory.toList();
//   }
//
//   /// Example 10: Clear all notifications
//   static Future<void> clearAllNotifications() async {
//     await _controller.cancelAllNotifications();
//     _controller.clearNotificationHistory();
//   }
//
//   /// Example 11: Get unread notification count
//   static int getUnreadCount() {
//     return _controller.unreadNotificationCount.value;
//   }
//
//   /// Example 12: Mark all notifications as read
//   static void markAllAsRead() {
//     _controller.markAllNotificationsAsRead();
//   }
// }
//
// /// Example widget that demonstrates notification usage
// class NotificationExampleWidget extends StatelessWidget {
//   const NotificationExampleWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notification Examples'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildExampleButton(
//               'Show Ride Request',
//               Icons.local_taxi,
//               () => NotificationUsageExample.showRideRequestExample(),
//             ),
//             const SizedBox(height: 12),
//             _buildExampleButton(
//               'Show Payment Notification',
//               Icons.payment,
//               () => NotificationUsageExample.showPaymentExample(),
//             ),
//             const SizedBox(height: 12),
//             _buildExampleButton(
//               'Show General Notification',
//               Icons.info,
//               () => NotificationUsageExample.showGeneralExample(),
//             ),
//             const SizedBox(height: 12),
//             _buildExampleButton(
//               'Schedule Reminder (5 min)',
//               Icons.schedule,
//               () => NotificationUsageExample.scheduleReminderExample(),
//             ),
//             const SizedBox(height: 12),
//             _buildExampleButton(
//               'Show Custom Action Notification',
//               Icons.touch_app,
//               () => NotificationUsageExample.showNotificationWithActions(),
//             ),
//             const SizedBox(height: 12),
//             _buildExampleButton(
//               'Check Permissions',
//               Icons.security,
//               () async {
//                 final hasPermission = await NotificationUsageExample.checkPermissions();
//                 Get.snackbar(
//                   'Permissions',
//                   hasPermission ? 'Notifications enabled' : 'Notifications disabled',
//                 );
//               },
//             ),
//             const SizedBox(height: 12),
//             _buildExampleButton(
//               'Request Permissions',
//               Icons.notifications_active,
//               () => NotificationUsageExample.requestPermissions(),
//             ),
//             const SizedBox(height: 12),
//             _buildExampleButton(
//               'Clear All Notifications',
//               Icons.clear_all,
//               () => NotificationUsageExample.clearAllNotifications(),
//             ),
//             const SizedBox(height: 12),
//             _buildExampleButton(
//               'Mark All as Read',
//               Icons.mark_email_read,
//               () => NotificationUsageExample.markAllAsRead(),
//             ),
//             const SizedBox(height: 20),
//             _buildInfoCard(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildExampleButton(String title, IconData icon, VoidCallback onPressed) {
//     return ElevatedButton.icon(
//       onPressed: onPressed,
//       icon: Icon(icon),
//       label: Text(title),
//       style: ElevatedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//       ),
//     );
//   }
//
//   Widget _buildInfoCard() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Notification System Features:',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             _buildFeatureItem('✅ Foreground notifications'),
//             _buildFeatureItem('✅ Background notifications'),
//             _buildFeatureItem('✅ Kill mode notifications'),
//             _buildFeatureItem('✅ Scheduled notifications'),
//             _buildFeatureItem('✅ Notification actions'),
//             _buildFeatureItem('✅ Notification history'),
//             _buildFeatureItem('✅ Unread count tracking'),
//             _buildFeatureItem('✅ Permission management'),
//             _buildFeatureItem('✅ Custom payloads'),
//             _buildFeatureItem('✅ Cross-platform support'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeatureItem(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Text(text),
//     );
//   }
// }
//
// /// Usage in your app:
// ///
// /// 1. Initialize the notification system in main.dart:
// ///    ```dart
// ///    Get.put(NotificationController());
// ///    ```
// ///
// /// 2. Use the notification badge widget:
// ///    ```dart
// ///    NotificationBadgeWidget(
// ///      child: IconButton(
// ///        icon: Icon(Icons.notifications),
// ///        onPressed: () => Get.toNamed('/notifications'),
// ///      ),
// ///    )
// ///    ```
// ///
// /// 3. Show notifications from anywhere in your app:
// ///    ```dart
// ///    NotificationController.to.showRideRequest(
// ///      passengerName: 'John Doe',
// ///      pickupLocation: 'Central Park',
// ///      dropLocation: 'Times Square',
// ///      fare: 25.50,
// ///    );
// ///    ```
// ///
// /// 4. Handle notification taps:
// ///    The system automatically handles notification taps and navigates
// ///    to the appropriate screen based on the notification type.
// ///
// /// 5. Check notification status:
// ///    ```dart
// ///    final hasPermission = await NotificationController.to.checkNotificationPermissions();
// ///    final unreadCount = NotificationController.to.unreadNotificationCount.value;
// ///    ```
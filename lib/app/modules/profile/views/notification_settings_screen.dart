import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/app_strings.dart';
import '../../../core/utils/localizations/localizations.dart';
import '../../../push_notifications/notification_controller.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Notification Settings'.tr),
            backgroundColor: AppColors.transparentBgColor,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification permission status
                _buildPermissionStatusCard(controller),
                const SizedBox(height: 16),
                
                // Notification types
                _buildNotificationTypesCard(controller),
                const SizedBox(height: 16),
                
                // Notification history
                _buildNotificationHistoryCard(controller),
                const SizedBox(height: 16),
                
                // Notification actions
                _buildNotificationActionsCard(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPermissionStatusCard(NotificationController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Permissions'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  controller.isNotificationEnabled.value
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  color: controller.isNotificationEnabled.value
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.isNotificationEnabled.value
                            ? 'Notifications Enabled'.tr
                            : 'Notifications Disabled'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        controller.isNotificationEnabled.value
                            ? 'You will receive notifications for ride requests, payments, and updates.'.tr
                            : 'Enable notifications to stay updated with ride requests and payments.'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!controller.isNotificationEnabled.value)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.requestNotificationPermissions(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Enable Notifications'.tr),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTypesCard(NotificationController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Types'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildNotificationTypeTile(
              icon: Icons.local_taxi,
              title: 'Ride Requests'.tr,
              subtitle: 'Get notified when passengers request rides.'.tr,
              enabled: true,
            ),
            _buildNotificationTypeTile(
              icon: Icons.payment,
              title: 'Payment Notifications'.tr,
              subtitle: 'Receive updates about payments and transactions.'.tr,
              enabled: true,
            ),
            _buildNotificationTypeTile(
              icon: Icons.schedule,
              title: 'Reminders'.tr,
              subtitle: 'Get reminded about scheduled rides and appointments.'.tr,
              enabled: true,
            ),
            _buildNotificationTypeTile(
              icon: Icons.info,
              title: 'General Updates'.tr,
              subtitle: 'Receive general app updates and announcements.'.tr,
              enabled: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTypeTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: enabled ? AppColors.appColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: enabled ? Colors.black : Colors.grey,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: enabled ? Colors.grey[600] : Colors.grey,
        ),
      ),
      trailing: Switch(
        value: enabled,
        onChanged: (value) {
          // Handle notification type toggle
        },
        activeColor: AppColors.appColor,
      ),
    );
  }

  Widget _buildNotificationHistoryCard(NotificationController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notification History'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${controller.unreadNotificationCount.value} unread'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (controller.notificationHistory.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No notifications yet'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: [
                  ...controller.notificationHistory.take(3).map((notification) =>
                    _buildNotificationHistoryTile(notification, controller),
                  ),
                  if (controller.notificationHistory.length > 3)
                    TextButton(
                      onPressed: () {
                        // Navigate to full notification history
                        Get.toNamed('/notification-history');
                      },
                      child: Text('View All Notifications'.tr),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationHistoryTile(
    Map<String, dynamic> notification,
    NotificationController controller,
  ) {
    final isRead = notification['isRead'] ?? false;
    final title = notification['title'] ?? '';
    final body = notification['body'] ?? '';
    final timestamp = DateTime.tryParse(notification['timestamp'] ?? '') ?? DateTime.now();

    return ListTile(
      leading: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isRead ? Colors.transparent : AppColors.appColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            _formatTimestamp(timestamp),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      onTap: () {
        controller.markNotificationAsRead(notification['id']);
      },
    );
  }

  Widget _buildNotificationActionsCard(NotificationController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.mark_email_read),
              title: Text('Mark All as Read'.tr),
              onTap: () {
                controller.markAllNotificationsAsRead();
                Get.snackbar(
                  'Success'.tr,
                  'All notifications marked as read.'.tr,
                  snackPosition: SnackPosition.TOP,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: Text('Clear All Notifications'.tr),
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: Text('Clear Notifications'.tr),
                    content: Text('Are you sure you want to clear all notifications?'.tr),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancel'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.clearNotificationHistory();
                          Get.back();
                          Get.snackbar(
                            'Success'.tr,
                            'All notifications cleared.'.tr,
                            snackPosition: SnackPosition.TOP,
                          );
                        },
                        child: Text('Clear'.tr),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Test Notification'.tr),
              onTap: () {
                controller.showGeneral(
                  title: 'Test Notification'.tr,
                  body: 'This is a test notification to verify your settings.'.tr,
                );
                Get.snackbar(
                  'Test Notification'.tr,
                  'Test notification sent!'.tr,
                  snackPosition: SnackPosition.TOP,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
} 
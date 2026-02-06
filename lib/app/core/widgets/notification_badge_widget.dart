import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../values/app_colors.dart';
import '../../push_notifications/notification_controller.dart';

class NotificationBadgeWidget extends StatelessWidget {
  final Widget child;
  final double? top;
  final double? end;
  final Color? badgeColor;
  final Color? textColor;
  final double? badgeSize;
  final double? fontSize;

  const NotificationBadgeWidget({
    Key? key,
    required this.child,
    this.top,
    this.end,
    this.badgeColor,
    this.textColor,
    this.badgeSize,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            if (controller.unreadNotificationCount.value > 0)
              Positioned(
                top: top ?? -5,
                // end: end ?? -5,
                child: Container(
                  width: badgeSize ?? 20,
                  height: badgeSize ?? 20,
                  decoration: BoxDecoration(
                    color: badgeColor ?? AppColors.appColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      controller.unreadNotificationCount.value > 99
                          ? '99+'
                          : controller.unreadNotificationCount.value.toString(),
                      style: TextStyle(
                        color: textColor ?? Colors.white,
                        fontSize: fontSize ?? 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class NotificationIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double? iconSize;
  final Color? iconColor;
  final double? badgeSize;
  final Color? badgeColor;
  final Color? badgeTextColor;

  const NotificationIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.iconColor,
    this.badgeSize,
    this.badgeColor,
    this.badgeTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationBadgeWidget(
      badgeColor: badgeColor,
      textColor: badgeTextColor,
      badgeSize: badgeSize,
      child: IconButton(
        icon: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
} 
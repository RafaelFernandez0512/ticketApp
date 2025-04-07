import 'package:flutter/material.dart';

enum NotificationType {
  success,
  warning,
  error,
  normal,
}

const Map<NotificationType, Color> notificationTypeColors = {
  NotificationType.success: Color(0xFF60C664),
  NotificationType.warning: Color(0xFFFBBA5A),
  NotificationType.error: Color(0xFFFB5A5A),
  NotificationType.normal: Color(0xFF232B59),
};

const Map<NotificationType, IconData> notificationTypeIcons = {
  NotificationType.success: Icons.check,
  NotificationType.warning: Icons.warning,
  NotificationType.error: Icons.error_rounded,
  NotificationType.normal: Icons.notification_important_outlined,
};

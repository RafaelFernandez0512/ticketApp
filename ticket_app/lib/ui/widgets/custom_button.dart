import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:ticket_app/utils/notification_type.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Icon icon;
  final NotificationType? type;
  final void Function()? onPressed;
  final IconAlignment iconAlignment;

  const CustomButton({
    super.key,
    required this.label,
    required this.icon,
    this.type = NotificationType.normal,
    this.onPressed,
    this.iconAlignment = IconAlignment.end,
  });

  @override
  Widget build(BuildContext context) {
    var labelWidget = label.isEmpty
        ? const SizedBox.shrink()
        : Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          );

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      iconAlignment: iconAlignment,
      label: labelWidget,
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 20, horizontal: 25)),
        backgroundColor: WidgetStateProperty.all(onPressed == null
            ? const Color(0xffB3B3B3)
            : notificationTypeColors[type]),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

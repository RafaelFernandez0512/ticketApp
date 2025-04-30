import 'package:flutter/material.dart';
import 'package:ticket_app/ui/widgets/custom_button.dart';
import 'package:ticket_app/utils/gaps.dart';
import 'package:ticket_app/utils/notification_type.dart';

class CustomPopUp extends StatelessWidget {
  final String title;
  final String descripcion;
  String cancelText;
  String okText;
  final NotificationType type;
  final bool showCancelBtn;
  final void Function()? onCancelPressed;

  final void Function()? onPressed;
  final IconData icon;
  CustomPopUp(
      {super.key,
      required this.title,
      required this.descripcion,
      required this.type,
      this.okText = 'Ok',
      this.cancelText = 'Cancel',
      this.showCancelBtn = false,
      this.onCancelPressed,
      this.onPressed,
      this.icon = Icons.info});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        Icon(icon,
            color: type == NotificationType.error
                ? Colors.red
                : type == NotificationType.success
                    ? Colors.green
                    : Colors.blue,
            size: 50),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        gapH16,
        Text(
          descripcion,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        gapH16,
        Row(
          children: [
            Expanded(
                child: CustomButton(
                    type: NotificationType.error,
                    label: cancelText,
                    iconAlignment: IconAlignment.start,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: onCancelPressed)),
            gapW20,
            Expanded(
                child: CustomButton(
                    type: NotificationType.success,
                    label: okText,
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: onPressed)),
          ],
        )
      ],
    );
  }
}

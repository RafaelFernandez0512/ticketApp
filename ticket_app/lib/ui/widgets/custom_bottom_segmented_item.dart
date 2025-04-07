import 'package:flutter/material.dart';
import 'package:ticket_app/utils/gaps.dart';

class CustomBottomSegmentedControlItem extends StatelessWidget {
  final bool isSelected;
  final String text;
  final IconData? icon;

  const CustomBottomSegmentedControlItem({
    required this.text,
    this.icon,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null
              ? Icon(
                  icon,
                  color: isSelected ? Colors.black : Colors.white,
                  size: 15,
                )
              : SizedBox.shrink(),
          gapW4,
          Flexible(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}

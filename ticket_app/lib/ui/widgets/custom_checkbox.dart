import 'package:flutter/material.dart';
import 'package:ticket_app/utils/gaps.dart';

class CustomCheckbox extends StatelessWidget {
  final bool? value;
  final void Function(bool?)? onChanged;
  final String? label;
  final bool labelToLeft;
  final bool? bold;
  final TextStyle? textStyle;
  final double size;
  final bool spaceBetween;
  final EdgeInsetsGeometry padding;

  const CustomCheckbox({
    super.key,
    this.value,
    this.onChanged,
    this.label,
    this.labelToLeft = false,
    this.bold = false,
    this.textStyle,
    this.size = 20,
    this.spaceBetween = false,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    var labelWidget = Flexible(
      child: GestureDetector(
        onTap: onChanged == null
            ? null
            : () {
                onChanged!(!value!);
              },
        child: Text(
          label ?? "",
          style: textStyle ??
              TextStyle(
                //overflow: TextOverflow.ellipsis,
                color: onChanged == null ? Colors.black54 : Colors.black,
                fontWeight: FontWeight.normal,
              ),
        ),
      ),
    );
    var showLabel = label != null && label!.isNotEmpty;

    List<Widget> children = [];

    if (labelToLeft && showLabel) {
      children.add(labelWidget);
      children.add(gapW4);
    }
    children.add(InkWell(
      onTap: onChanged == null
          ? null
          : () {
              onChanged!(!value!);
            },
      child: Container(
        decoration: BoxDecoration(
          color: value!
              ? (onChanged == null
                  ? Colors.black54.withOpacity(0.3)
                  : const Color.fromARGB(255, 50, 175, 0))
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
              color: onChanged == null
                  ?const Color.fromARGB(255, 240, 103, 103)
                  : !(value??true)? const Color.fromARGB(255, 240, 103, 103): const Color.fromARGB(255, 50, 175, 0),
              width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: value!
              ? Icon(
                  Icons.check,
                  size: size,
                  color: Colors.white,
                )
              : SizedBox(
                  height: size,
                  width: size,
                ),
        ),
      ),
    ));
    if (!labelToLeft && showLabel) {
      children.add(gapW4);
      children.add(labelWidget);
    }

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: spaceBetween
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: children,
      ),
    );
  }
}

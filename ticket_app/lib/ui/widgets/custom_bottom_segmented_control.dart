import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticket_app/ui/widgets/custom_bottom_segmented_item.dart';
import 'package:ticket_app/utils/gaps.dart';


/// A bottom-aligned segmented control that renders either a
/// [CupertinoSlidingSegmentedControl] (if multiple items) or
/// a static layout (if only one item).
///
/// [T] is the type used for the segment values.
class CustomBottomSegmentedControl<T extends Object> extends StatelessWidget {
  /// The current selected value for the segmented control.
  final T? groupValue;

  /// The segments to render in the control. The key is the value of type [T],
  /// and the value is a [CustomBottomSegmentedControlItem], which includes
  /// an icon and text.
  final Map<T, CustomBottomSegmentedControlItem> children;

  /// The padding around the entire widget.
  /// Defaults to [EdgeInsets.all(1)] if `null`.
  final EdgeInsetsGeometry? padding;

  /// Callback invoked when the user taps a segment, passing the new [groupValue].
  final ValueChanged<T?> onValueChanged;

  /// Creates a [CustomBottomSegmentedControl] widget.
  const CustomBottomSegmentedControl({
    super.key,
    required this.children,
    required this.onValueChanged,
    this.groupValue,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(1),
      child: children.length == 1
          ? Container(
              padding: const EdgeInsets.all(6),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: const EdgeInsets.all(6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      children.values.first.icon,
                      color: Colors.black,
                      size: 12,
                    ),
                    gapW4,
                    Flexible(
                      child: Text(
                        children.values.first.text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: CupertinoSlidingSegmentedControl<T>(
                    thumbColor: Colors.white,
                    groupValue: groupValue,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    children: children,
                    onValueChanged: onValueChanged,
                  ),
                ),
              ],
            ),
    );
  }
}

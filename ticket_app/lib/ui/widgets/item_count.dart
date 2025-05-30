import 'package:flutter/material.dart';
import 'package:ticket_app/utils/gaps.dart';

typedef CounterChangeCallback = void Function(num value);

// ignore: must_be_immutable
class ItemCount extends StatelessWidget {
  final CounterChangeCallback onChanged;

  ItemCount({
    Key? key,
    required int initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.decimalPlaces,
    required this.labelText,
    this.color,
    this.textStyle,
    this.step = 1,
    this.buttonSizeWidth = 45,
    this.buttonSizeHeight = 35,
  })  : assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue,
        super(key: key);

  ///min value user can pick
  final num minValue;
  final String labelText;

  ///max value user can pick
  final num maxValue;

  /// decimal places required by the counter
  final int decimalPlaces;

  ///Currently selected integer value
  num selectedValue;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final num step;

  /// indicates the color of fab used for increment and decrement
  Color? color;

  /// text syle
  TextStyle? textStyle;

  final double buttonSizeWidth, buttonSizeHeight;

  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged((selectedValue + step));
    }
  }

  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged((selectedValue - step));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labelText,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Spacer(),
          GestureDetector(
            onTap: _decrementCounter,
            child: SizedBox(
              width: buttonSizeWidth,
              height: buttonSizeHeight,
              child: Container(
                decoration: ShapeDecoration(
                    color: color ?? themeData.primaryColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0)))),
                child: Center(
                  child: Text(
                    '-',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          gapW16,
          Container(
              padding: EdgeInsets.all(4.0),
              child: Text(
                '${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
              )),
          gapW16,
          GestureDetector(
            onTap: _incrementCounter,
            child: SizedBox(
              width: buttonSizeWidth,
              height: buttonSizeHeight,
              child: Container(
                decoration: ShapeDecoration(
                    color: color ?? themeData.primaryColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)))),
                child: Center(
                  child: Text(
                    '+',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

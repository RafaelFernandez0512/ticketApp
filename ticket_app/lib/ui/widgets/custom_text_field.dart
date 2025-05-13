import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:ticket_app/utils/gaps.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextStyle? labelStyle;
  final String? initialValue;
  final bool fullWidth;
  final TextInputType? keyboard;
  final String? errorMessage;
  final bool obscureText;
  final bool? readOnly;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextAlign textAlign;
  final List<TextInputFormatter> inputFormatters;
  final InputDecoration? decoration;
  final int maxLines;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool showCounter;
  final TextEditingController? controller;
  final bool filled;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.hintText = "",
    this.labelStyle = null,
    this.initialValue,
    this.fullWidth = true,
    this.keyboard = TextInputType.text,
    this.errorMessage,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.maxLength,
    this.readOnly,
    this.textAlign = TextAlign.start,
    this.inputFormatters = const [],
    this.decoration,
    this.maxLines = 1,
    this.focusNode,
    this.autofocus = false,
    this.showCounter = true,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      color: Colors.transparent,
      width: fullWidth ? size.width : size.width / 2.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText.isNotEmpty)
            Text(labelText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .primaryColor
                        .withOpacity((readOnly ?? false) ? 0.7 : 1))),
          if (labelText.isNotEmpty) gapH4,
          Container(
            decoration: !filled
                ? null
                : BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: maxLength != null || errorMessage != null
                        ? null
                        : [
                            BoxShadow(
                              color: const Color(0x00000000).withOpacity(0.25),
                              offset: const Offset(
                                0.0,
                                4.0,
                              ),
                              blurRadius: 4.0,
                              spreadRadius: 0.0,
                            )
                          ]),
            child: TextFormField(
              key: key,
              style: labelStyle ??
                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context)
                            .primaryColor
                            .withOpacity((readOnly ?? false) ? 0.7 : 1),
                      ),
              onChanged: onChanged,
              validator: validator,
              obscureText: obscureText,
              textAlign: textAlign,
              keyboardType: keyboard,
              maxLength: maxLength,
              maxLines: maxLines,
              controller: controller,
              readOnly: readOnly ?? false,
              initialValue: initialValue,
              inputFormatters: inputFormatters,
              focusNode: focusNode,
              autofocus: autofocus,
              decoration: decoration ??
                  InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    errorText: errorMessage,
                    hintText: hintText,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: const Color(0xFFB7B7B7)),
                    counterText: !showCounter ? "" : null,
                    fillColor: (readOnly ?? false)
                        ? const Color(0xFFDCDEDF)
                        : const Color(0xFFF1F4F7),
                    filled: filled,
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.only(
                      left: 4.sp,
                      right: 4.sp,
                      bottom: 4.sp,
                      top: 3.sp,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

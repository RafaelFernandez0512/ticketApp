import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class VerificationCode extends StatelessWidget {
  const VerificationCode({super.key,});

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 6,
      defaultPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: Theme.of(context).textTheme.headlineMedium,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 50,
        height: 50,
        textStyle: Theme.of(context).textTheme.headlineMedium,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
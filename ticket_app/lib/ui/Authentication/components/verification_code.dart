import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:ticket_app/custom_theme.dart';
import 'package:ticket_app/utils/gaps.dart';

class VerificationCode extends StatelessWidget {
  final void Function(String)? onCompleted;
  final String username;
  final String verificationCode;
  final Future<void> Function()? resendCode;
  const VerificationCode(
      {super.key,
      this.onCompleted,
      required this.username,
      required this.verificationCode,
      this.resendCode});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: CustomTheme.primaryLightColor),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    return Column(
      children: [
        Text('Verification Code',
            style: Theme.of(context).textTheme.headlineMedium),
        gapH20,
        Text(
          'We have sent a verification code to ',
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        gapH8,
        Text(
          username,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: CustomTheme.black,
              ),
          textAlign: TextAlign.center,
        ),
        gapH20,
        Pinput(
          length: 6,
          onCompleted: onCompleted,
          closeKeyboardWhenCompleted: true,
          errorPinTheme: defaultPinTheme.copyDecorationWith(
            border: Border.all(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the code';
            }
            if (value != verificationCode) {
              return 'Invalid code';
            }
            return null;
          },
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyDecorationWith(
            border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
            borderRadius: BorderRadius.circular(8),
          ),
          submittedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              color: Color.fromRGBO(234, 239, 243, 1),
            ),
          ),
        ),
        gapH20,
        TextButton(
          onPressed: () {},
          child: Text("Resend Code",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  )),
        )
      ],
    );
  }
}

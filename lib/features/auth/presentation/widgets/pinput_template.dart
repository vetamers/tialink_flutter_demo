import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class TiaLinkPinPut extends StatelessWidget {
  final void Function(String code)? onSubmit;
  final TextEditingController controller;
  final FocusNode focusNode;

  const TiaLinkPinPut({Key? key, required this.onSubmit, required this.controller, required this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(232, 235, 241, 0.37),
        borderRadius: BorderRadius.circular(24),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return Pinput(
      length: 4,
      controller: controller,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      separator: const SizedBox(width: 16),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
              offset: Offset(0, 3),
              blurRadius: 16,
            )
          ],
        ),
      ),
      showCursor: true,
      cursor: cursor,
      onCompleted: onSubmit,
    );
  }
}

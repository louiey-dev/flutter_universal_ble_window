import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool enabled;

  final double width = 100;
  final double height = 30;

  const PlatformButton({
    required this.text,
    required this.onPressed,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return (!kIsWeb && (Platform.isMacOS || Platform.isIOS))
        ? CupertinoButton.filled(
          onPressed: enabled ? onPressed : null,
          // color: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          disabledColor: Colors.grey,
          child: Text(text),
        )
        : ElevatedButton(
          style: ElevatedButton.styleFrom(
            // minimumSize: Size(width, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: enabled ? onPressed : null,
          child: Text(text),
        );
  }
}

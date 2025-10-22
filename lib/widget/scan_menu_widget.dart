import 'package:flutter/material.dart';
// import 'package:flutter_universal_ble_window/feature/my_type.dart';
// import 'package:flutter_universal_ble_window/feature/my_utils.dart';
import 'package:flutter_universal_ble_window/widget/my_button.dart';
import 'package:flutter_universal_ble_window/widget/my_widget.dart';

class ScanMenuWidget extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onScanPressed;
  final VoidCallback onStopPressed;
  // final BoolCallback onNaPressed;

  // final bool _switch = onNaPressed();

  ScanMenuWidget({
    super.key,
    required this.isScanning,
    required this.onScanPressed,
    required this.onStopPressed,
    // required this.onNaPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PlatformButton(
                text: "Scan",
                onPressed: onScanPressed,
                enabled: !isScanning,
              ),
              myWIDTH(10),
              PlatformButton(
                text: "Scan Stop",
                onPressed: onStopPressed,
                enabled: isScanning,
              ),
              myWIDTH(10),
            ],
          ),
        ],
      ),
    );
  }
}

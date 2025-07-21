import 'package:flutter/material.dart';
import 'package:flutter_universal_ble_window/screen/scan_screen.dart';

class ScanResultWidget extends StatefulWidget {
  const ScanResultWidget({super.key});

  @override
  State<ScanResultWidget> createState() => _ScanResultWidgetState();
}

class _ScanResultWidgetState extends State<ScanResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          controller: scanScrollController,
          child: Text(
            scanMessage.join('\n'), // Join messages with newlines
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ScanStatusWidget extends StatelessWidget {
  final bool isScanning;

  const ScanStatusWidget({super.key, required this.isScanning});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isScanning ? "Scanning..." : "Scan stopped",
            style: const TextStyle(fontSize: 16, color: Colors.blue),
          ),
          const SizedBox(width: 30),
          if (isScanning) const CircularProgressIndicator(),
        ],
      ),
    );
  }
}

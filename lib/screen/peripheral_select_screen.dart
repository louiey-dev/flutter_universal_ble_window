import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';

class PeripheralSelectedScreen extends StatefulWidget {
  final BleDevice bleDevice;
  const PeripheralSelectedScreen(this.bleDevice, {super.key});

  @override
  State<PeripheralSelectedScreen> createState() =>
      _PeripheralSelectedScreenState();
}

class _PeripheralSelectedScreenState extends State<PeripheralSelectedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.bleDevice.name ?? "Unknown"} - ${widget.bleDevice.deviceId}",
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Device Name : ${widget.bleDevice.name}'),
            Text('Device ID : ${widget.bleDevice.deviceId}'),
            Text('Device RSSI : ${widget.bleDevice.rssi}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}

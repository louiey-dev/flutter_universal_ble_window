import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_universal_ble_window/feature/my_utils.dart';
import 'package:flutter_universal_ble_window/widget/my_button.dart';
import 'package:flutter_universal_ble_window/widget/my_widget.dart';
import 'package:flutter_universal_ble_window/widget/scanned_item_widget.dart';
import 'package:universal_ble/universal_ble.dart';
import 'package:flutter_universal_ble_window/widget/scan_menu_widget.dart';
import 'package:flutter_universal_ble_window/widget/scan_status_widget.dart';

final ScrollController scanScrollController = ScrollController();
List<String> scanMessage = [];

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isScanning = false;
  final _bleDevices = <BleDevice>[];
  bool _isNaChecked = false;

  AvailabilityState? bleAvailabilityState;

  @override
  void initState() {
    super.initState();
    _bleDevices.clear();

    /// Setup queue and timeout
    UniversalBle.queueType = QueueType.global;
    UniversalBle.timeout = const Duration(seconds: 10);

    UniversalBle.availabilityStream.listen((state) {
      setState(() {
        bleAvailabilityState = state;
      });
    });

    UniversalBle.scanStream.listen((result) {
      if (_isNaChecked) {
        if (result.name == null || result.name!.isEmpty) {
          utils.log(
            "Device name is null or empty, skipping: ${result.deviceId}",
          );
          return;
        }
      }

      int index = _bleDevices.indexWhere((e) => e.deviceId == result.deviceId);
      if (index == -1) {
        _bleDevices.add(result);
      } else {
        if (result.name == null && _bleDevices[index].name != null) {
          result.name = _bleDevices[index].name;
        }
        _bleDevices[index] = result;
      }

      _addScanMessage(result.name, result.deviceId);

      utils.log("name : ${result.name}");
      setState(() {});
    });
  }

  _addScanMessage(String? name, String id) {
    if (name == null || name.isEmpty) {
      // skip
    } else if (scanMessage.any(
      (element) => element.contains(name) || element.contains(id),
    )) {
      // skip
      utils.log("Device already exists in scanMessage: $name");
    } else {
      scanMessage.add("Device found: $name - $id");
      // Scroll to the bottom after adding a new message
      // scanScrollController.jumpTo(
      //   scanScrollController.position.maxScrollExtent,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Universal BLE"),
      ),
      // body: Column(children: [_scanMenuScreen(), _scanStatusScreen()]),
      body: Column(
        children: [
          Row(
            children: [
              ScanMenuWidget(
                isScanning: _isScanning,
                onScanPressed: _startScan,
                onStopPressed: _stopScan,
                // onNaPressed: _filterNA,
              ),
              CupertinoSwitch(
                value: _isNaChecked,
                onChanged: (value) {
                  setState(() {
                    _isNaChecked = value;
                  });
                  utils.log("Switched to : $_isNaChecked");
                  utils.showSnackbarMs(
                    context,
                    500,
                    "Switched to: $_isNaChecked",
                  );
                },
              ),
              myWIDTH(5),
              const Text("N/A"),
            ],
          ),

          ScanStatusWidget(isScanning: _isScanning),
          // Show scan results
          _showScanResults(),
          myHEIGHT(10),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        tooltip: 'Scan',
        child: const Icon(Icons.search),
      ),
    );
  }

  Future<void> startScan() async {
    await UniversalBle.startScan();
  }

  void _startScan() {
    setState(() {
      scanMessage.clear();
      _bleDevices.clear();
      _isScanning = true;
      utils.log("Starting scan for BLE devices...");

      try {
        startScan();
      } catch (e) {
        setState(() {
          _isScanning = false;
        });
        utils.showSnackbar(context, e.toString());
      }
    });
  }

  void _stopScan() async {
    await UniversalBle.stopScan();

    setState(() {
      _isScanning = false;
      utils.log("Stopping scan for BLE devices...");
    });
  }

  Widget _showScanResults() {
    return Expanded(
      child:
          _isScanning && _bleDevices.isEmpty
              ? const Center(child: CircularProgressIndicator.adaptive())
              : !_isScanning && _bleDevices.isEmpty
              ? const Text("Scan for devices")
              : ListView.separated(
                itemCount: _bleDevices.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  BleDevice device =
                      _bleDevices[_bleDevices.length - index - 1];

                  return ScannedItemWidget(
                    bleDevice: device,
                    onTap: () {
                      utils.log(
                        "Tapped on device: ${device.name} (${device.deviceId})",
                      );
                    },
                  );
                },
              ),
    );
  }

  _scanMenuScreen() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PlatformButton(
                text: "Scan",
                onPressed: () {
                  utils.log("Scan button pressed");
                  setState(() {
                    _isScanning = true;
                  });
                },
                enabled: _isScanning ? false : true,
              ),
              myWIDTH(10),
              PlatformButton(
                text: "Scan Stop",
                onPressed: () {
                  utils.log("Scan Stop button pressed");
                  setState(() {
                    _isScanning = false;
                  });
                },
                enabled: _isScanning ? true : false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _scanStatusScreen() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isScanning ? "Scanning..." : "Scan stopped",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
          myWIDTH(30),
          if (_isScanning) CircularProgressIndicator(),
        ],
      ),
    );
  }
}

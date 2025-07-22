import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_universal_ble_window/feature/my_utils.dart';
import 'package:flutter_universal_ble_window/widget/my_button.dart';
import 'package:flutter_universal_ble_window/widget/my_widget.dart';
import 'package:flutter_universal_ble_window/widget/responsive_view.dart';
import 'package:universal_ble/universal_ble.dart';

class PeripheralSelectedScreen extends StatefulWidget {
  final BleDevice bleDevice;
  const PeripheralSelectedScreen(this.bleDevice, {super.key});

  @override
  State<PeripheralSelectedScreen> createState() =>
      _PeripheralSelectedScreenState();
}

class _PeripheralSelectedScreenState extends State<PeripheralSelectedScreen> {
  bool isConnected = false;
  final List<String> _logs = [];
  List<BleService> discoveredServices = [];

  BleService? selectedService;
  BleCharacteristic? selectedCharacteristic;

  void _addLog(String type, dynamic data) {
    setState(() {
      _logs.add('$type: ${data.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    // _displayDeviceInfo(widget.bleDevice);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.bleDevice.name ?? "Unknown"} - ${widget.bleDevice.deviceId}",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              isConnected
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth_disabled,
              color: isConnected ? Colors.blue : Colors.red,
              size: 20,
            ),
          ),
        ],
      ),
      body: ResponsiveView(
        builder: (context, deviceType) {
          return Row(
            children: [
              if (deviceType == DeviceType.desktop)
                Expanded(
                  flex: 1,
                  child: Container(
                    color: const Color.fromARGB(255, 231, 225, 248),
                    child: _displayDiscoveredServices(),
                  ),
                ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 10.0,
                      children: [
                        _showServiceInfo(),
                        _showExtraCommand(),
                        _logInfo(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _displayDiscoveredServices() {
    return discoveredServices.isEmpty
        ? const Center(child: Text('No Services Discovered'))
        : ListView.builder(
          itemCount: discoveredServices.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ExpandablePanel(
                  header: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_forward_ios),
                        Expanded(child: Text(discoveredServices[index].uuid)),
                      ],
                    ),
                  ),
                  collapsed: const SizedBox(),
                  expanded: Column(
                    children:
                        discoveredServices[index].characteristics
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        utils.log("${e.uuid} tapped");
                                        setState(() {
                                          selectedService =
                                              discoveredServices[index];
                                          selectedCharacteristic = e;
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.arrow_right_outlined,
                                              ),
                                              Expanded(child: Text(e.uuid)),
                                            ],
                                          ),
                                          Text(
                                            "Properties: ${e.properties.map((e) => e.name)}",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            );
          },
        );
  }

  _showServiceInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              PlatformButton(
                onPressed: () async {
                  try {
                    await widget.bleDevice.connect();
                    setState(() {
                      isConnected = true;
                    });
                    _addLog(
                      "Connection",
                      "Connected to ${widget.bleDevice.name}",
                    );
                  } catch (e) {
                    _addLog("Error", "Failed to connect: $e");
                  }
                },
                text: "Connect",
                enabled: !isConnected,
              ),
              PlatformButton(
                onPressed: () {
                  if (isConnected) {
                    widget.bleDevice.disconnect();
                    setState(() {
                      isConnected = false;
                    });
                    _addLog(
                      "Disconnection",
                      "Disconnected from ${widget.bleDevice.name}",
                    );
                  } else {
                    _addLog("Info", "Already disconnected");
                  }
                },
                text: "DisConnect",
                enabled: isConnected,
              ),
            ],
          ),
          Container(
            child:
                selectedCharacteristic == null
                    ? Text(
                      discoveredServices.isEmpty
                          ? "Please discover services"
                          : "Please select a characteristic",
                    )
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            "Characteristic: ${selectedCharacteristic!.uuid}",
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Service: ${selectedService!.uuid}"),
                              Text(
                                "Properties: ${selectedCharacteristic!.properties.map((e) => e.name).join(', ')}",
                              ),
                            ],
                          ),
                          onTap: () {
                            // utils.log("${selectedCharacteristic!.uuid} tapped");
                            // Handle characteristic tap
                          },
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  _showExtraCommand() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 247, 204, 204),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            spacing: 10,
            children: [
              PlatformButton(
                onPressed: () async {
                  _discoverServices();
                },
                enabled: isConnected,
                text: 'Discover Services',
              ),
              PlatformButton(
                onPressed: () async {},
                enabled: isConnected,
                text: 'Connection State',
              ),
              PlatformButton(
                onPressed: () async {},
                enabled: isConnected,
                text: 'Read',
              ),
              PlatformButton(
                onPressed: () async {},
                enabled: isConnected,
                text: 'Write',
              ),
              PlatformButton(
                onPressed: () async {},
                enabled: isConnected,
                text: 'WriteWithoutResponse',
              ),
            ],
          ),
          myHEIGHT(10),
          Row(
            spacing: 10,
            children: [
              PlatformButton(
                onPressed: () async {},
                enabled: isConnected,
                text: 'Request MTU',
              ),
              PlatformButton(
                onPressed: () async {},
                enabled: isConnected,
                text: 'Subscribe',
              ),
              PlatformButton(
                onPressed: () async {},
                enabled: isConnected,
                text: 'Unsubscribe',
              ),
              PlatformButton(
                onPressed: () async {},
                enabled: isConnected,
                text: 'Pair',
              ),
              PlatformButton(
                onPressed: () async {},
                enabled: isConnected,
                text: 'isPaired',
              ),
              PlatformButton(
                onPressed: () async {},
                enabled: isConnected,
                text: 'UnPair',
              ),
            ],
          ),
        ],
      ),
    );
  }

  _logInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 183, 241, 149),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Log Info",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              myWIDTH(20),
              IconButton(
                onPressed: () {
                  setState(() {
                    _logs.clear();
                  });
                },
                icon: Icon(Icons.cleaning_services_outlined),
              ),
            ],
          ),
          myHEIGHT(10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, idx) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_logs[idx], style: const TextStyle(fontSize: 14)),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(thickness: 2);
            },
            itemCount: _logs.length,
          ),
        ],
      ),
    );
  }

  _displayDeviceInfo(BleDevice device) {
    utils.log("${getCurrentMethodName()} : Displaying device info");
    utils.log("name : ${device.name}");
    utils.log("id : ${device.deviceId}");
    utils.log("rssi : ${device.rssi.toString()}");
    utils.log("rawName : ${device.rawName}");
    utils.log("rssi : ${device.rssi}");
    for (int i = 0; i < device.services.length; i++) {
      utils.log("service[$i] : ${device.services[i]}");
    }
    // utils.log("services : ${device.services}");
  }

  Future<void> _discoverServices() async {
    const webWarning =
        "Note: Only services added in ScanFilter or WebOptions will be discovered";
    try {
      var services = await widget.bleDevice.discoverServices();
      _addLog(
        '${getCurrentMethodName()} : ${services.length} services discovered',
        true,
      );
      _addLog("${getCurrentMethodName()} : ${services.toString()}", true);
      setState(() {
        discoveredServices = services;
      });

      if (kIsWeb) {
        _addLog(
          "DiscoverServices",
          '${services.length} services discovered,\n$webWarning',
        );
      }
    } catch (e) {
      _addLog("DiscoverServicesError", '$e\n${kIsWeb ? webWarning : ""}');
    }
  }
}

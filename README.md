# flutter_universal_ble_window

flutter windows app for ble test

## Environment
- universal ble package
- Flutter 3.28.0-1.0.pre.70
- Dart 3.7.0 (build 3.7.0-232.0.dev) • DevTools 2.41.0

![main_screen](flutter_universal_ble_window.png)

![service screen](service_screen.png)

## TODO
- Connection
- read/write feature

## History
- 2025.07.21
  - BLE scan function added based on universal ble sample code
    - displays scan results
    - checkbox to filter out "N/A" case
    - Connection is not working
  - Peripheral selected screen coding
    - display name and id
- 2025.07.22
  - Service screen added
    - displays service info, uuid, characteristics
    - extra command buttons
    - log window
  - 2025.07.23
    - Connection, scan, extra commands added and tested and all works
    - maybe I need optimize code after more test
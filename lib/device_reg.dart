//import 'main.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bluetooth_plus/flutter_bluetooth_plus.dart';
import 'dart:async';

class DevReg extends StatefulWidget {
  const DevReg({super.key});

  @override
  _DevRegState createState() => _DevRegState();
}

class _DevRegState extends State<DevReg> {
  String? selectedRole;
  double _circleSize = 120.0;
  bool _isGrowing = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_isGrowing) {
          _circleSize += 20;
          if (_circleSize >= 200) {
            _isGrowing = false;
          }
        } else {
          _circleSize -= 20;
          if (_circleSize <= 120) {
            _isGrowing = true;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 97, 194),
        title: const Text('Register Your RenoVISION'),
      ),
      body: Center(
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            width: _circleSize,
            height: _circleSize,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 137, 194, 4),
              shape: BoxShape.circle,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Locating RenoVISION!',
              ),
            )),
      ),
    );
  }
}

// Future<void> connectToESP32() async {
//   // Scan for available BLE devices

//   List<ScanResult> scanResults = await FlutterBluetoothPlus.scan();

//   // Find your ESP32 device by its UUID

//   ScanResult esp32Device = scanResults
//       .firstWhere((device) => device.id == "334420690");

//   // Connect to the ESP32

//   await FlutterBluetoothPlus.connect(esp32Device.device);
// }

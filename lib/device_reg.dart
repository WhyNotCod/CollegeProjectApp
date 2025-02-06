//import 'main.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bluetooth_plus/flutter_bluetooth_plus.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future getPermissions() async {
  try {
    await Permission.bluetooth.request();
  } catch (e) {
    print(e.toString());
  }
}

//  @override
//   void initState() {
//   // TODO: implement initState
//   super.initState();
//   getPermissions();
//   }

class DevReg extends StatefulWidget {
  const DevReg({super.key});

  @override
  _DevRegState createState() => _DevRegState();
}

class _DevRegState extends State<DevReg> {
  String? selectedRole;
  double _circleSize = 180.0;
  bool _isGrowing = true;
  Timer? _timer;
  bool bluetoothState = false;

  @override
  void initState() {
    super.initState();
    getPermissions(); //ask permission for BLE
    Timer.periodic(Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          if (_isGrowing) {
            _circleSize += 20;
            if (_circleSize >= 220) {
              _isGrowing = false;
            }
          } else {
            _circleSize -= 20;
            if (_circleSize <= 180) {
              _isGrowing = true;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 97, 194),
        title: const Text('Register Your RenoVISION'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
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
              ),
            ),
            StreamBuilder(
              stream: FlutterBluePlus.adapterState,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  if (snapshot.data == BluetoothAdapterState.on) {
                    bluetoothState = true;
                  } else if (snapshot.data == BluetoothAdapterState.off) {
                    bluetoothState = false;
                  }
                  return Container(
                    height: 30,
                    child: SwitchListTile(
                      activeColor: Color(0xFF015164),
                      activeTrackColor: Color(0xFF0291B5),
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbColor: Colors.white,
                      selectedTileColor: Colors.red,
                      title: Text(
                        'Activate Bluetooth',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: bluetoothState,
                      onChanged: (bool value) {
                        setState(() {
                          bluetoothState = !bluetoothState;
                          if (value) {
                            FlutterBluePlus.turnOn();
                          } else {
                            FlutterBluePlus.turnOff();
                          }
                        });
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 37, 97, 194),
//         title: const Text('Register Your RenoVISION'),
//       ),
//       body: Center(
//         child: AnimatedContainer(
//             duration: Duration(seconds: 1),
//             width: _circleSize,
//             height: _circleSize,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 137, 194, 4),
//               shape: BoxShape.circle,
//             ),
//             child: Align(
//               alignment: Alignment.center,
//               child: Text(
//                 'Locating RenoVISION!',
//               ),
//             )),
            
//       ),
 
//     );
//   }
// }

// Future<void> connectToESP32() async {
//   // Scan for available BLE devices

//   List<ScanResult> scanResults = await FlutterBluetoothPlus.scan();

//   // Find your ESP32 device by its UUID

//   ScanResult esp32Device = scanResults
//       .firstWhere((device) => device.id == "334420690");

//   // Connect to the ESP32

//   await FlutterBluetoothPlus.connect(esp32Device.device);
// }

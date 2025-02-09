//import 'main.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bluetooth_plus/flutter_bluetooth_plus.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'selected_device.dart'; // Import the SelectedDevice class
import 'findbleDev.dart';

Future getPermissions() async {
  try {
    await Permission.bluetooth.request();
  } catch (e) {
    print(e.toString());
  }
}

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
  BluetoothDevice? selectedDevice; // Declare the selectedDevice variable

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
            ElevatedButton(
              onPressed: () async {
                final SelectedDevice? poppedDevice =
                    await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SelectBluetoothDevice();
                    },
                  ),
                );

                // Handle the selected device here
                if (poppedDevice != null) {
                  // Assign the selected device
                  selectedDevice = poppedDevice.device;
                }
              },
              child: Text('Select Bluetooth Device'),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: Stream.periodic(const Duration(seconds: 10))
                        .asyncMap((_) => FlutterBluePlus
                            .connectedDevices), //not systemDevices
                    initialData: const [],
                    builder: (c, snapshot) {
                      snapshot.data.toString();
                      return Column(
                        children: snapshot.data!.map((d) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  d.platformName,
                                  style: TextStyle(color: Color(0xFFEDEDED)),
                                ),
                                leading: Icon(
                                  Icons.devices,
                                  color: Color(0xFFEDEDED).withValues(),
                                ),
                                trailing:
                                    StreamBuilder<BluetoothConnectionState>(
                                  stream: d.connectionState,
                                  initialData:
                                      BluetoothConnectionState.disconnected,
                                  builder: (c, snapshot) {
                                    bool con = snapshot.data ==
                                        BluetoothConnectionState.connected;
                                    return ElevatedButton(
                                      child: Text(
                                        'Connect',
                                        style: TextStyle(
                                            color: con
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: con
                                                      ? Colors.green
                                                      : Colors.red),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)))),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(SelectedDevice(d, 1));
                                      },
                                    );
                                  },
                                ),
                              ),
                              Divider()
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBluePlus.scanResults,
                    initialData: const [],
                    builder: (c, snapshot) {
                      List<ScanResult> scanresults = snapshot.data!;
                      List<ScanResult> templist = [];
                      scanresults.forEach((element) {
                        if (element.device.platformName != "") {
                          templist.add(element);
                        }
                      });

                      return Container(
                        height: 700,
                        child: ListView.builder(
                            itemCount: templist.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      templist[index].device.platformName,
                                      style:
                                          TextStyle(color: Color(0xFFEDEDED)),
                                    ),
                                    leading: Icon(
                                      Icons.devices,
                                      color: Color(0xFFEDEDED).withValues(),
                                    ),
                                    trailing: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                side: BorderSide(
                                                    color: Colors.orange))),
                                        onPressed: () async {
                                          Navigator.of(context).pop(
                                              SelectedDevice(
                                                  templist[index].device, 0));
                                          //   final SelectedDevice? poppedDevice =
                                          //   await Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //       builder: (context) {
                                          //         return SelectBluetoothDevice();

                                          //       },

                                          //     ),
                                          //   );
                                        },
                                        child: Text(
                                          "Connect",
                                          style: TextStyle(
                                              color: Color(0xFFEDEDED)),
                                        )),
                                  ),
                                  Divider()
                                ],
                              );
                            }),
                      );
                    },
                  ),
                ],
              ),
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

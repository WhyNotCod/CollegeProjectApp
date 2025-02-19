import 'package:flutter/material.dart';
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
  DevRegState createState() => DevRegState();
}

class DevRegState extends State<DevReg> {
  String? selectedRole;
  bool bluetoothState = false;
  BluetoothDevice? selectedDevice; // Declare the selectedDevice variable
  bool ConnectionStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 97, 194),
        title: const Text('Register Your RenoVISION'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: FlutterBluePlus.adapterState,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.data == BluetoothAdapterState.on) {
                      bluetoothState = true;
                    } else if (snapshot.data == BluetoothAdapterState.off) {
                      bluetoothState = false;
                    }
                    // return SizedBox(
                    //   height: 30,
                    //   child: SwitchListTile(
                    //     activeColor: Color(0xFF015164),
                    //     activeTrackColor: Color(0xFF0291B5),
                    //     inactiveTrackColor:
                    //         const Color.fromARGB(255, 5, 125, 13),
                    //     inactiveThumbColor: Colors.white,
                    //     selectedTileColor: Colors.red,
                    //     title: Text(
                    //       'Activate Bluetooth',
                    //       style: TextStyle(fontSize: 14),
                    //     ),
                    //     value: bluetoothState,
                    //     onChanged: (bool value) {
                    //       setState(() {
                    //         bluetoothState = !bluetoothState;
                    //         if (value) {
                    //           FlutterBluePlus.turnOn();
                    //         } else {
                    //           FlutterBluePlus.turnOff();
                    //         }
                    //       });
                    //     },
                    //   ),
                    // );
                  } else {
                    return Container();
                  }
                },
              ),
              // ElevatedButton(
              //   onPressed: () async {
              // final SelectedDevice? poppedDevice =
              //     await Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return SelectBluetoothDevice();
              //     },
              //   ),
              // );
              // StreamSubscription<List<int>>? stream_sub;
              // if (poppedDevice != null) {
              //   setState(() {
              //     selectedDevice = poppedDevice.device;
              //     print(poppedDevice.state);
              //     if (poppedDevice.state == 1) {
              //       BluetoothConnectionState? ev;
              //       selectedDevice!.connectionState.listen((event) {
              //         if (ev == BluetoothConnectionState.connected) {
              //           setState(() {
              //             ConnectionStatus = true;
              //           });
              //         } else {
              //           ConnectionStatus = false;
              //         }
              //       });
              //     } else if (poppedDevice.state == 0) {
              //       ConnectionStatus = false;
              //     }
              //   });
              //   await selectedDevice!.connect().then((value) {
              //     selectedDevice!.connectionState.listen((event) async {
              //       setState(() {
              //         if (event == BluetoothConnectionState.connected) {
              //           ConnectionStatus = true;
              //         } else {
              //           ConnectionStatus = false;
              //         }
              //       });
              //       if (event == BluetoothConnectionState.disconnected) {
              //         await stream_sub!.cancel();
              //       }
              //     });
              //   });
              // }
              // },
              Text('Select Bluetooth Device'),

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
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 212, 12, 12)),
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
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: con
                                                    ? Colors.green
                                                    : Colors.red),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(SelectedDevice(d, 1));
                                        },
                                        child: Text(
                                          'Connect',
                                          style: TextStyle(
                                              color: con
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
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

                        return SizedBox(
                          height: 700,
                          child: ListView.builder(
                            itemCount: templist.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      templist[index].device.platformName,
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 29, 119, 157)),
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
                                          side:
                                              BorderSide(color: Colors.orange),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await templist[index].device.connect();
                                        templist[index]
                                            .device
                                            .connectionState
                                            .listen((event) {
                                          setState(() {
                                            ConnectionStatus = event ==
                                                BluetoothConnectionState
                                                    .connected;
                                          });
                                        });
                                      },
                                      child: Text(
                                        "Connect",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 29, 119, 157)),
                                      ),
                                    ),
                                  ),
                                  Divider()
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => FlutterBluePlus.stopScan(),
              backgroundColor: Color.fromARGB(255, 152, 152, 156),
              child: const Icon(
                Icons.stop,
                color: Colors.red,
              ),
            );
          } else {
            return FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 10, 198, 98),
              onPressed: () => FlutterBluePlus.startScan(
                  timeout: const Duration(seconds: 12)),
              child: Icon(
                Icons.search,
                color: Colors.blue.shade300,
              ),
            );
          }
        },
      ),
    );
  }
}

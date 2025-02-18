import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'selected_device.dart'; // Import the SelectedDevice class

class SelectBluetoothDevice extends StatefulWidget {
  final BluetoothDevice? connectedDevice;

  const SelectBluetoothDevice({this.connectedDevice});

  @override
  _SelectBluetoothDeviceState createState() => _SelectBluetoothDeviceState();
}

class _SelectBluetoothDeviceState extends State<SelectBluetoothDevice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.connectedDevice != null
            ? widget.connectedDevice!.platformName
            : 'Select Bluetooth Device'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.connectedDevice == null)
                Text('Searching for devices...'),
              if (widget.connectedDevice == null)
                StreamBuilder<List<ScanResult>>(
                  stream: FlutterBluePlus.scanResults,
                  initialData: [],
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          ScanResult result = snapshot.data![index];
                          return ListTile(
                            title: Text(result.device.platformName),
                            onTap: () async {
                              // Connect to the selected device
                              await result.device.connect();
                              // Check the connection state
                              result.device.connectionState.listen((event) {
                                if (event ==
                                    BluetoothConnectionState.connected) {
                                  // Navigate to the same screen with the connected device
                                  if (mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SelectBluetoothDevice(
                                                connectedDevice: result.device),
                                      ),
                                    );
                                  }
                                }
                              });
                            },
                          );
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              if (widget.connectedDevice != null)
                Text(
                    'Device ${widget.connectedDevice!.platformName} is connected'),
            ],
          ),
        ),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Select Bluetooth Device'),
//         ),
//         body: Center(
//           child: SingleChildScrollView(
//             child: Column(
// //               floatingActionButton: StreamBuilder<bool>(
// //   stream: FlutterBluePlus.isScanning,
// //   initialData: false,
// //   builder: (c, snapshot) {
// //     if (snapshot.data!) {
// //       return FloatingActionButton(
// //         child: const Icon(Icons.stop,color: Colors.red,),
// //         onPressed: () => FlutterBluePlus.stopScan(),
// //         backgroundColor:Color(0xFFEDEDED),
// //       );
// //     } else {
// //       return FloatingActionButton(
// //           child: Icon(Icons.search,color: Colors.blue.shade300,),
// //           backgroundColor:Color(0xFFEDEDED),
// //           onPressed: ()=> FlutterBluePlus.startScan(timeout: const Duration(seconds: 4))
// //           );
// //     }
// //   },
// // ),
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text('Searching for devices...'),
//                 StreamBuilder<List<ScanResult>>(
//                   //stream: FlutterBluePlus.isScanning,
//                   stream: FlutterBluePlus.scanResults,
//                   initialData: [],
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.length,
//                         itemBuilder: (context, index) {
//                           ScanResult result = snapshot.data![index];
//                           return ListTile(
//                             title: Text(result.device.platformName),
//                             onTap: () {
//                               Navigator.pop(
//                                   context, SelectedDevice(result.device, 0));
//                             },
//                           );
//                         },
//                       );
//                     } else {
//                       return CircularProgressIndicator();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }

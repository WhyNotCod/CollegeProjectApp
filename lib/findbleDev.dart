import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'selected_device.dart'; // Import the SelectedDevice class

class SelectBluetoothDevice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Bluetooth Device'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Searching for devices...'),

            StreamBuilder<List<ScanResult>>(
              //stream: FlutterBluePlus.isScanning,
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
                        title: Text(result.device.name),
                        onTap: () {
                          Navigator.pop(
                              context, SelectedDevice(result.device, 0));
                        },
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
    
  }
}

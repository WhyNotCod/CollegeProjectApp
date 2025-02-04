//import 'main.dart';
import 'package:flutter/material.dart';
import 'device_reg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 97, 194),
        title: const Text('Welcome Home'),
      ),
      body: Container(
          margin: const EdgeInsets.only(top: 55.0, bottom: 85.0),
          alignment: Alignment.topRight,
          color: const Color.fromARGB(255, 137, 194, 4),
          child: Column(
            children: <Widget>[
              Text(
                'Here are your files',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10.0),
                //key: _formKey,
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: const Text('Register Device'),
                    onPressed: () {
                      // Navigate the user to the Device Registration page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DevReg()),
                      );
                    },
                  ),
                ),
              )
            ],
          )),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: HomePage(),
//   ));
// }

//import 'main.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';
//import 'dart:convert';
import 'package:http/http.dart' as http;
import 'device_reg.dart';

class AccPage extends StatefulWidget {
  const AccPage({super.key});

  @override
  _AccPageState createState() => _AccPageState();
}

class _AccPageState extends State<AccPage> {
  String? selectedRole;
  //const AccPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController employeePositionController =
      TextEditingController();

  void _sendData() async {
    String email = emailController.text;
    String password = passwordController.text;
    String companyName = companyNameController.text;
    String employeePosition = employeePositionController.text;

    //Uniform Resource Identifier, parsing a string with Uri.parse to create URI
    var url = Uri.parse('http://yourserver.com/endpoint');
    // final httpPackageInfo = await http.read(url);
    // print(httpPackageInfo);

    var response = await http.post(url, body: {
      'role': selectedRole,
      'email': email,
      'password': password,
      'companyName': companyName,
      'employeePosition': employeePosition,
    });

    if (response.statusCode == 200) {
      print('Data sent successfully');
    } else {
      print('Failed to send data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 97, 194),
        title: const Text('Create Account'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50.0),
        alignment: Alignment.center,
        constraints: BoxConstraints.tightForFinite(width: 200),
        // decoration: BoxDecoration(
        //   color: Color.fromARGB(255, 37, 97, 194),
        // ),
        child: Center(
          child: Column(children: <Widget>[
            //const Text('Work In Progress'),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                label: Text('Who are you'),
              ),
              items: [
                DropdownMenuItem(
                    value: 'Contractor', child: Text('Contractor')),
                DropdownMenuItem(
                    value: 'Home Renovator', child: Text('Home Renovator'))
              ],
              onChanged: (value) {
                //when user changes value in drop down
                setState(() {
                  selectedRole = value as String;
                });
              },
            ),
            if (selectedRole == 'Contractor') ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: companyNameController,
                  decoration: InputDecoration(
                    labelText: 'Company Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: TextField(
                      controller: employeePositionController,
                      decoration: InputDecoration(
                        labelText: 'Employee Position',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ))
            ] else if (selectedRole == 'Home Renovator') ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      }),
                ),
              ),
            ],

            ElevatedButton(
              onPressed: _sendData,
              child: Text('Send to Server'),
            ),
            Align(
              alignment: Alignment.topRight,
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
          ]),
        ),
      ),
    );
  }
}

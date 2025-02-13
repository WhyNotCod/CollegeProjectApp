//import 'main.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:flutter_session_jwt/flutter_session_jwt.dart';
//import 'package:flutter/scheduler.dart';
//import 'dart:convert';
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
  final TextEditingController usernameController = TextEditingController();

  void _sendData() async {
    // String email = emailController.text;
    // String password = passwordController.text;
    // String companyName = companyNameController.text;
    // String employeePosition = employeePositionController.text;
    // String username = usernameController.text;

    //Uniform Resource Identifier, parsing a string with Uri.parse to create URI
    var url = Uri.parse('http://52.144.44.45/api');
    //final httpPackageInfo = await http.read(url);
    //print(httpPackageInfo);

    // var response = await http.post(url, body: {
    //   //'role': selectedRole,
    //   'username': username,
    //   'email': email,
    //   'password': password,
    //   'companyName': companyName,
    //   'employeePosition': employeePosition,
    // });

    // if (response.statusCode == 200) {
    //   final storage = const FlutterSecureStorage();
    //   //var token = response.body.token;
    //   // Parse the response body to get the token
    //   var responseBody = json.decode(response.body);
    //   var token = responseBody['token'];
    //   await FlutterSessionJwt.saveToken(token);
    //   // to save token in local storage
    //   await storage.write(key: 'token', value: token);

    //   // to get token from local storage
    //   var value = await storage.read(key: 'token');
    // } else {
    //   print('Failed to send data');
    // }
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
            child: SingleChildScrollView(
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
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        )),
                  ),
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
                    child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        )),
                  ),
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
                          obscureText: true,
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
                //Align(
                //alignment: Alignment.topRight,
                ElevatedButton(
                  child: const Text('Register Device'),
                  onPressed: () {
                    // Navigate the user to the Device Registration page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DevReg()),
                    );
                  },
                ),
              ]),
            ),
          ),
        ));
  }
}

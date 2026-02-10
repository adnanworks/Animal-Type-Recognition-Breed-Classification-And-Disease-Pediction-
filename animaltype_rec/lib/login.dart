import 'dart:convert';
import 'package:animaltype_rec/user/home.dart';
import 'package:animaltype_rec/user/register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'guide/home.dart';

void main() {
  runApp( mylogin());
}

class mylogin extends StatelessWidget {
  const mylogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyLoginPage(title: 'IP Page'),
    );
  }
}
class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});
  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController _usernametextController = TextEditingController();
  final TextEditingController _passwordtextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                "Login Page",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0047AB),
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernametextController,
                decoration: const InputDecoration(
                  labelText: "Email ID",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordtextController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sendData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Login", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "User Register Here : ",
                    style: TextStyle(color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),


                  ),
                ],

              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Text(
                  //   "Forgot Password: ",
                  //   style: TextStyle(color: Colors.black87),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const forgtPasswordPage(title: '')),
                  //     );
                  //   },
                  //   child: const Text(
                  //     "Click Here",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.orange,
                  //     ),
                  //   ),
                  //
                  //
                  // ),
                ],

              ),


            ],
              ),

          ),
        ),

    );
  }

  Future<void> _sendData() async {
    String uname = _usernametextController.text.trim();
    String password = _passwordtextController.text.trim();

    if (uname.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter both email and password');
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    if (url == null || url.isEmpty) {
      Fluttertoast.showToast(msg: 'Server URL not configured');
      return;
    }

    final urls = Uri.parse('$url/flutter_login/');
    try {
      final response = await http.post(
        urls,
        body: {'Username': uname, 'Password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String status = data['status'].toString();
        String message = data['message'].toString();
        String type = data['type'].toString();

        Fluttertoast.showToast(msg: message);

        if (status == 'ok') {
          String lid = data['lid'].toString();
          await sh.setString("lid", lid);



          // String oid = data['oid'].toString();
          // await sh.setString("oid", oid);

          if(type == "guide"){
           Navigator.push(context, MaterialPageRoute(builder: (context) => GuideHomePage(),));
          }
          else if (type == "user"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserHomePage(),));

          }

        }
      } else {
        Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }
}
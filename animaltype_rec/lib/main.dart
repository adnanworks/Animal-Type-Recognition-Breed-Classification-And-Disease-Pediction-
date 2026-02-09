import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ip(title: 'IP Page'),
    );
  }
}

class ip extends StatefulWidget {
  const ip({super.key, required this.title});

  final String title;

  @override
  State<ip> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ip> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Enter Your Ip Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _send_data();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _send_data() async{
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString('url', 'http://${_textController.text}:8000/myapp');
    sh.setString('img_url', 'http://${_textController.text}:8000');
    sh.setString('img_url2', 'http://${_textController.text}:8000/media/');
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) =>MyLoginPage(title: '',),));

  }

}
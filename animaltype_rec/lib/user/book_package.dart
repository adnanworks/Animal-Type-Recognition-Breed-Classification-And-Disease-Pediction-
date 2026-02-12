import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

void main() {
  runApp(const BookPackage());
}

class BookPackage extends StatelessWidget {
  const BookPackage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookPackagePage(title: 'Book Package'),
    );
  }
}

class BookPackagePage extends StatefulWidget {
  const BookPackagePage({super.key, required this.title});
  final String title;

  @override
  State<BookPackagePage> createState() => _BookPackagePageState();
}

class _BookPackagePageState extends State<BookPackagePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  bool _isLoading = false;

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  Future<void> _sendBooking() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please select a date");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');
      String lid = sh.getString('lid') ?? '';
      String packageId = sh.getString('package_id') ?? '';

      if (url == null || packageId.isEmpty) {
        Fluttertoast.showToast(msg: "Missing package information");
        return;
      }

      final uri = Uri.parse('$url/user_book_package/');
      var response = await http.post(uri, body: {
        'lid': lid,
        'package_id': packageId,
        'date': _dateController.text,
      });

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Booking Successful");
        _dateController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePage()),
        );
      } else {
        Fluttertoast.showToast(msg: "Booking Failed");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: const InputDecoration(
                    labelText: "Select Booking Date",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select date";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendBooking,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("Confirm Booking"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

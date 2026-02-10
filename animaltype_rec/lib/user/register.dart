import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../login.dart';

enum Gender { male, female }



class AppColors {
  static const Color primaryBlue = Color(0xFF1453AE);
  static const Color accentGreen = Color(0xFF34D399);
  static const Color backgroundLight = Color(0xFFF7F7F7);
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();


  File? _selectedImage;



  Future<void> _chooseImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        Fluttertoast.showToast(msg: "No image selected");
      }
    } catch (e) {
      print("Image picker error: $e");
      Fluttertoast.showToast(msg: "Failed to pick image: $e");
    }
  }

  Future<void> _sendData() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');

      if (url == null) {
        Fluttertoast.showToast(msg: "Server URL not found.");
        return;
      }


      final uri = Uri.parse('$url/user_register/');
      var request = http.MultipartRequest('POST', uri);

      request.fields['name'] = _nameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['place'] = _placeController.text;

      request.fields['dob'] = _dobController.text;

      request.fields['phone'] = _phoneController.text;
      request.fields['username'] = _usernameController.text;

      request.fields['password'] = _passwordController.text;
      request.fields['cpassword'] = _cpasswordController.text;

      if (_selectedImage != null) {
        if (await _selectedImage!.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'photo',
              _selectedImage!.path,
              filename: 'current_student_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          );
        } else {
          Fluttertoast.showToast(msg: "Selected image file not found");
        }
      }


      try {
        var response = await request.send();
        var respStr = await response.stream.bytesToString();
        var data = jsonDecode(respStr);

        if (response.statusCode == 200 && data['status'] == 'ok') {
          Fluttertoast.showToast(msg: data['message']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyLoginPage(title: '')),
          );
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? "Unexpected response");
        }


      } catch (e) {
        Fluttertoast.showToast(msg: "Network Error: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "Please fix errors in the form");
    }
  }

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: AppColors.accentGreen, width: 2.5),
    );

    const OutlineInputBorder defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.5),
    );

    InputDecoration _buildInputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.primaryBlue),
        border: defaultBorder,
        enabledBorder: defaultBorder,
        focusedBorder: focusedBorder,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyLoginPage(title: '')),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('New User Registration'),
          centerTitle: true,
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 5,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _chooseImage,
                  child: const Text("Add Photo"),
                ),
                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),


                TextFormField(
                  controller: _nameController,
                  decoration: _buildInputDecoration('Full Name'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _placeController,
                  decoration: _buildInputDecoration('PLace'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Place is required'
                      : null,
                ),
                const SizedBox(height: 15),


                const SizedBox(height: 15),
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: _buildInputDecoration('Date of Birth'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _dobController.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                  validator: (value) =>
                  value == null || value.isEmpty ? 'DOB is required' : null,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: _phoneController,
                  decoration: _buildInputDecoration('Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _emailController,
                  decoration: _buildInputDecoration('Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _usernameController,
                  decoration: _buildInputDecoration('Username'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Username is required'
                      : null,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _buildInputDecoration('Password'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Password is required'
                      : null,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _cpasswordController,
                  obscureText: true,
                  decoration: _buildInputDecoration('Password'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Password is required'
                      : null,
                ),
                SizedBox(height: 20,),

                ElevatedButton(
                  onPressed: _sendData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 5,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text("Register Account"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
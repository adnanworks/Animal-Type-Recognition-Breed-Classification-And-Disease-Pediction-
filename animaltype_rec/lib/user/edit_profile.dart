import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'home.dart';

class EditprofilePage extends StatefulWidget {
  const EditprofilePage({Key? key}) : super(key: key);

  @override
  State<EditprofilePage> createState() => _MyEditState();
}

class _MyEditState extends State<EditprofilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  File? _imageFile;
  String photo_ = "";
  String img_url_ = "";

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
  }


  String _buildImageUrl() {
    if (photo_.isEmpty) return '';
    if (photo_.startsWith('http')) return photo_;
    if (img_url_.endsWith('/') && photo_.startsWith('/')) {
      return "${img_url_}${photo_.substring(1)}";
    } else if (!img_url_.endsWith('/') && !photo_.startsWith('/')) {
      return "$img_url_/$photo_";
    } else {
      return "$img_url_$photo_";
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _loadProfileDetails() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String urls = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';
    String img_url = sh.getString('img_url') ?? '';

    setState(() {
      img_url_ = img_url;
    });

    var res = await http.post(
      Uri.parse('$urls/user_profileviewforedit/'),
      body: {'lid': lid},
    );

    var jsonData = json.decode(res.body);
    if (jsonData['status'] == 'ok') {
      setState(() {
        nameController.text = jsonData['name'];
        placeController.text = jsonData['place'];
        emailController.text = jsonData['email'];
        phoneController.text = jsonData['phone'];
        dobController.text = jsonData['dob'];
        photo_ = jsonData['photo'] ?? '';

      });
    } else {
      Fluttertoast.showToast(msg: 'Failed to load profile.');
    }
  }

  Future<void> _updateProfile() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String urls = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';

    try {
      var request =
      http.MultipartRequest('POST', Uri.parse('$urls/user_editprofile/'));
      request.fields['lid'] = lid;
      request.fields['name'] = nameController.text;
      request.fields['place'] = placeController.text;
      request.fields['email'] = emailController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['dob'] = dobController.text;
      if (_imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo', _imageFile!.path));
      }

      var response = await request.send();
      var res = await http.Response.fromStream(response);
      var jsonData = json.decode(res.body);

      if (jsonData['status'] == 'ok') {
        Fluttertoast.showToast(msg: jsonData['message']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePage()),
        );
      } else {
        Fluttertoast.showToast(msg: 'Update failed. Try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      print('Update error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String finalImageUrl = _buildImageUrl();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (finalImageUrl.isNotEmpty
                      ? NetworkImage(finalImageUrl) as ImageProvider
                      : const AssetImage('assets/person.png')),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: placeController,
              decoration: const InputDecoration(labelText: 'Place'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: dobController,
              readOnly: true, 
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime initialDate = DateTime.now();

                // if DOB already exists, parse it
                try {
                  if (dobController.text.isNotEmpty) {
                    initialDate = DateTime.parse(dobController.text);
                  }
                } catch (_) {}

                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    dobController.text =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  });
                }
              },
            ),

            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
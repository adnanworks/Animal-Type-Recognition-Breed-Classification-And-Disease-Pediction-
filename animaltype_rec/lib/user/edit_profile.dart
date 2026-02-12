// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
//
// import 'home.dart';
//
// class EditprofilePage extends StatefulWidget {
//   const EditprofilePage({Key? key}) : super(key: key);
//
//   @override
//   State<EditprofilePage> createState() => _MyEditState();
// }
//
// class _MyEditState extends State<EditprofilePage> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController placeController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController dobController = TextEditingController();
//   File? _imageFile;
//   String photo_ = "";
//   String img_url_ = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileDetails();
//   }
//
//
//   String _buildImageUrl() {
//     if (photo_.isEmpty) return '';
//     if (photo_.startsWith('http')) return photo_;
//     if (img_url_.endsWith('/') && photo_.startsWith('/')) {
//       return "${img_url_}${photo_.substring(1)}";
//     } else if (!img_url_.endsWith('/') && !photo_.startsWith('/')) {
//       return "$img_url_/$photo_";
//     } else {
//       return "$img_url_$photo_";
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _imageFile = File(picked.path);
//       });
//     }
//   }
//
//   Future<void> _loadProfileDetails() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String urls = sh.getString('url') ?? '';
//     String lid = sh.getString('lid') ?? '';
//     String img_url = sh.getString('img_url') ?? '';
//
//     setState(() {
//       img_url_ = img_url;
//     });
//
//     var res = await http.post(
//       Uri.parse('$urls/user_profileviewforedit/'),
//       body: {'lid': lid},
//     );
//
//     var jsonData = json.decode(res.body);
//     if (jsonData['status'] == 'ok') {
//       setState(() {
//         nameController.text = jsonData['name'];
//         placeController.text = jsonData['place'];
//         emailController.text = jsonData['email'];
//         phoneController.text = jsonData['phone'];
//         dobController.text = jsonData['dob'];
//         photo_ = jsonData['photo'] ?? '';
//
//       });
//     } else {
//       Fluttertoast.showToast(msg: 'Failed to load profile.');
//     }
//   }
//
//   Future<void> _updateProfile() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String urls = sh.getString('url') ?? '';
//     String lid = sh.getString('lid') ?? '';
//
//     try {
//       var request =
//       http.MultipartRequest('POST', Uri.parse('$urls/user_editprofile/'));
//       request.fields['lid'] = lid;
//       request.fields['name'] = nameController.text;
//       request.fields['place'] = placeController.text;
//       request.fields['email'] = emailController.text;
//       request.fields['phone'] = phoneController.text;
//       request.fields['dob'] = dobController.text;
//       if (_imageFile != null) {
//         request.files
//             .add(await http.MultipartFile.fromPath('photo', _imageFile!.path));
//       }
//
//       var response = await request.send();
//       var res = await http.Response.fromStream(response);
//       var jsonData = json.decode(res.body);
//
//       if (jsonData['status'] == 'ok') {
//         Fluttertoast.showToast(msg: jsonData['message']);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const UserHomePage()),
//         );
//       } else {
//         Fluttertoast.showToast(msg: 'Update failed. Try again.');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//       print('Update error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String finalImageUrl = _buildImageUrl();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             Center(
//               child: GestureDetector(
//                 onTap: _pickImage,
//                 child: CircleAvatar(
//                   radius: 70,
//                   backgroundColor: Colors.grey[300],
//                   backgroundImage: _imageFile != null
//                       ? FileImage(_imageFile!)
//                       : (finalImageUrl.isNotEmpty
//                       ? NetworkImage(finalImageUrl) as ImageProvider
//                       : const AssetImage('assets/person.png')),
//                   child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.blue,
//                       ),
//                       padding: const EdgeInsets.all(5),
//                       child: const Icon(
//                         Icons.edit,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: placeController,
//               decoration: const InputDecoration(labelText: 'Place'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: dobController,
//               readOnly: true,
//               decoration: const InputDecoration(
//                 labelText: 'Date of Birth',
//                 suffixIcon: Icon(Icons.calendar_today),
//               ),
//               onTap: () async {
//                 DateTime initialDate = DateTime.now();
//
//                 // if DOB already exists, parse it
//                 try {
//                   if (dobController.text.isNotEmpty) {
//                     initialDate = DateTime.parse(dobController.text);
//                   }
//                 } catch (_) {}
//
//                 DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: initialDate,
//                   firstDate: DateTime(1950),
//                   lastDate: DateTime.now(),
//                 );
//
//                 if (pickedDate != null) {
//                   setState(() {
//                     dobController.text =
//                     "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
//                   });
//                 }
//               },
//             ),
//
//             const SizedBox(height: 25),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _updateProfile,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   backgroundColor: Colors.blue,
//                 ),
//                 child: const Text(
//                   'Save Changes',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




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

class _MyEditState extends State<EditprofilePage> with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  File? _imageFile;
  String photo_ = "";
  String img_url_ = "";

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    nameController.dispose();
    emailController.dispose();
    placeController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
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
      Fluttertoast.showToast(
        msg: 'Photo selected successfully',
        backgroundColor: Colors.green.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
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
      Fluttertoast.showToast(
        msg: 'Failed to load profile.',
        backgroundColor: Colors.red.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  // Phone validation
  bool _isPhoneValid(String phone) {
    return RegExp(r'^[6-9][0-9]{9}$').hasMatch(phone);
  }

  // Email validation
  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Name validation
  bool _isNameValid(String name) {
    return name.trim().length >= 3;
  }

  // Place validation
  bool _isPlaceValid(String place) {
    return place.trim().length >= 2;
  }

  Future<void> _updateProfile() async {
    // Validate all fields
    if (!_isNameValid(nameController.text)) {
      Fluttertoast.showToast(
        msg: 'Name must be at least 3 characters',
        backgroundColor: Colors.orange.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (!_isPlaceValid(placeController.text)) {
      Fluttertoast.showToast(
        msg: 'Place must be at least 2 characters',
        backgroundColor: Colors.orange.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (!_isEmailValid(emailController.text)) {
      Fluttertoast.showToast(
        msg: 'Enter a valid email address',
        backgroundColor: Colors.orange.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (!_isPhoneValid(phoneController.text)) {
      Fluttertoast.showToast(
        msg: 'Phone must start with 6/7/8/9 and be 10 digits',
        backgroundColor: Colors.orange.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    SharedPreferences sh = await SharedPreferences.getInstance();
    String urls = sh.getString('url') ?? '';
    String lid = sh.getString('lid') ?? '';

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$urls/user_editprofile/'));
      request.fields['lid'] = lid;
      request.fields['name'] = nameController.text;
      request.fields['place'] = placeController.text;
      request.fields['email'] = emailController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['dob'] = dobController.text;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('photo', _imageFile!.path));
      }

      var response = await request.send();
      var res = await http.Response.fromStream(response);
      var jsonData = json.decode(res.body);

      setState(() {
        _isLoading = false;
      });

      if (jsonData['status'] == 'ok') {
        Fluttertoast.showToast(
          msg: jsonData['message'] ?? 'Profile updated successfully',
          backgroundColor: Colors.green.shade600,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePage()),
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Update failed. Try again.',
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Error: $e',
        backgroundColor: Colors.red.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      print('Update error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String finalImageUrl = _buildImageUrl();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.green.shade700,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.green.shade600,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Photo Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.green.shade100,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green.shade400,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.2),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.grey.shade100,
                                  backgroundImage: _imageFile != null
                                      ? FileImage(_imageFile!)
                                      : (finalImageUrl.isNotEmpty
                                      ? NetworkImage(finalImageUrl) as ImageProvider
                                      : const AssetImage('assets/person.png')),
                                  child: _imageFile == null && finalImageUrl.isEmpty
                                      ? Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.green.shade300,
                                  )
                                      : null,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade600,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.photo_library_outlined,
                            size: 18,
                            color: Colors.green.shade600,
                          ),
                          label: Text(
                            _imageFile != null ? 'Change Photo' : 'Upload Photo',
                            style: TextStyle(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Personal Information Section
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Name Field
                  _buildTextField(
                    controller: nameController,
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => setState(() {}),
                  ),
                  if (nameController.text.isNotEmpty && !_isNameValid(nameController.text))
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.orange.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Minimum 3 characters required',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Place Field
                  _buildTextField(
                    controller: placeController,
                    label: 'Place / Location',
                    icon: Icons.location_on_outlined,
                    keyboardType: TextInputType.streetAddress,
                    onChanged: (value) => setState(() {}),
                  ),
                  if (placeController.text.isNotEmpty && !_isPlaceValid(placeController.text))
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.orange.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Minimum 2 characters required',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Email Field
                  _buildTextField(
                    controller: emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => setState(() {}),
                  ),
                  if (emailController.text.isNotEmpty && !_isEmailValid(emailController.text))
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 14,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Enter a valid email address',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Phone Field
                  _buildTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    onChanged: (value) {
                      // Auto-format: only digits
                      if (value.isNotEmpty) {
                        String filtered = value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (filtered.length > 10) filtered = filtered.substring(0, 10);
                        if (filtered != value) {
                          phoneController.value = TextEditingValue(
                            text: filtered,
                            selection: TextSelection.collapsed(offset: filtered.length),
                          );
                        }
                      }
                      setState(() {});
                    },
                  ),
                  if (phoneController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Row(
                        children: [
                          Icon(
                            _isPhoneValid(phoneController.text)
                                ? Icons.check_circle
                                : Icons.error_outline,
                            size: 14,
                            color: _isPhoneValid(phoneController.text)
                                ? Colors.green.shade600
                                : Colors.red.shade400,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _isPhoneValid(phoneController.text)
                                  ? 'Valid phone number'
                                  : phoneController.text.isEmpty
                                  ? 'Phone number is required'
                                  : phoneController.text.length != 10
                                  ? 'Must be exactly 10 digits'
                                  : 'Must start with 6, 7, 8, or 9',
                              style: TextStyle(
                                fontSize: 12,
                                color: _isPhoneValid(phoneController.text)
                                    ? Colors.green.shade600
                                    : Colors.red.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Date of Birth Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: dobController,
                      readOnly: true,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'YYYY-MM-DD',
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.cake_outlined,
                            color: Colors.green.shade600,
                            size: 24,
                          ),
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.green.shade400,
                            width: 2,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      onTap: () async {
                        DateTime initialDate = DateTime.now();
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
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.green.shade600,
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: Colors.grey.shade900,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          setState(() {
                            dobController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade400,
                          Colors.green.shade600,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: Colors.transparent,
                      ),
                      child: _isLoading
                          ? const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.save_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Version Text
                  Center(
                    child: Text(
                      'Edit Profile v1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    void Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: Colors.green.shade600,
              size: 24,
            ),
          ),
          counterText: '',
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.green.shade400,
              width: 2,
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
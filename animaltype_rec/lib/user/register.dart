// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../login.dart';
//
// enum Gender { male, female }
//
//
//
// class AppColors {
//   static const Color primaryBlue = Color(0xFF1453AE);
//   static const Color accentGreen = Color(0xFF34D399);
//   static const Color backgroundLight = Color(0xFFF7F7F7);
// }
//
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});
//
//   @override
//   State<RegisterPage> createState() => RegisterPageState();
// }
//
// class RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _placeController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _cpasswordController = TextEditingController();
//
//
//   File? _selectedImage;
//
//
//
//   Future<void> _chooseImage() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? pickedFile = await picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 800,
//         maxHeight: 800,
//         imageQuality: 80,
//       );
//
//       if (pickedFile != null) {
//         setState(() {
//           _selectedImage = File(pickedFile.path);
//         });
//       } else {
//         Fluttertoast.showToast(msg: "No image selected");
//       }
//     } catch (e) {
//       print("Image picker error: $e");
//       Fluttertoast.showToast(msg: "Failed to pick image: $e");
//     }
//   }
//
//   Future<void> _sendData() async {
//     if (_formKey.currentState!.validate()) {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String? url = sh.getString('url');
//
//       if (url == null) {
//         Fluttertoast.showToast(msg: "Server URL not found.");
//         return;
//       }
//
//
//       final uri = Uri.parse('$url/user_register/');
//       var request = http.MultipartRequest('POST', uri);
//
//       request.fields['name'] = _nameController.text;
//       request.fields['email'] = _emailController.text;
//       request.fields['place'] = _placeController.text;
//
//       request.fields['dob'] = _dobController.text;
//
//       request.fields['phone'] = _phoneController.text;
//       request.fields['username'] = _usernameController.text;
//
//       request.fields['password'] = _passwordController.text;
//       request.fields['cpassword'] = _cpasswordController.text;
//
//       if (_selectedImage != null) {
//         if (await _selectedImage!.exists()) {
//           request.files.add(
//             await http.MultipartFile.fromPath(
//               'photo',
//               _selectedImage!.path,
//               filename: 'current_student_${DateTime.now().millisecondsSinceEpoch}.jpg',
//             ),
//           );
//         } else {
//           Fluttertoast.showToast(msg: "Selected image file not found");
//         }
//       }
//
//
//       try {
//         var response = await request.send();
//         var respStr = await response.stream.bytesToString();
//         var data = jsonDecode(respStr);
//
//         if (response.statusCode == 200 && data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: data['message']);
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const MyLoginPage(title: '')),
//           );
//         } else {
//           Fluttertoast.showToast(msg: data['message'] ?? "Unexpected response");
//         }
//
//
//       } catch (e) {
//         Fluttertoast.showToast(msg: "Network Error: $e");
//       }
//     } else {
//       Fluttertoast.showToast(msg: "Please fix errors in the form");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const OutlineInputBorder focusedBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(10.0)),
//       borderSide: BorderSide(color: AppColors.accentGreen, width: 2.5),
//     );
//
//     const OutlineInputBorder defaultBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(10.0)),
//       borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.5),
//     );
//
//     InputDecoration _buildInputDecoration(String label) {
//       return InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: AppColors.primaryBlue),
//         border: defaultBorder,
//         enabledBorder: defaultBorder,
//         focusedBorder: focusedBorder,
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding:
//         const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       );
//     }
//
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const MyLoginPage(title: '')),
//         );
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundLight,
//         appBar: AppBar(
//           title: const Text('New User Registration'),
//           centerTitle: true,
//           backgroundColor: AppColors.primaryBlue,
//           foregroundColor: Colors.white,
//           elevation: 5,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 ElevatedButton(
//                   onPressed: _chooseImage,
//                   child: const Text("Add Photo"),
//                 ),
//                 if (_selectedImage != null)
//                   Image.file(
//                     _selectedImage!,
//                     width: 100,
//                     height: 100,
//                     fit: BoxFit.cover,
//                   ),
//
//
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: _buildInputDecoration('Full Name'),
//                   validator: (value) => value == null || value.trim().isEmpty
//                       ? 'Name is required'
//                       : null,
//                 ),
//                 const SizedBox(height: 15),
//                 TextFormField(
//                   controller: _placeController,
//                   decoration: _buildInputDecoration('PLace'),
//                   validator: (value) => value == null || value.trim().isEmpty
//                       ? 'Place is required'
//                       : null,
//                 ),
//                 const SizedBox(height: 15),
//
//
//                 const SizedBox(height: 15),
//                 TextFormField(
//                   controller: _dobController,
//                   readOnly: true,
//                   decoration: _buildInputDecoration('Date of Birth'),
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime(2000),
//                       firstDate: DateTime(1950),
//                       lastDate: DateTime.now(),
//                     );
//
//                     if (pickedDate != null) {
//                       setState(() {
//                         _dobController.text =
//                         "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
//                       });
//                     }
//                   },
//                   validator: (value) =>
//                   value == null || value.isEmpty ? 'DOB is required' : null,
//                 ),
//
//                 const SizedBox(height: 15),
//
//                 TextFormField(
//                   controller: _phoneController,
//                   decoration: _buildInputDecoration('Phone Number'),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Phone number is required';
//                     }
//                     if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//                       return 'Enter a valid 10-digit phone number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 15),
//
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: _buildInputDecoration('Email'),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Email is required';
//                     }
//                     if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
//                       return 'Enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 TextFormField(
//                   controller: _usernameController,
//                   decoration: _buildInputDecoration('Username'),
//                   validator: (value) => value == null || value.trim().isEmpty
//                       ? 'Username is required'
//                       : null,
//                 ),
//                 const SizedBox(height: 15),
//
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: _buildInputDecoration('Password'),
//                   validator: (value) => value == null || value.trim().isEmpty
//                       ? 'Password is required'
//                       : null,
//                 ),
//                 const SizedBox(height: 30),
//                 TextFormField(
//                   controller: _cpasswordController,
//                   obscureText: true,
//                   decoration: _buildInputDecoration('Password'),
//                   validator: (value) => value == null || value.trim().isEmpty
//                       ? 'Password is required'
//                       : null,
//                 ),
//                 SizedBox(height: 20,),
//
//                 ElevatedButton(
//                   onPressed: _sendData,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.accentGreen,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     textStyle: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                     elevation: 5,
//                     minimumSize: const Size.fromHeight(50),
//                   ),
//                   child: const Text("Register Account"),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../login.dart';

enum Gender { male, female }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
    _nameController.dispose();
    _emailController.dispose();
    _placeController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

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
        Fluttertoast.showToast(
          msg: "Photo selected successfully",
          backgroundColor: Colors.green.shade600,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: "No image selected",
          backgroundColor: Colors.orange.shade600,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      print("Image picker error: $e");
      Fluttertoast.showToast(
        msg: "Failed to pick image",
        backgroundColor: Colors.red.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  // Password validation function
  bool _isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*]'))) return false;
    return true;
  }

  // Get password strength
  int _getPasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*]'))) strength++;
    return strength;
  }

  // Get strength color
  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Get strength text
  String _getStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Strong';
      default:
        return '';
    }
  }

  // Phone validation
  bool _isPhoneValid(String phone) {
    return RegExp(r'^[6-9][0-9]{9}$').hasMatch(phone);
  }

  Future<void> _sendData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');

      if (url == null) {
        Fluttertoast.showToast(
          msg: "Server URL not found.",
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
        setState(() {
          _isLoading = false;
        });
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
              filename: 'user_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: "Selected image file not found",
            backgroundColor: Colors.red.shade600,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }

      try {
        var response = await request.send();
        var respStr = await response.stream.bytesToString();
        var data = jsonDecode(respStr);

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200 && data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: data['message'] ?? 'Registration Successful',
            backgroundColor: Colors.green.shade600,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
              const MyLoginPage(title: ''),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = 0.0;
                const end = 1.0;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );
                return FadeTransition(
                  opacity: animation.drive(tween),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: data['message'] ?? "Registration failed",
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
          msg: "Network Error: $e",
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please fix errors in the form",
        backgroundColor: Colors.orange.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyLoginPage(title: '')),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Create Account',
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyLoginPage(title: '')),
                );
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Icon
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_add,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Register New Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1E1E),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Fill in your details to get started',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Photo Upload Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          if (_selectedImage != null)
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                image: DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.green.shade600,
                                size: 24,
                              ),
                            ),
                            title: const Text(
                              'Profile Photo',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            subtitle: Text(
                              _selectedImage != null
                                  ? 'Photo selected'
                                  : 'Tap to upload your photo',
                              style: TextStyle(
                                color: _selectedImage != null
                                    ? Colors.green.shade600
                                    : Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                            trailing: ElevatedButton(
                              onPressed: _chooseImage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedImage != null
                                    ? Colors.green.shade500
                                    : Colors.green.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                _selectedImage != null ? 'Change' : 'Add',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Personal Information Section
                    _buildSectionTitle('Personal Information'),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Name is required'
                          : value.trim().length < 3
                          ? 'Name must be at least 3 characters'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _placeController,
                      label: 'Place',
                      icon: Icons.location_on_outlined,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Place is required'
                          : null,
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
                        controller: _dobController,
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
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
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
                              _dobController.text =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            });
                          }
                        },
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Date of Birth is required' : null,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Contact Information Section
                    _buildSectionTitle('Contact Information'),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        if (!_isPhoneValid(value)) {
                          return 'Enter valid 10-digit number starting with 6/7/8/9';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      suffixIcon: _phoneController.text.isNotEmpty && _isPhoneValid(_phoneController.text)
                          ? Container(
                        margin: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 20,
                        ),
                      )
                          : null,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Account Information Section
                    _buildSectionTitle('Account Information'),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _usernameController,
                      label: 'Username',
                      icon: Icons.person_outline,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Username is required'
                          : value.trim().length < 4
                          ? 'Username must be at least 4 characters'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    _buildPasswordField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: _obscurePassword,
                      onToggle: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        }
                        if (!_isPasswordValid(value)) {
                          return 'Password must be 8+ chars, include uppercase, lowercase, number & special character';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    // Password Strength Indicator
                    if (_passwordController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12, left: 4, right: 4),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Password Strength',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _getStrengthText(_getPasswordStrength(_passwordController.text)),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _getStrengthColor(_getPasswordStrength(_passwordController.text)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _getPasswordStrength(_passwordController.text) / 5,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getStrengthColor(_getPasswordStrength(_passwordController.text)),
                              ),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 8),

                    // Password Requirements
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.shade100,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                size: 18,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Password Requirements',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildRequirementItem(
                            'At least 8 characters',
                            _passwordController.text.length >= 8,
                          ),
                          _buildRequirementItem(
                            'At least 1 uppercase letter',
                            _passwordController.text.contains(RegExp(r'[A-Z]')),
                          ),
                          _buildRequirementItem(
                            'At least 1 lowercase letter',
                            _passwordController.text.contains(RegExp(r'[a-z]')),
                          ),
                          _buildRequirementItem(
                            'At least 1 number',
                            _passwordController.text.contains(RegExp(r'[0-9]')),
                          ),
                          _buildRequirementItem(
                            'At least 1 special character (!@#\$%^&*)',
                            _passwordController.text.contains(RegExp(r'[!@#$%^&*]')),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password Field
                    _buildPasswordField(
                      controller: _cpasswordController,
                      label: 'Confirm Password',
                      obscureText: _obscureConfirmPassword,
                      onToggle: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    // Password Match Status
                    if (_cpasswordController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Row(
                          children: [
                            Icon(
                              _passwordController.text == _cpasswordController.text
                                  ? Icons.check_circle
                                  : Icons.error_outline,
                              size: 16,
                              color: _passwordController.text == _cpasswordController.text
                                  ? Colors.green.shade600
                                  : Colors.red.shade400,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _passwordController.text == _cpasswordController.text
                                  ? 'Passwords match'
                                  : 'Passwords do not match',
                              style: TextStyle(
                                fontSize: 13,
                                color: _passwordController.text == _cpasswordController.text
                                    ? Colors.green.shade600
                                    : Colors.red.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Register Button
                    Container(
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
                        onPressed: _isLoading ? null : _sendData,
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
                              Icons.app_registration,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Create Account',
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

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyLoginPage(title: ''),
                              ),
                            );
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Version Text
                    Center(
                      child: Text(
                        'Secure Registration v1.0.0',
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
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E1E1E),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    Widget? suffixIcon,
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
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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
          suffixIcon: suffixIcon,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.red.shade400,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.red.shade400,
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
          errorStyle: TextStyle(
            color: Colors.red.shade400,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
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
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            child: Icon(
              Icons.lock_outline_rounded,
              color: Colors.green.shade600,
              size: 24,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey.shade500,
              size: 24,
            ),
            onPressed: onToggle,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.red.shade400,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.red.shade400,
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
          errorStyle: TextStyle(
            color: Colors.red.shade400,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isValid ? Colors.green.shade600 : Colors.grey.shade400,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isValid ? Colors.green.shade700 : Colors.grey.shade600,
              fontWeight: isValid ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
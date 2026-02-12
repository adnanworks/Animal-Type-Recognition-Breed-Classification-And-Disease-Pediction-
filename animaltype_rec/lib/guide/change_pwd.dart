// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../login.dart';
//
//
//
// void main() {
//   runApp(const GuideChangepwd());
// }
//
// class GuideChangepwd extends StatelessWidget {
//   const GuideChangepwd({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ChangePassword',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const GuideChangepwdPage(title: 'ChangePassword'),
//     );
//   }
// }
//
// class GuideChangepwdPage extends StatefulWidget {
//   const GuideChangepwdPage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<GuideChangepwdPage> createState() => GuideChangepwdPageState();
// }
//
// class GuideChangepwdPageState extends State<GuideChangepwdPage> {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController oldpasswordController = new TextEditingController();
//     TextEditingController newpasswordController = new TextEditingController();
//     TextEditingController confirmpasswordController =new TextEditingController();
//
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   controller: oldpasswordController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     label: Text("Old Password"),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   controller: newpasswordController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     label: Text("New Password"),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextField(
//                   controller: confirmpasswordController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     label: Text("Confirm Password"),
//                   ),
//                 ),
//               ),
//
//               ElevatedButton(
//                 onPressed: () async {
//                   String oldp = oldpasswordController.text.toString();
//                   String newp = newpasswordController.text.toString();
//                   String cnfrmp = confirmpasswordController.text.toString();
//
//                   SharedPreferences sh = await SharedPreferences.getInstance();
//                   String url = sh.getString('url').toString();
//                   String lid = sh.getString('lid').toString();
//                   print(lid);
//
//                   final urls = Uri.parse('$url/guide_changepassword/');
//                   try {
//                     final response = await http.post(
//                       urls,
//                       body: {
//                         'oldpassword': oldp,
//                         'newpassword': newp,
//                         'confirmpassword': cnfrmp,
//                         'lid': lid,
//                       },
//                     );
//                     if (response.statusCode == 200) {
//                       String status = jsonDecode(response.body)['status'];
//                       if (status == 'ok') {
//                         Fluttertoast.showToast(
//                           msg: 'Password Changed Successfully',
//                         );
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MyLoginPage(title: 'Login'),
//                           ),
//                         );
//                       } else {
//                         Fluttertoast.showToast(msg: 'Incorrect Password');
//                       }
//                     } else {
//                       Fluttertoast.showToast(msg: 'Network Error');
//                     }
//                   } catch (e) {
//                     Fluttertoast.showToast(msg: e.toString());
//                   }
//                 },
//                 child: Text("ChangePassword"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart';

void main() {
  runApp(const GuideChangepwd());
}

class GuideChangepwd extends StatelessWidget {
  const GuideChangepwd({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChangePassword',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: const GuideChangepwdPage(title: 'Change Password'),
    );
  }
}

class GuideChangepwdPage extends StatefulWidget {
  const GuideChangepwdPage({super.key, required this.title});

  final String title;

  @override
  State<GuideChangepwdPage> createState() => GuideChangepwdPageState();
}

class GuideChangepwdPageState extends State<GuideChangepwdPage> with SingleTickerProviderStateMixin {
  late TextEditingController oldpasswordController;
  late TextEditingController newpasswordController;
  late TextEditingController confirmpasswordController;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    oldpasswordController = TextEditingController();
    newpasswordController = TextEditingController();
    confirmpasswordController = TextEditingController();

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
    oldpasswordController.dispose();
    newpasswordController.dispose();
    confirmpasswordController.dispose();
    _animationController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Header with back button and title
                    Row(
                      children: [
                        Container(
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
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.shade800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.green.shade700,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Security Icon
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
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
                            Icons.shield_outlined,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Old Password Field
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
                      child: TextField(
                        controller: oldpasswordController,
                        obscureText: _obscureOld,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          hintText: 'Enter your current password',
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
                              _obscureOld
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey.shade500,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureOld = !_obscureOld;
                              });
                            },
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
                      ),
                    ),

                    const SizedBox(height: 20),

                    // New Password Field
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
                      child: TextField(
                        controller: newpasswordController,
                        obscureText: _obscureNew,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          hintText: 'Enter new password',
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.key_outlined,
                              color: Colors.green.shade600,
                              size: 24,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNew
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey.shade500,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNew = !_obscureNew;
                              });
                            },
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
                      ),
                    ),

                    // Password Strength Indicator
                    if (newpasswordController.text.isNotEmpty)
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
                                  _getStrengthText(_getPasswordStrength(newpasswordController.text)),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _getStrengthColor(_getPasswordStrength(newpasswordController.text)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _getPasswordStrength(newpasswordController.text) / 5,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getStrengthColor(_getPasswordStrength(newpasswordController.text)),
                              ),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Password Requirements Card
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
                                Icons.info_outline,
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
                            newpasswordController.text.length >= 8,
                          ),
                          _buildRequirementItem(
                            'At least 1 uppercase letter (A-Z)',
                            newpasswordController.text.contains(RegExp(r'[A-Z]')),
                          ),
                          _buildRequirementItem(
                            'At least 1 lowercase letter (a-z)',
                            newpasswordController.text.contains(RegExp(r'[a-z]')),
                          ),
                          _buildRequirementItem(
                            'At least 1 number (0-9)',
                            newpasswordController.text.contains(RegExp(r'[0-9]')),
                          ),
                          _buildRequirementItem(
                            'At least 1 special character (!@#\$%^&*)',
                            newpasswordController.text.contains(RegExp(r'[!@#$%^&*]')),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password Field
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
                      child: TextField(
                        controller: confirmpasswordController,
                        obscureText: _obscureConfirm,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter new password',
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.check_circle_outline,
                              color: confirmpasswordController.text.isNotEmpty &&
                                  newpasswordController.text == confirmpasswordController.text
                                  ? Colors.green.shade600
                                  : Colors.grey.shade500,
                              size: 24,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey.shade500,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirm = !_obscureConfirm;
                              });
                            },
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
                              color: confirmpasswordController.text.isNotEmpty &&
                                  newpasswordController.text == confirmpasswordController.text
                                  ? Colors.green.shade400
                                  : Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: confirmpasswordController.text.isNotEmpty &&
                                  newpasswordController.text == confirmpasswordController.text
                                  ? Colors.green.shade400
                                  : Colors.grey.shade400,
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
                      ),
                    ),

                    // Password Match Status
                    if (confirmpasswordController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Row(
                          children: [
                            Icon(
                              newpasswordController.text == confirmpasswordController.text
                                  ? Icons.check_circle
                                  : Icons.error_outline,
                              size: 16,
                              color: newpasswordController.text == confirmpasswordController.text
                                  ? Colors.green.shade600
                                  : Colors.red.shade400,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              newpasswordController.text == confirmpasswordController.text
                                  ? 'Passwords match'
                                  : 'Passwords do not match',
                              style: TextStyle(
                                fontSize: 13,
                                color: newpasswordController.text == confirmpasswordController.text
                                    ? Colors.green.shade600
                                    : Colors.red.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Change Password Button
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
                        onPressed: oldpasswordController.text.isEmpty ||
                            !_isPasswordValid(newpasswordController.text) ||
                            newpasswordController.text != confirmpasswordController.text ||
                            _isLoading
                            ? null
                            : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          String oldp = oldpasswordController.text.toString();
                          String newp = newpasswordController.text.toString();
                          String cnfrmp = confirmpasswordController.text.toString();

                          SharedPreferences sh = await SharedPreferences.getInstance();
                          String url = sh.getString('url').toString();
                          String lid = sh.getString('lid').toString();
                          print(lid);

                          final urls = Uri.parse('$url/guide_changepassword/');
                          try {
                            final response = await http.post(
                              urls,
                              body: {
                                'oldpassword': oldp,
                                'newpassword': newp,
                                'confirmpassword': cnfrmp,
                                'lid': lid,
                              },
                            );

                            setState(() {
                              _isLoading = false;
                            });

                            if (response.statusCode == 200) {
                              String status = jsonDecode(response.body)['status'];
                              if (status == 'ok') {
                                Fluttertoast.showToast(
                                  msg: 'Password Changed Successfully',
                                  backgroundColor: Colors.green.shade600,
                                  textColor: Colors.white,
                                  gravity: ToastGravity.BOTTOM,
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyLoginPage(title: 'Login'),
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'Incorrect Current Password',
                                  backgroundColor: Colors.red.shade600,
                                  textColor: Colors.white,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Network Error',
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
                              msg: e.toString(),
                              backgroundColor: Colors.red.shade600,
                              textColor: Colors.white,
                              gravity: ToastGravity.BOTTOM,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: Colors.transparent,
                          disabledForegroundColor: Colors.white.withOpacity(0.6),
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
                              Icons.key_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Update Password',
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

                    // Password Tips
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tips_and_updates_outlined,
                            size: 20,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Use a strong password that you don\'t use elsewhere',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Version Text
                    Center(
                      child: Text(
                        'Secure Password v1.0.0',
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
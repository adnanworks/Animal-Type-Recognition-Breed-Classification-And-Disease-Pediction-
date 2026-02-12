// import 'dart:convert';
// import 'package:animaltype_rec/user/home.dart';
// import 'package:animaltype_rec/user/register.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'guide/home.dart';
// import 'main.dart';
//
// void main() {
//   runApp( mylogin());
// }
//
// class mylogin extends StatelessWidget {
//   const mylogin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyLoginPage(title: 'IP Page'),
//     );
//   }
// }
// class MyLoginPage extends StatefulWidget {
//   const MyLoginPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyLoginPage> createState() => _MyLoginPageState();
// }
//
// class _MyLoginPageState extends State<MyLoginPage> {
//   final TextEditingController _usernametextController = TextEditingController();
//   final TextEditingController _passwordtextController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async{
//         Navigator.push(context, MaterialPageRoute(builder: (builder)=>ip(title: '')));
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xFFEFF3FF),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 100),
//                 const Text(
//                   "Login Page",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF0047AB),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 TextField(
//                   controller: _usernametextController,
//                   decoration: const InputDecoration(
//                     labelText: "Email ID",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: _passwordtextController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     labelText: "Password",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _sendData,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: const Text("Login", style: TextStyle(fontSize: 16)),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "User Register Here : ",
//                       style: TextStyle(color: Colors.black87),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const RegisterPage()),
//                         );
//                       },
//                       child: const Text(
//                         "Register",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.orange,
//                         ),
//                       ),
//
//
//                     ),
//                   ],
//
//                 ),
//                 const SizedBox(height: 20),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // const Text(
//                     //   "Forgot Password: ",
//                     //   style: TextStyle(color: Colors.black87),
//                     // ),
//                     // GestureDetector(
//                     //   onTap: () {
//                     //     Navigator.push(
//                     //       context,
//                     //       MaterialPageRoute(builder: (context) => const forgtPasswordPage(title: '')),
//                     //     );
//                     //   },
//                     //   child: const Text(
//                     //     "Click Here",
//                     //     style: TextStyle(
//                     //       fontWeight: FontWeight.bold,
//                     //       color: Colors.orange,
//                     //     ),
//                     //   ),
//                     //
//                     //
//                     // ),
//                   ],
//
//                 ),
//
//
//               ],
//                 ),
//
//             ),
//           ),
//
//       ),
//     );
//   }
//
//   Future<void> _sendData() async {
//     String uname = _usernametextController.text.trim();
//     String password = _passwordtextController.text.trim();
//
//     if (uname.isEmpty || password.isEmpty) {
//       Fluttertoast.showToast(msg: 'Please enter both email and password');
//       return;
//     }
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//
//     if (url == null || url.isEmpty) {
//       Fluttertoast.showToast(msg: 'Server URL not configured');
//       return;
//     }
//
//     final urls = Uri.parse('$url/flutter_login/');
//     try {
//       final response = await http.post(
//         urls,
//         body: {'Username': uname, 'Password': password},
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         String status = data['status'].toString();
//         String message = data['message'].toString();
//         String type = data['type'].toString();
//
//         Fluttertoast.showToast(msg: message);
//
//         if (status == 'ok') {
//           String lid = data['lid'].toString();
//           await sh.setString("lid", lid);
//
//
//
//           // String oid = data['oid'].toString();
//           // await sh.setString("oid", oid);
//
//           if(type == "guide"){
//            Navigator.push(context, MaterialPageRoute(builder: (context) => GuideHomePage(),));
//           }
//           else if (type == "user"){
//             Navigator.push(context, MaterialPageRoute(builder: (context) => UserHomePage(),));
//
//           }
//
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//     }
//   }
// }





import 'dart:convert';
import 'package:animaltype_rec/user/home.dart';
import 'package:animaltype_rec/user/register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'guide/home.dart';
import 'main.dart';

void main() {
  runApp(mylogin());
}

class mylogin extends StatelessWidget {
  const mylogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: const MyLoginPage(title: 'Login'),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});
  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _usernametextController = TextEditingController();
  final TextEditingController _passwordtextController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
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
    _usernametextController.dispose();
    _passwordtextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (builder) => ip(title: '')),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo Section
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 24),
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
                            Icons.pets,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Welcome Text
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E1E1E),
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'Sign in to continue your wildlife journey',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 48),

                      // Email Field
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
                          controller: _usernametextController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'your@email.com',
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.email_outlined,
                                color: Colors.green.shade600,
                                size: 24,
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
                          onChanged: (value) => setState(() {}),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Password Field
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
                          controller: _passwordtextController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
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
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey.shade500,
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
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
                          onChanged: (value) => setState(() {}),
                        ),
                      ),

                      // Forgot Password (Commented as in original)
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => const forgtPasswordPage(title: ''),
                      //         ),
                      //       );
                      //     },
                      //     style: TextButton.styleFrom(
                      //       padding: const EdgeInsets.symmetric(vertical: 8),
                      //     ),
                      //     child: Text(
                      //       'Forgot Password?',
                      //       style: TextStyle(
                      //         color: Colors.green.shade600,
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 14,
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(height: 32),

                      // Login Button
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _usernametextController.text.isEmpty ||
                              _passwordtextController.text.isEmpty ||
                              _isLoading
                              ? null
                              : _sendData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.zero,
                            elevation: 0,
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
                              const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Register Section
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New to Animal Recognition? ",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade600,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Version Text
                      Text(
                        'Animal Recognition v1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendData() async {
    setState(() {
      _isLoading = true;
    });

    String uname = _usernametextController.text.trim();
    String password = _passwordtextController.text.trim();

    if (uname.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter both email and password');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    if (url == null || url.isEmpty) {
      Fluttertoast.showToast(msg: 'Server URL not configured');
      setState(() {
        _isLoading = false;
      });
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

          setState(() {
            _isLoading = false;
          });

          if (type == "guide") {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const GuideHomePage(),
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
          } else if (type == "user") {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const UserHomePage(),
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
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
// import 'dart:convert';
// import 'package:animaltype_rec/user/view_reply.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'home.dart';
//
// void main() {
//   runApp(const Send_complaint());
// }
//
// class Send_complaint extends StatelessWidget {
//   const Send_complaint({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Send Complaint',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const Send_complaintPage(title: 'Send Complaint'),
//     );
//   }
// }
//
// class Send_complaintPage extends StatefulWidget {
//   const Send_complaintPage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<Send_complaintPage> createState() => Send_complaintPageState();
// }
//
// class Send_complaintPageState extends State<Send_complaintPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _nametextController = TextEditingController();
//   bool _isLoading = false;
//
//
//   Future<void> _sendData() async {
//     if (!_formKey.currentState!.validate()) {
//       Fluttertoast.showToast(msg: "Please fix errors in the form");
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       String name = _nametextController.text.trim();
//
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String? url = sh.getString('url');
//       String lid = sh.getString('lid') ?? '';
//
//
//
//       if (url == null) {
//         Fluttertoast.showToast(msg: "Server URL not found.");
//         return;
//       }
//
//       final uri = Uri.parse('$url/user_sendComplaint/');
//       var request = http.MultipartRequest('POST', uri);
//
//       request.fields['name'] = name;
//       request.fields['lid'] = lid;
//
//
//
//
//       var response = await request.send();
//       var respStr = await response.stream.bytesToString();
//       var data = jsonDecode(respStr);
//
//       if (response.statusCode == 200) {
//         if (data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: "Submitted successfully.");
//           _clearForm();
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const UserHomePage()),
//           );
//         } else {
//           Fluttertoast.showToast(
//               msg: "Submission failed: ${data['message'] ?? 'Unknown error'}");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error sending data: $e");
//       Fluttertoast.showToast(msg: "Error: ${e.toString()}");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _clearForm() {
//     _nametextController.clear();
//     setState(() {
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const UserHomePage()),
//         );
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//           centerTitle: true,
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           foregroundColor: Colors.white,
//         ),
//         body: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _nametextController,
//                   decoration: const InputDecoration(
//                     labelText: 'Send Complaint',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.comment),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter Complaint';
//                     }
//                     if (value.trim().length < 2) {
//                       return 'Field must be at least 2 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
//
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _sendData,
//                     child: _isLoading
//                         ? const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor:
//                             AlwaysStoppedAnimation<Color>(
//                                 Colors.white),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Text("Submitting..."),
//                       ],
//                     )
//                         : const Text("Submit"),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ViewcomplaintsPage(title: '')),
//                     );
//                   },
//                   child: const Text('View Send Complaints'),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size.fromHeight(50),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _nametextController.dispose();
//     super.dispose();
//   }
// }


import 'dart:convert';
import 'package:animaltype_rec/user/view_reply.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

void main() {
  runApp(const Send_complaint());
}

class Send_complaint extends StatelessWidget {
  const Send_complaint({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send Complaint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: const Send_complaintPage(title: 'Send Complaint'),
    );
  }
}

class Send_complaintPage extends StatefulWidget {
  const Send_complaintPage({super.key, required this.title});

  final String title;

  @override
  State<Send_complaintPage> createState() => Send_complaintPageState();
}

class Send_complaintPageState extends State<Send_complaintPage> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nametextController = TextEditingController();
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
    _nametextController.dispose();
    super.dispose();
  }

  Future<void> _sendData() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Please fix errors in the form",
        backgroundColor: Colors.orange.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String name = _nametextController.text.trim();

      SharedPreferences sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');
      String lid = sh.getString('lid') ?? '';

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

      final uri = Uri.parse('$url/user_sendComplaint/');
      var request = http.MultipartRequest('POST', uri);

      request.fields['name'] = name;
      request.fields['lid'] = lid;

      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200) {
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: "Complaint submitted successfully",
            backgroundColor: Colors.green.shade600,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
          );
          _clearForm();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserHomePage()),
          );
        } else {
          Fluttertoast.showToast(
            msg: "Submission failed: ${data['message'] ?? 'Unknown error'}",
            backgroundColor: Colors.red.shade600,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Server error: ${response.statusCode}",
          backgroundColor: Colors.red.shade600,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      print("Error sending data: $e");
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        backgroundColor: Colors.red.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _nametextController.clear();
    setState(() {});
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Send Complaint',
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
                  MaterialPageRoute(builder: (context) => const UserHomePage()),
                );
              },
            ),
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _isLoading
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.green,
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Submitting your complaint...",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
                : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Icon
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
                            Icons.report_problem_outlined,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Title
                    const Text(
                      'We\'re here to help',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1E1E),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Please describe your issue or concern below',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Complaint Text Field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _nametextController,
                        maxLines: 6,
                        minLines: 4,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write your complaint here...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              Icons.comment_outlined,
                              color: Colors.green.shade600,
                              size: 24,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.green.shade400,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.red.shade400,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.red.shade400,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your complaint';
                          }
                          if (value.trim().length < 10) {
                            return 'Please provide more details (minimum 10 characters)';
                          }
                          return null;
                        },
                      ),
                    ),

                    // Character count indicator
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 4),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${_nametextController.text.length} characters',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Submit Complaint',
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

                    const SizedBox(height: 20),

                    // View Complaints Button
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewcomplaintsPage(title: ''),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green.shade700,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history_outlined,
                              color: Colors.green.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'View My Complaints',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Help Text
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.shade100,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'What happens next?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your complaint will be reviewed by our team. You can track the status and view replies in "View My Complaints".',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Version Text
                    Center(
                      child: Text(
                        'Complaint System v1.0.0',
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
}
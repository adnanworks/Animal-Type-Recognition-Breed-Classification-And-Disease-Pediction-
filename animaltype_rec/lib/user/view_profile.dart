// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'edit_profile.dart';
//
// void main() {
//   runApp(const UserViewProfile());
// }
//
// class UserViewProfile extends StatelessWidget {
//   const UserViewProfile({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'View Profile',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const UserViewProfilePage(title: 'View Profile'),
//     );
//   }
// }
//
// class UserViewProfilePage extends StatefulWidget {
//   const UserViewProfilePage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<UserViewProfilePage> createState() => UserViewProfilePageState();
// }
//
// class UserViewProfilePageState extends State<UserViewProfilePage> {
//   UserViewProfilePageState() {
//     _send_data();
//   }
//
//   String name_ = "";
//   String email_ = "";
//   String place_ = "";
//   String dob_ = "";
//   String phone_ = "";
//   String photo_ = "";
//   String img_url_ = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//         // appBar: AppBar(
//         //   leading: const BackButton(),
//         //   backgroundColor: Theme.of(context).colorScheme.primary,
//         //   title: Text(widget.title),
//         // ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//
//               if (photo_.isNotEmpty)
//                 Center(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(75),
//                     child: Image.network(
//                       _buildImageUrl(),
//                       width: 150,
//                       height: 150,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return const SizedBox(
//                           width: 150,
//                           height: 150,
//                           child: Center(
//                             child: CircularProgressIndicator(),
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) =>
//                       const Icon(Icons.account_circle, size: 150),
//                     ),
//                   ),
//                 )
//               else
//                 const Center(
//                   child: Icon(Icons.account_circle, size: 150),
//                 ),
//
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text('Name: $name_'),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text('Email: $email_'),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text('Place: $place_'),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text(' Date of Birth: $dob_'),
//               ),
//
//
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: Text('Phone: $phone_'),
//               ),
//
//               const SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const EditprofilePage(),
//                       ),
//                     );
//                   },
//                   child: const Text("Edit Profile"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   String _buildImageUrl() {
//     if (img_url_.isEmpty || photo_.isEmpty) return '';
//     if (img_url_.endsWith('/')) {
//       return "${img_url_}media/$photo_";
//     } else {
//       return "$img_url_/media/$photo_";
//     }
//   }
//
//   void _send_data() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//     String img_url = sh.getString('img_url') ?? '';
//
//     setState(() {
//       img_url_ = img_url;
//     });
//
//     final urls = Uri.parse('$url/user_viewprofile/');
//     try {
//       final response = await http.post(urls, body: {
//         'lid': lid,
//       });
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           setState(() {
//             name_ = data['name'];
//             email_ = data['email'];
//             place_ = data['place'];
//             dob_ = data['dob'].toString();
//             phone_ = data['phone'];
//             photo_ = data['photo'];
//           });
//         } else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }
//





import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile.dart';

void main() {
  runApp(const UserViewProfile());
}

class UserViewProfile extends StatelessWidget {
  const UserViewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: const UserViewProfilePage(title: 'View Profile'),
    );
  }
}

class UserViewProfilePage extends StatefulWidget {
  const UserViewProfilePage({super.key, required this.title});
  final String title;

  @override
  State<UserViewProfilePage> createState() => UserViewProfilePageState();
}

class UserViewProfilePageState extends State<UserViewProfilePage> with SingleTickerProviderStateMixin {
  UserViewProfilePageState() {
    _send_data();
  }

  String name_ = "";
  String email_ = "";
  String place_ = "";
  String dob_ = "";
  String phone_ = "";
  String photo_ = "";
  String img_url_ = "";

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
    super.dispose();
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              'Your',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.shade800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Profile',
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

                    // Profile Photo Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade50,
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Profile Image
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green.shade400,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: photo_.isNotEmpty
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(85),
                                  child: Image.network(
                                    _buildImageUrl(),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.green.shade600,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            size: 80,
                                            color: Colors.green.shade300,
                                          ),
                                        ),
                                  ),
                                )
                                    : Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.green.shade300,
                                  ),
                                ),
                              ),
                              // Verified Badge
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Name and Role
                          Text(
                            name_,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E1E1E),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 16,
                                  color: Colors.green.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Wildlife Explorer',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Profile Information Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: Colors.green.shade600,
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
                          const SizedBox(height: 24),

                          _buildInfoTile(
                            icon: Icons.email_outlined,
                            label: 'Email Address',
                            value: email_,
                            color: Colors.blue,
                          ),

                          _buildDivider(),

                          _buildInfoTile(
                            icon: Icons.location_on_outlined,
                            label: 'Location',
                            value: place_,
                            color: Colors.orange,
                          ),

                          _buildDivider(),

                          _buildInfoTile(
                            icon: Icons.cake_outlined,
                            label: 'Date of Birth',
                            value: dob_,
                            color: Colors.purple,
                          ),

                          _buildDivider(),

                          _buildInfoTile(
                            icon: Icons.phone_outlined,
                            label: 'Phone Number',
                            value: phone_,
                            color: Colors.green,
                            isPhone: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Edit Profile Button
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditprofilePage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Edit Profile",
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
                        'Profile v1.0.0',
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

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isPhone = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              if (isPhone)
                Row(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (value.length == 10 && (value.startsWith('6') || value.startsWith('7') || value.startsWith('8') || value.startsWith('9')))
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.green.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                )
              else
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        color: Colors.grey.shade200,
        height: 1,
      ),
    );
  }

  String _buildImageUrl() {
    if (img_url_.isEmpty || photo_.isEmpty) return '';
    if (img_url_.endsWith('/')) {
      return "${img_url_}media/$photo_";
    } else {
      return "$img_url_/media/$photo_";
    }
  }

  void _send_data() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String img_url = sh.getString('img_url') ?? '';

    setState(() {
      img_url_ = img_url;
    });

    final urls = Uri.parse('$url/user_viewprofile/');
    try {
      final response = await http.post(urls, body: {
        'lid': lid,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            name_ = data['name'];
            email_ = data['email'];
            place_ = data['place'];
            dob_ = data['dob'].toString();
            phone_ = data['phone'];
            photo_ = data['photo'];
          });
        } else {
          Fluttertoast.showToast(
            msg: 'Not Found',
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
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
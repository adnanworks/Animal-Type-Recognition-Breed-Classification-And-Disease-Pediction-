//
// import 'dart:convert';
//
// import 'package:animaltype_rec/guide/home.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(const ViewAssignedPackages());
// }
//
// class ViewAssignedPackages extends StatelessWidget {
//   const ViewAssignedPackages({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ViewAssignedPackagePage(title: 'View Assigned packages'),
//     );
//   }
// }
//
// class ViewAssignedPackagePage extends StatefulWidget {
//   const ViewAssignedPackagePage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<ViewAssignedPackagePage> createState() => ViewExamPageState();
// }
//
// class ViewExamPageState extends State<ViewAssignedPackagePage> {
//   List<Map<String, dynamic>> users = [];
//
//   @override
//   void initState() {
//     super.initState();
//     viewUsers();
//   }
//
//   Future<void> viewUsers() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url') ?? '';
//       String lid = sh.getString('lid').toString();
//
//
//       String apiUrl = '$urls/guide_view_assipackages/';
//       var response = await http.post(Uri.parse(apiUrl), body: {'lid': lid,});
//       var jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         List<Map<String, dynamic>> tempList = [];
//         for (var item in jsonData['data']) {
//           tempList.add({
//             'id': item['id'].toString(),
//             'package': item['package'].toString(),
//             'description': item['description'].toString(),
//             'price': item['price'].toString(),
//             'days': item['days'].toString(),
//             'date': item['date'].toString(),
//             'STATUS': item['STATUS']?.toString() ?? '',
//           });
//         }
//         setState(() {
//           users = tempList;
//         });
//       }
//     } catch (e) {
//       print("Error fetching : $e");
//     }
//   }
//
//   Future<void> acceptPackage(String assignedId) async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url') ?? '';
//
//       var response = await http.post(
//         Uri.parse('$url/guide_accept_package/'),
//         body: {'assigned_id': assignedId},
//       );
//
//       var jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Package accepted')),
//         );
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const GuideHomePage()),
//         );
//       }
//     } catch (e) {
//       print("Accept error: $e");
//     }
//   }
//
//
//
//   Future<void> rejectPackage(String assignedId) async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url') ?? '';
//
//       var response = await http.post(
//         Uri.parse('$url/guide_reject_package/'),
//         body: {'assigned_id': assignedId},
//       );
//
//       var jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Package Rejected')),
//         );
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const GuideHomePage()),
//         );
//       }
//     } catch (e) {
//       print("Reject error: $e");
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const GuideHomePage()),
//         );
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//           centerTitle: true,
//         ),
//         body: users.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : ListView.builder(
//           shrinkWrap: true,
//           physics: const BouncingScrollPhysics(),
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             final user = users[index];
//             return Card(
//               margin: const EdgeInsets.all(10),
//               elevation: 5,
//               child: ListTile(
//                 title: Text(
//                   user['package'],
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Description: ${user['description']}"),
//                     Text("Assigned Date: ${user['date']}"),
//                     Text("Days: ${user['days']}"),
//                     Text("Price: ${user['price']}"),
//                     Text("Status: ${user['STATUS']}"),
//
//                     SizedBox(height: 10,),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               acceptPackage(user['id']);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               minimumSize: const Size.fromHeight(45),
//                             ),
//                             child: const Text('Accept'),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               rejectPackage(user['id']);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               minimumSize: const Size.fromHeight(45),
//                             ),
//                             child: const Text('Reject'),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(height: 20,),
//
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:animaltype_rec/guide/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ViewAssignedPackages());
}

class ViewAssignedPackages extends StatelessWidget {
  const ViewAssignedPackages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ViewAssignedPackagePage(title: 'View Assigned packages'),
    );
  }
}

class ViewAssignedPackagePage extends StatefulWidget {
  const ViewAssignedPackagePage({super.key, required this.title});
  final String title;

  @override
  State<ViewAssignedPackagePage> createState() => ViewExamPageState();
}

class ViewExamPageState extends State<ViewAssignedPackagePage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> users = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    viewUsers();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> viewUsers() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String lid = sh.getString('lid').toString();

      String apiUrl = '$urls/guide_view_assipackages/';
      var response = await http.post(Uri.parse(apiUrl), body: {'lid': lid});
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, dynamic>> tempList = [];
        for (var item in jsonData['data']) {
          tempList.add({
            'id': item['id'].toString(),
            'package': item['package'].toString(),
            'description': item['description'].toString(),
            'price': item['price'].toString(),
            'days': item['days'].toString(),
            'date': item['date'].toString(),
            'STATUS': item['STATUS']?.toString() ?? '',
          });
        }
        setState(() {
          users = tempList;
        });
      }
    } catch (e) {
      print("Error fetching : $e");
    }
  }

  Future<void> acceptPackage(String assignedId) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? '';

      var response = await http.post(
        Uri.parse('$url/guide_accept_package/'),
        body: {'assigned_id': assignedId},
      );

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade400),
                const SizedBox(width: 12),
                const Text('Package accepted successfully'),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GuideHomePage()),
        );
      }
    } catch (e) {
      print("Accept error: $e");
    }
  }

  Future<void> rejectPackage(String assignedId) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url') ?? '';

      var response = await http.post(
        Uri.parse('$url/guide_reject_package/'),
        body: {'assigned_id': assignedId},
      );

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel, color: Colors.red.shade400),
                const SizedBox(width: 12),
                const Text('Package rejected'),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GuideHomePage()),
        );
      }
    } catch (e) {
      print("Reject error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GuideHomePage()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
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
                  MaterialPageRoute(builder: (context) => const GuideHomePage()),
                );
              },
            ),
          ),
        ),
        body: users.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inbox_rounded,
                  size: 60,
                  color: Colors.green.shade300,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No Assigned Packages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You don\'t have any package assignments yet',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        )
            : FadeTransition(
          opacity: _fadeAnimation,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return TweenAnimationBuilder(
                duration: Duration(milliseconds: 500 + (index * 100)),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with Package Name and Status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      Icons.inventory_2_outlined,
                                      color: Colors.green.shade600,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['package'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF2C3E50),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(user['STATUS']).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _getStatusIcon(user['STATUS']),
                                                size: 14,
                                                color: _getStatusColor(user['STATUS']),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                user['STATUS'].toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: _getStatusColor(user['STATUS']),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Package Details Grid
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.description_outlined,
                                label: 'Description',
                                value: user['description'],
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                icon: Icons.calendar_today_outlined,
                                label: 'Assigned Date',
                                value: user['date'],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDetailRow(
                                      icon: Icons.sunny_snowing,
                                      label: 'Duration',
                                      value: '${user['days']} ${int.parse(user['days']) > 1 ? 'Days' : 'Day'}',
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildDetailRow(
                                      icon: Icons.currency_rupee_outlined,
                                      label: 'Price',
                                      value: '₹ ${user['price']}',
                                      highlight: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (user['STATUS'].toLowerCase() == 'assigned')
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 52,
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
                                        color: Colors.green.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showConfirmationDialog(
                                        context,
                                        'Accept Package',
                                        'Are you sure you want to accept this package?',
                                            () => acceptPackage(user['id']),
                                        Colors.green,
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
                                          Icons.check_circle_outline,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Accept',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red.shade400,
                                        Colors.red.shade600,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showConfirmationDialog(
                                        context,
                                        'Reject Package',
                                        'Are you sure you want to reject this package?',
                                            () => rejectPackage(user['id']),
                                        Colors.red,
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
                                          Icons.cancel_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Reject',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _getStatusColor(user['STATUS']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getStatusIcon(user['STATUS']),
                                  color: _getStatusColor(user['STATUS']),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Package ${user['STATUS'].toLowerCase()}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(user['STATUS']),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey.shade500,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                  color: highlight ? Colors.green.shade700 : const Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return Colors.orange;
      case 'active':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return Icons.pending_outlined;
      case 'active':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      case 'completed':
        return Icons.flag_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  Future<void> _showConfirmationDialog(
      BuildContext context,
      String title,
      String message,
      VoidCallback onConfirm,
      Color color,
      ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              Icon(
                title.contains('Accept') ? Icons.check_circle : Icons.cancel,
                color: color,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF2C3E50),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(title.contains('Accept') ? 'Accept' : 'Reject'),
            ),
          ],
        );
      },
    );
  }
}
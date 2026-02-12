// import 'dart:convert';
// import 'package:animaltype_rec/guide/home.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(const GuideViewBookings());
// }
//
// class GuideViewBookings extends StatelessWidget {
//   const GuideViewBookings({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: GuideViewBookingsPage(title: 'View Bookings'),
//     );
//   }
// }
//
// class GuideViewBookingsPage extends StatefulWidget {
//   const GuideViewBookingsPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<GuideViewBookingsPage> createState() =>
//       GuideViewBookingsPageState();
// }
//
// class GuideViewBookingsPageState
//     extends State<GuideViewBookingsPage> {
//   List<Map<String, dynamic>> bookings = [];
//
//   @override
//   void initState() {
//     super.initState();
//     viewBookings();
//   }
//
//   // Fetch bookings from backend
//   Future<void> viewBookings() async {
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url') ?? '';
//       String lid = sh.getString('lid')?.toString() ?? '';
//
//       var response = await http.post(
//         Uri.parse('$urls/guide_view_bookings/'),
//         body: {'lid': lid},
//       );
//
//       var jsonData = json.decode(response.body);
//
//       if (jsonData['status'] == 'ok') {
//         List<Map<String, dynamic>> tempList = [];
//
//         for (var item in jsonData['data']) {
//           tempList.add({
//             'id': item['id']?.toString() ?? '',
//             'user': item['user']?.toString() ?? '',
//             'phone': item['phone']?.toString() ?? '',
//             'package': item['package']?.toString() ?? '',
//             'booked_date': item['booked_date']?.toString() ?? '',
//             'from_date': item['from_date']?.toString() ?? '',
//             'status': item['status']?.toString() ?? 'pending',
//           });
//         }
//
//         setState(() {
//           bookings = tempList;
//         });
//       }
//     } catch (e) {
//       print("Error fetching bookings: $e");
//     }
//   }
//
//   // Accept booking
//   Future<void> acceptBooking(String id) async {
//     if (id == '') return;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? '';
//
//     try {
//       await http.post(
//         Uri.parse('$url/guide_accept_booking/'),
//         body: {'booking_id': id},
//       );
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Booking Accepted')),
//       );
//
//       viewBookings();
//     } catch (e) {
//       print("Error accepting booking: $e");
//     }
//   }
//
//   // Reject booking
//   Future<void> rejectBooking(String id) async {
//     if (id == '') return;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? '';
//
//     try {
//       await http.post(
//         Uri.parse('$url/guide_reject_booking/'),
//         body: {'booking_id': id},
//       );
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Booking Rejected')),
//       );
//
//       viewBookings();
//     } catch (e) {
//       print("Error rejecting booking: $e");
//     }
//   }
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
//         body: bookings.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : ListView.builder(
//           itemCount: bookings.length,
//           itemBuilder: (context, index) {
//             final booking = bookings[index];
//
//             return Card(
//               margin: const EdgeInsets.all(10),
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       booking['package'],
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     const SizedBox(height: 5),
//                     Text("Customer: ${booking['user']}"),
//                     Text("Phone Number: ${booking['phone']}"),
//                     Text("Booked Date: ${booking['booked_date']}"),
//                     Text("From Date: ${booking['from_date']}"),
//                     Text("Status: ${booking['status']}"),
//                     const SizedBox(height: 10),
//
//                     booking['status'].toLowerCase() == "pending"
//                         ? Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: booking['id'] == ''
//                                 ? null
//                                 : () => acceptBooking(
//                                 booking['id']),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                             ),
//                             child: const Text("Accept"),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: booking['id'] == ''
//                                 ? null
//                                 : () => rejectBooking(
//                                 booking['id']),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                             ),
//                             child: const Text("Reject"),
//                           ),
//                         ),
//                       ],
//                     )
//                         : const SizedBox(),
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
  runApp(const GuideViewBookings());
}

class GuideViewBookings extends StatelessWidget {
  const GuideViewBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GuideViewBookingsPage(title: 'View Bookings'),
    );
  }
}

class GuideViewBookingsPage extends StatefulWidget {
  const GuideViewBookingsPage({super.key, required this.title});
  final String title;

  @override
  State<GuideViewBookingsPage> createState() =>
      GuideViewBookingsPageState();
}

class GuideViewBookingsPageState
    extends State<GuideViewBookingsPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> bookings = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    viewBookings();
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

  // Fetch bookings from backend
  Future<void> viewBookings() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String lid = sh.getString('lid')?.toString() ?? '';

      var response = await http.post(
        Uri.parse('$urls/guide_view_bookings/'),
        body: {'lid': lid},
      );

      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, dynamic>> tempList = [];

        for (var item in jsonData['data']) {
          tempList.add({
            'id': item['id']?.toString() ?? '',
            'user': item['user']?.toString() ?? '',
            'phone': item['phone']?.toString() ?? '',
            'package': item['package']?.toString() ?? '',
            'booked_date': item['booked_date']?.toString() ?? '',
            'from_date': item['from_date']?.toString() ?? '',
            'status': item['status']?.toString() ?? 'pending',
          });
        }

        setState(() {
          bookings = tempList;
        });
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    }
  }

  Future<void> acceptBooking(String id) async {
    if (id == '') return;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';

    try {
      await http.post(
        Uri.parse('$url/guide_accept_booking/'),
        body: {'booking_id': id},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade400),
              const SizedBox(width: 12),
              const Text('Booking Accepted Successfully'),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      viewBookings();
    } catch (e) {
      print("Error accepting booking: $e");
    }
  }

  // Reject booking
  Future<void> rejectBooking(String id) async {
    if (id == '') return;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';

    try {
      await http.post(
        Uri.parse('$url/guide_reject_booking/'),
        body: {'booking_id': id},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.cancel, color: Colors.red.shade400),
              const SizedBox(width: 12),
              const Text('Booking Rejected'),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      viewBookings();
    } catch (e) {
      print("Error rejecting booking: $e");
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
        body: bookings.isEmpty
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
                  Icons.book_online_outlined,
                  size: 60,
                  color: Colors.green.shade300,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No Bookings Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You don\'t have any package bookings yet',
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
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final isPending = booking['status'].toLowerCase() == "pending";

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
                        // Header with Package Icon and Status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.card_travel,
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
                                    booking['package'],
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
                                      color: _getStatusColor(booking['status']).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getStatusIcon(booking['status']),
                                          size: 14,
                                          color: _getStatusColor(booking['status']),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          booking['status'].toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: _getStatusColor(booking['status']),
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

                        // Customer Information Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                icon: Icons.person_outline,
                                label: 'Customer',
                                value: booking['user'],
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.phone_outlined,
                                label: 'Phone',
                                value: booking['phone'],
                                isPhone: true,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.calendar_today_outlined,
                                label: 'Booked Date',
                                value: booking['booked_date'],
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.event_outlined,
                                label: 'From Date',
                                value: booking['from_date'],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Action Buttons - Only show when status is pending
                        if (isPending)
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
                                    onPressed: booking['id'] == ''
                                        ? null
                                        : () => _showConfirmationDialog(
                                      context,
                                      'Accept Booking',
                                      'Are you sure you want to accept this booking?',
                                          () => acceptBooking(booking['id']),
                                      Colors.green,
                                    ),
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
                                    onPressed: booking['id'] == ''
                                        ? null
                                        : () => _showConfirmationDialog(
                                      context,
                                      'Reject Booking',
                                      'Are you sure you want to reject this booking?',
                                          () => rejectBooking(booking['id']),
                                      Colors.red,
                                    ),
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
                        // Show status message for non-pending bookings
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _getStatusColor(booking['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getStatusIcon(booking['status']),
                                  color: _getStatusColor(booking['status']),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Booking ${booking['status'].toLowerCase()}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(booking['status']),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isPhone = false,
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
              if (isPhone)
                Row(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (value.length == 10 && (value.startsWith('6') || value.startsWith('7') || value.startsWith('8') || value.startsWith('9')))
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
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
                              size: 12,
                              color: Colors.green.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 10,
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
                    fontSize: 15,
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
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
      case 'pending':
        return Icons.pending_outlined;
      case 'accepted':
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
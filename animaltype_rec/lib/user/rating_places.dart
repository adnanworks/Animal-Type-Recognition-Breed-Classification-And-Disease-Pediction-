// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class RatingPlacePage extends StatefulWidget {
//   const RatingPlacePage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<RatingPlacePage> createState() => RatingPlacePageState();
// }
//
// class RatingPlacePageState extends State<RatingPlacePage> {
//   TextEditingController reviewController = TextEditingController();
//   double rating_ = 0; // default no rating selected
//
//   RatingPlacePageState();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//
//             const Text(
//               "Give Rating",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//
//             const SizedBox(height: 15),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(5, (index) {
//                 return IconButton(
//                   onPressed: () {
//                     setState(() {
//                       rating_ = index + 1.0;
//                     });
//                   },
//                   icon: Icon(
//                     Icons.star,
//                     size: 35,
//                     color: index < rating_ ? Colors.amber : Colors.grey,
//                   ),
//                 );
//               }),
//             ),
//
//             Text(
//               rating_ == 0 ? "Select Rating" : "Rating: ${rating_.toInt()}",
//               style: const TextStyle(fontSize: 16),
//             ),
//
//             const SizedBox(height: 20),
//
//             TextField(
//               controller: reviewController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: "Write Review",
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             /// SUBMIT BUTTON
//             ElevatedButton(
//               onPressed: () {
//                 sendRating();
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//               child: const Text("Submit"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void sendRating() async {
//     if (rating_ == 0) {
//       Fluttertoast.showToast(msg: "Please select rating");
//       return;
//     }
//
//     if (reviewController.text.isEmpty) {
//       Fluttertoast.showToast(msg: "Please enter review");
//       return;
//     }
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//     String lid = sh.getString('lid').toString();
//     String place_id = sh.getString('place_id').toString();
//
//     final urls = Uri.parse('$url/user_add_rating/');
//
//     try {
//       final response = await http.post(urls, body: {
//         'lid': lid,
//         'place_id': place_id,
//         'rating': rating_.toInt().toString(),
//         'review': reviewController.text,
//       });
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//
//         if (data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: "Rating Submitted Successfully");
//           Navigator.pop(context);
//         } else {
//           Fluttertoast.showToast(msg: "Failed to submit rating");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Network Error");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RatingPlacePage extends StatefulWidget {
  const RatingPlacePage({super.key, required this.title});
  final String title;

  @override
  State<RatingPlacePage> createState() => RatingPlacePageState();
}

class RatingPlacePageState extends State<RatingPlacePage> with SingleTickerProviderStateMixin {
  TextEditingController reviewController = TextEditingController();
  double rating_ = 0; // default no rating selected

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  RatingPlacePageState();

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
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.green.shade600,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              "Submitting your review...",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
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
                        Icons.star_rate_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                const Text(
                  'Rate Your Experience',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1E1E),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Share your feedback about this wildlife place',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Rating Card
                Container(
                  padding: const EdgeInsets.all(24),
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
                      const Text(
                        "How was your visit?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Star Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                rating_ = index + 1.0;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.all(
                                      index < rating_ ? 4 : 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: index < rating_
                                          ? Colors.amber.withOpacity(0.2)
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      index < rating_
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      size: 45,
                                      color: index < rating_
                                          ? Colors.amber
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  if (index < rating_)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.amber.shade700,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 16),

                      // Rating Label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: rating_ == 0
                              ? Colors.grey.shade200
                              : Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          rating_ == 0
                              ? "Tap a star to rate"
                              : _getRatingLabel(rating_.toInt()),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: rating_ == 0
                                ? Colors.grey.shade600
                                : Colors.amber.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Review Input Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Write Your Review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Review Text Field
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
                          controller: reviewController,
                          maxLines: 5,
                          minLines: 3,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Share your experience... What did you like? Any suggestions?',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),

                      // Character count
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 4),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${reviewController.text.length} characters',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

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
                    onPressed: rating_ == 0 || reviewController.text.isEmpty || _isLoading
                        ? null
                        : sendRating,
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
                          'Submit Review',
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

                // Thank You Message
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
                        Icons.favorite_outline_rounded,
                        size: 20,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thank you for your feedback!',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Your review helps other wildlife enthusiasts',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Version Text
                Center(
                  child: Text(
                    'Rating System v1.0.0',
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
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return "Poor • Needs Improvement";
      case 2:
        return "Fair • Average Experience";
      case 3:
        return "Good • Satisfactory";
      case 4:
        return "Very Good • Enjoyed It";
      case 5:
        return "Excellent • Loved It!";
      default:
        return "Select Rating";
    }
  }

  void sendRating() async {
    if (rating_ == 0) {
      Fluttertoast.showToast(
        msg: "Please select a rating",
        backgroundColor: Colors.orange.shade600,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (reviewController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please write a review",
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
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String place_id = sh.getString('place_id').toString();

    final urls = Uri.parse('$url/user_add_rating/');

    try {
      final response = await http.post(urls, body: {
        'lid': lid,
        'place_id': place_id,
        'rating': rating_.toInt().toString(),
        'review': reviewController.text,
      });

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
            msg: "Rating Submitted Successfully",
            backgroundColor: Colors.green.shade600,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
            msg: "Failed to submit rating",
            backgroundColor: Colors.red.shade600,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Network Error",
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
  }
}

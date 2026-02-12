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

class RatingPlacePageState extends State<RatingPlacePage> {
  TextEditingController reviewController = TextEditingController();
  double rating_ = 0; // default no rating selected

  RatingPlacePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              "Give Rating",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      rating_ = index + 1.0;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    size: 35,
                    color: index < rating_ ? Colors.amber : Colors.grey,
                  ),
                );
              }),
            ),

            Text(
              rating_ == 0 ? "Select Rating" : "Rating: ${rating_.toInt()}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: reviewController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Write Review",
              ),
            ),

            const SizedBox(height: 25),

            /// SUBMIT BUTTON
            ElevatedButton(
              onPressed: () {
                sendRating();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  void sendRating() async {
    if (rating_ == 0) {
      Fluttertoast.showToast(msg: "Please select rating");
      return;
    }

    if (reviewController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter review");
      return;
    }

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

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: "Rating Submitted Successfully");
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: "Failed to submit rating");
        }
      } else {
        Fluttertoast.showToast(msg: "Network Error");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

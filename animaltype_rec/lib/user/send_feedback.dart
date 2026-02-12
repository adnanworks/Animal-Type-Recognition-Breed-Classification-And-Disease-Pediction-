import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController feedbackController = TextEditingController();

  Future<void> submitFeedback() async {
    if (feedbackController.text.isEmpty) return;

    SharedPreferences pref = await SharedPreferences.getInstance();
    String urls = pref.getString('url') ?? "";

    String? lid = pref.getString('lid');


    var response = await http.post(
      Uri.parse('$urls/user_addFeedback/'),
      body: {

        'lid': lid ?? '',
        'feedback': feedbackController.text,
      },
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      if (res['status'] == 'ok') {
        feedbackController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback")),
      body: Column(
        children: [
          TextField(
            controller: feedbackController,
            decoration: const InputDecoration(
              hintText: "Write your feedback...",
            ),
            maxLines: 3,
          ),
          ElevatedButton(
            onPressed: submitFeedback,
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
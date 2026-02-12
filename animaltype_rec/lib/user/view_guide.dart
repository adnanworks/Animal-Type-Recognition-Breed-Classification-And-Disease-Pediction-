import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewGuidePage extends StatefulWidget {
  const ViewGuidePage({super.key, required this.title});
  final String title;

  @override
  State<ViewGuidePage> createState() => ViewGuidePageState();
}

class ViewGuidePageState extends State<ViewGuidePage> {

  String name_ = "";
  String email_ = "";
  String phone_ = "";
  String photo_ = "";
  String img_url_ = "";

  ViewGuidePageState(){
    viewGuide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (photo_.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Image.network(
                    _buildImageUrl(),
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        width: 150,
                        height: 150,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.account_circle, size: 150),
                  ),
                ),
              )
            else
              const Center(
                child: Icon(Icons.account_circle, size: 150),
              ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(5),
              child: Text('Name: $name_'),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text('Email: $email_'),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text('Phone: $phone_'),
            ),


          ],
        ),
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

  void viewGuide() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url').toString();
      String guide_id = sh.getString('guide_id').toString();
      String img_url = sh.getString('img_url') ?? '';

      setState(() {
        img_url_ = img_url;
      });

      final urls = Uri.parse('$url/user_view_guide/');

      final response = await http.post(urls, body: {
        'guide_id': guide_id,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          setState(() {
            name_ = data['data']['name'];
            email_ = data['data']['email'];
            phone_ = data['data']['phone'];
            photo_ = data['data']['photo'];
          });
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

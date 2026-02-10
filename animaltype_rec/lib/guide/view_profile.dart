import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const GuideViewProfile());
}

class GuideViewProfile extends StatelessWidget {
  const GuideViewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GuideViewProfilePage(title: 'View Profile'),
    );
  }
}

class GuideViewProfilePage extends StatefulWidget {
  const GuideViewProfilePage({super.key, required this.title});
  final String title;

  @override
  State<GuideViewProfilePage> createState() => GuideViewProfilePageState();
}

class GuideViewProfilePageState extends State<GuideViewProfilePage> {
  GuideViewProfilePageState() {
    _send_data();
  }

  String name_ = "";
  String email_ = "";
  String place_ = "";
  String agent_ = "";
  String phone_ = "";
  String photo_ = "";
  String img_url_ = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   leading: const BackButton(),
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   title: Text(widget.title),
        // ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

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
                child: Text('Place: $place_'),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(' Agent: $agent_'),
              ),


              Padding(
                padding: const EdgeInsets.all(5),
                child: Text('Phone: $phone_'),
              ),

              const SizedBox(height: 20),
              Center(
                // child: ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const cstd_profile_editPage(),
                //       ),
                //     );
                //   },
                //   child: const Text("Edit Profile"),
                // ),
              ),
            ],
          ),
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

  void _send_data() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String img_url = sh.getString('img_url') ?? '';

    setState(() {
      img_url_ = img_url;
    });

    final urls = Uri.parse('$url/guide_viewprofile/');
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
            agent_ = data['agent'].toString();
            phone_ = data['phone'];
            photo_ = data['photo'];
          });
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}


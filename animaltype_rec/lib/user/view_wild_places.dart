import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

void main() {
  runApp(const ViewPlaces());
}

class ViewPlaces extends StatelessWidget {
  const ViewPlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ViewPlacesPage(title: 'View Experts'),
    );
  }
}

class ViewPlacesPage extends StatefulWidget {
  const ViewPlacesPage({super.key, required this.title});
  final String title;

  @override
  State<ViewPlacesPage> createState() => ViewPlacesPageState();
}

class ViewPlacesPageState extends State<ViewPlacesPage> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    viewUsers();
  }

  Future<void> viewUsers() async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';

      String apiUrl = '$urls/user_viewplaces/';
      var response = await http.post(Uri.parse(apiUrl), body: {});
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, dynamic>> tempList = [];
        for (var item in jsonData['data']) {
          tempList.add({
            'id': item['id'].toString(),
            'placename': item['placename'].toString(),
            'description': item['description'].toString(),
            'location': item['location'].toString(),
            'type': item['type'].toString(),
            'longitude': item['longitude'].toString(),
            'latitute': item['latitute'].toString(),
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
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: users.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: const EdgeInsets.all(10),
              elevation: 5,
              child: ListTile(
                title: Text(
                  user['placename'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("location: ${user['location']}"),
                    Text("description: ${user['description']}"),
                    Text("latitute: ${user['latitute']}"),

                    Text("longitude: ${user['longitude']}"),
                    Text("Type: ${user['type']}"),
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences sh = await SharedPreferences.getInstance();
                        sh.setString('place_id',user['id']);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => askdoubtPage()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Book'),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences sh = await SharedPreferences.getInstance();
                        sh.setString('expert_id',user['id']);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Chatpage(title: '')),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Chat'),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences sh = await SharedPreferences.getInstance();
                        sh.setString('expert_id',user['id']);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => addReviewPage(title: '')),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Rate the expert'),
                    ),
                    SizedBox(height: 10,),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
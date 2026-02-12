import 'dart:convert';
import 'package:animaltype_rec/user/view_guide.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'book_package.dart';
import 'home.dart';

void main() {
  runApp(const ViewPackages());
}

class ViewPackages extends StatelessWidget {
  const ViewPackages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ViewPackagesPage(title: 'View Experts'),
    );
  }
}

class ViewPackagesPage extends StatefulWidget {
  const ViewPackagesPage({super.key, required this.title});
  final String title;

  @override
  State<ViewPackagesPage> createState() => ViewPackagesPageState();
}

class ViewPackagesPageState extends State<ViewPackagesPage> {
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
      String place_id = sh.getString('place_id') ?? '';

      String apiUrl = '$urls/user_viewpackages/';
      var response = await http.post(Uri.parse(apiUrl), body: { 'place_id':place_id,});
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, dynamic>> tempList = [];
        for (var item in jsonData['data']) {
          tempList.add({
            'id': item['id'].toString(),
            'title': item['title'].toString(),
            'description': item['description'].toString(),
            'price': item['price'].toString(),
            'days': item['days'].toString(),
            'agent': item['agent'].toString(),
            'guide_id': item['guide_id']?.toString(),
            'guide_name': item['guide_name'].toString(),
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
                  user['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("price: ${user['price']}"),
                    Text("description: ${user['description']}"),
                    Text("days: ${user['days']}"),

                    Text("agent: ${user['agent']}"),
                    if (user['guide_id'] != null && user['guide_id'] != 'null')
                      ElevatedButton(
                        onPressed: () async {
                          SharedPreferences sh = await SharedPreferences.getInstance();
                          sh.setString('guide_id', user['guide_id']);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewGuidePage(title: 'Guide Details'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('View Guide'),
                      ),

                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences sh = await SharedPreferences.getInstance();
                        sh.setString('package_id',user['id']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BookPackagePage(title: '',)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Book'),
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
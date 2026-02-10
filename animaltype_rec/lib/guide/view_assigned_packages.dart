
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

class ViewExamPageState extends State<ViewAssignedPackagePage> {
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
      String lid = sh.getString('lid').toString();


      String apiUrl = '$urls/guide_view_assipackages/';
      var response = await http.post(Uri.parse(apiUrl), body: {'lid': lid,});
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
          const SnackBar(content: Text('Package accepted')),
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
          const SnackBar(content: Text('Package Rejected')),
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
                  user['package'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description: ${user['description']}"),
                    Text("Assigned Date: ${user['date']}"),
                    Text("Days: ${user['days']}"),
                    Text("Price: ${user['price']}"),
                    Text("Status: ${user['STATUS']}"),

                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              acceptPackage(user['id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size.fromHeight(45),
                            ),
                            child: const Text('Accept'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              rejectPackage(user['id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size.fromHeight(45),
                            ),
                            child: const Text('Reject'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

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

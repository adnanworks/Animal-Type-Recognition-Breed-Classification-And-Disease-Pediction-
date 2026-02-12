import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

void main() {
  runApp(const Viewcomplaints());
}

class Viewcomplaints extends StatelessWidget {
  const Viewcomplaints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ViewcomplaintsPage(title: 'View Complaint'),
    );
  }
}

class ViewcomplaintsPage extends StatefulWidget {
  const ViewcomplaintsPage({super.key, required this.title});
  final String title;

  @override
  State<ViewcomplaintsPage> createState() => cstd_viewComplaintsPageState();
}

class cstd_viewComplaintsPageState extends State<ViewcomplaintsPage> {
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
      String lid = sh.getString('lid') ?? '';

      String apiUrl = '$urls/user_viewcomplaint/';
      var response = await http.post(Uri.parse(apiUrl), body: {
        'lid':lid
      });
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, dynamic>> tempList = [];
        for (var item in jsonData['data']) {
          tempList.add({
            'id': item['id'].toString(),
            'replay': item['replay'].toString(),
            'complaint': item['complaint'].toString(),
            'date': item['date'].toString(),


          });
        }
        setState(() {
          users = tempList;
        });
      }
    } catch (e) {
      print("Error fetching Complaints: $e");
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
                title: Text("Complaint: ${
                    user['complaint']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date : ${user['date']}"),
                    Text("Reply : ${user['replay']}"),



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

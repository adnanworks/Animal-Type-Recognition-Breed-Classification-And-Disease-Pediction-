import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SpeciesPredictionPageApp());
}

class SpeciesPredictionPageApp extends StatelessWidget {
  const SpeciesPredictionPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpeciesPredictionPage(title: 'Species Prediction'),
    );
  }
}

class SpeciesPredictionPage extends StatefulWidget {
  const SpeciesPredictionPage({super.key, required this.title});
  final String title;

  @override
  State<SpeciesPredictionPage> createState() => _SpeciesPredictionPageState();
}

class _SpeciesPredictionPageState extends State<SpeciesPredictionPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _predictionResult = '';
  List<Map<String, dynamic>> _top3 = [];

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _predictionResult = '';
        _top3 = [];
      });
    }
  }

  // Capture image from camera
  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _predictionResult = '';
        _top3 = [];
      });
    }
  }

  // Upload image to species_prediction URL using SharedPreferences for base URL
  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      Fluttertoast.showToast(msg: 'Please select an image first');
      return;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String baseUrl = pref.getString('url') ?? '';
    if (baseUrl.isEmpty) {
      Fluttertoast.showToast(msg: 'Server URL not configured');
      return;
    }

    String url = '$baseUrl/species_prediction/';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var respStr = await response.stream.bytesToString();
        var jsonData = json.decode(respStr);

        setState(() {
          _predictionResult = jsonData['prediction'] ?? '';
          _top3 = [];
          if (jsonData['top3'] != null) {
            for (var item in jsonData['top3']) {
              _top3.add({
                'label': item[0].toString(),
                'confidence': item[1].toStringAsFixed(2) + '%'
              });
            }
          }
        });

        Fluttertoast.showToast(msg: 'Prediction completed');
      } else {
        Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FF),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            _imageFile != null
                ? Image.file(
              _imageFile!,
              height: 250,
            )
                : const Icon(
              Icons.image,
              size: 200,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _captureImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _uploadImage,
                child: const Text('Predict Species'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),

            _predictionResult.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Prediction: $_predictionResult',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _top3.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Predictions:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    ..._top3.map((item) => Text(
                        '${item['label']} - ${item['confidence']}')),
                  ],
                )
                    : const SizedBox(),
              ],
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const DogDiseaseApp());
}

class DogDiseaseApp extends StatelessWidget {
  const DogDiseaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PredictDogDiseasePage(title: 'Dog Disease Predictor'),
    );
  }
}

class PredictDogDiseasePage extends StatefulWidget {
  const PredictDogDiseasePage({super.key, required this.title});
  final String title;

  @override
  State<PredictDogDiseasePage> createState() => _PredictDogDiseasePageState();
}

class _PredictDogDiseasePageState extends State<PredictDogDiseasePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _predictionResult = '';
  String _confidence = '';
  bool isLoading = false;

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _predictionResult = '';
        _confidence = '';
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
        _confidence = '';
      });
    }
  }

  // Upload image to predict dog disease using SharedPreferences IP
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

    String url = '$baseUrl/predict_dog_disease/';

    setState(() {
      isLoading = true;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));

      var response = await request.send();
      var respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonData = json.decode(respStr);
        setState(() {
          _predictionResult = jsonData['result'] ?? '';
          _confidence = jsonData['confidence'] != null
              ? double.parse(jsonData['confidence'].toString()).toStringAsFixed(2) + '%'
              : '';
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Prediction completed');
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Color getConfidenceColor(String conf) {
    double val = double.tryParse(conf.replaceAll('%', '')) ?? 0;
    if (val >= 80) return Colors.green;
    if (val >= 50) return Colors.orange;
    return Colors.red;
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
              Icons.pets,
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
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text('Predict Disease'),
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
                  'Predicted Disease: $_predictionResult',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _confidence.isNotEmpty
                    ? Text(
                  'Confidence: $_confidence',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: getConfidenceColor(_confidence),
                  ),
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
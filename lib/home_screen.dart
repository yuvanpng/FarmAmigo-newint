import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  File? _image;
  String _predictionResult = "No prediction yet"; // To store prediction result
  final picker = ImagePicker();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  /// Function to pick an image from the gallery
  Future<void> getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _predictionResult = "No prediction yet"; // Reset prediction
        _controller.reset(); // Reset animation
      } else {
        print("No image picked");
      }
    });
  }

  /// Function to pick an image from the camera
  Future<void> getImageCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _predictionResult = "No prediction yet"; // Reset prediction
        _controller.reset(); // Reset animation
      } else {
        print("No image captured");
      }
    });
  }

  /// Function to simulate prediction (replace this with model logic)
  Future<void> predictDisease() async {
    if (_image == null) {
      setState(() {
        _predictionResult = "Please select or capture an image first!";
      });
      return;
    }

    // Simulate processing (replace this with TFLite model inference)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _predictionResult =
          "Predicted Disease: Leaf Blight"; // Example prediction
    });
    _controller.forward(); // Trigger animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the custom colors
    const primaryColor = Color(0xFF1CA349);
    const accentColor = Colors.amber;
    const backgroundColor = Colors.white;
    const borderColor = Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image Picker Example",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: getImageGallery,
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 50,
                            color: Color(0xFF1CA349),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: getImageCamera,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Camera",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                InkWell(
                  onTap: predictDisease,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1CA349),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Predict",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  _predictionResult,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

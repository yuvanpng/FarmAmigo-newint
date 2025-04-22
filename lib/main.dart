import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:impciker/LoginMobile.dart';
import 'package:impciker/firebase_options.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Interpreter interpreter;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print("Model loaded successfully");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Image Picker",
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: LoginMobile(), // Updated to point to LoginMobile`
    );
  }
}

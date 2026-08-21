import 'package:flutter/material.dart';
//import 'package:project_v1/AddReport.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_v1/View/LogIn.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'NotoSansArabic'),
      debugShowCheckedModeBanner: false,
      home: const LogIn(),
    );
  }
}

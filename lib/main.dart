import 'package:flutter/material.dart';
import 'package:project_v1/AddReport.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'NotoSansArabic'),
      debugShowCheckedModeBanner: false,
      home: const Addreport(),
    );
  }
}

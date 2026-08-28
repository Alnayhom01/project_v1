import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_v1/Routes/app_pages.dart';
import 'package:project_v1/Routes/app_routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSansArabic',

        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Color(0x6632B94B),
          selectionHandleColor: Color(0xff32B94B),
        ),
      ),
      initialRoute: isLoggedIn ? AppRoutes.addReport : AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}

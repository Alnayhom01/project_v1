import 'package:flutter/material.dart';

class Alerts extends StatelessWidget {
  const Alerts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF4FC),

      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              // عنوان الصفحة
              const Padding(
                padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                child: Text(
                  'تنبيهات البلدية',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              // محتوى التنبيهات لاحقًا
              const Expanded(
                child: Center(
                  child: Text(
                    'لا توجد تنبيهات حاليًا',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

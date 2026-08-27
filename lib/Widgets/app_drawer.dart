import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_v1/Routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 330,
      backgroundColor: Colors.transparent,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xD94A5052),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              bottomLeft: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: Get.back,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0x556B7072),
                        fixedSize: const Size(48, 48),
                      ),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  _item(
                    Icons.home_outlined,
                    'الرئيسية',
                    () => Get.offAllNamed(AppRoutes.addReport),
                  ),

                  const SizedBox(height: 24),

                  _item(
                    Icons.mail_outline,
                    'بلاغاتي المرسلة',
                    () => Get.offNamed(AppRoutes.myReport),
                  ),

                  const SizedBox(height: 24),

                  _item(
                    Icons.edit_outlined,
                    'تعديل بلاغ',
                    () => Get.offNamed(AppRoutes.editReport),
                  ),
                  const SizedBox(height: 24),

                  _item(
                    Icons.notifications_outlined,
                    'تنبيهات البلدية',
                    () => Get.offNamed(AppRoutes.alerts),
                  ),

                  const SizedBox(height: 24),

                  _item(Icons.logout, 'تسجيل الخروج', () async {
                    final prefs = await SharedPreferences.getInstance();

                    await prefs.remove('isLoggedIn');
                    await prefs.remove('userPhone');

                    Get.offAllNamed(AppRoutes.login);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

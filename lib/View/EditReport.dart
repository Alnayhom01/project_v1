import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_v1/Controller/edit_report_controller.dart';
import 'package:project_v1/Routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editreport extends StatelessWidget {
  const Editreport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF4FC),
      appBar: AppBar(backgroundColor: Color(0xff32b94b)),
      endDrawer: Directionality(
        textDirection: TextDirection.rtl,
        child: Drawer(
          width: 330,

          backgroundColor: Colors.transparent,

          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xD94A5052),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
              ),
            ),

            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 25,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // =========================
                    // زر الإغلاق
                    // =========================
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },

                        child: Container(
                          width: 50,
                          height: 50,

                          decoration: BoxDecoration(
                            color: const Color(0x556B7072),
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // عنوان القائمة
                    // =========================
                    const SizedBox(height: 32),

                    // =========================
                    // الرئيسية
                    // =========================
                    _drawerItem(
                      icon: Icons.home_outlined,
                      title: 'الرئيسية',
                      onTap: () {
                        Get.offNamed(AppRoutes.addReport);
                      },
                    ),

                    const SizedBox(height: 24),

                    // =========================
                    // بلاغاتي المرسلة
                    // =========================
                    _drawerItem(
                      icon: Icons.mail_outline,
                      title: 'بلاغاتي المرسلة',
                      onTap: () {
                        Get.back();
                      },
                    ),

                    const SizedBox(height: 24),

                    // =========================
                    // تعديل بلاغ
                    // =========================

                    // =========================
                    // تسجيل الخروج
                    // =========================
                    _drawerItem(
                      icon: Icons.logout,
                      title: 'تسجيل الخروج',

                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();

                        await prefs.remove('isLoggedIn');
                        await prefs.remove('userPhone');

                        Get.offAllNamed(AppRoutes.login);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<EditReportController>(
        builder: (controller) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'تعديل البلاغ #103#',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'حفرة طريق',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'الوقت المتاح 5 دقائق',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.add_road, size: 38),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'الوقت المتبقي للتعديل: ${controller.timeText}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'الملاحظات',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.notesController,
                  maxLines: 4,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'الموقع',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButton<String>(
                    value: controller.selectedLocation.value.isEmpty
                        ? null
                        : controller.selectedLocation.value,
                    isExpanded: true,
                    hint: const Text('اختر الموقع'),
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'الموقع الحالي',
                        child: Text('الموقع الحالي'),
                      ),
                      DropdownMenuItem(value: 'طرابلس', child: Text('طرابلس')),
                      DropdownMenuItem(value: 'بنغازي', child: Text('بنغازي')),
                      DropdownMenuItem(value: 'مصراتة', child: Text('مصراتة')),
                    ],
                    onChanged: (value) {
                      controller.setLocation(value);
                    },
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff32b34a),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      'تعديل البلاغ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'إلغاء',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _drawerItem({
  required IconData icon,
  required String title,
  String? subtitle,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,

    borderRadius: BorderRadius.circular(10),

    child: Row(
      children: [
        // الأيقونة
        Icon(icon, color: Colors.white, size: 31),

        const SizedBox(width: 18),

        // النص
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                textAlign: TextAlign.right,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 2),

                Text(
                  subtitle,
                  textAlign: TextAlign.right,

                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

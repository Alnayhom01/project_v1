import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:project_v1/Controller/add_report_controller.dart';
import 'package:project_v1/Routes/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_v1/Routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Addreport extends StatelessWidget {
  const Addreport({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddReportController>();
    return GetBuilder<AddReportController>(
      builder: (_) => Scaffold(
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
                      _drawerItem(
                        icon: Icons.mail_outline,
                        title: 'بلاغاتي المرسلة',
                        onTap: () {
                          Get.toNamed(AppRoutes.myReport);
                        },
                      ),

                      const SizedBox(height: 24),

                      // =========================
                      // تعديل بلاغ
                      // =========================
                      _drawerItem(
                        icon: Icons.edit_outlined,
                        title: 'تعديل بلاغ',

                        onTap: () {
                          Get.toNamed(AppRoutes.editReport);
                        },
                      ),

                      const SizedBox(height: 24),

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
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // =========================
                  // العنوان
                  // =========================
                  const Text(
                    'إضافة بلاغ جديدة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // =========================
                  // نوع البلاغ
                  // =========================
                  const Text(
                    'نوع البلاغ',
                    textAlign: TextAlign.right,

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 7),

                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xffaaaaaa),
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        alignment: AlignmentGeometry.centerRight,
                        value: controller.selectedReportType,
                        hint: Text(
                          'اختر نوع المشكلة',
                          style: TextStyle(fontSize: 25),
                        ),

                        items: const [
                          DropdownMenuItem(
                            alignment: AlignmentGeometry.centerRight,
                            value: 'حفرة في الطريق',
                            child: Text(
                              'حفرة في الطريق',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),

                          DropdownMenuItem(
                            alignment: AlignmentGeometry.centerRight,
                            value: 'مشاكل كهربائية',
                            child: Text(
                              'مشاكل كهربائية',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),

                          DropdownMenuItem(
                            alignment: AlignmentGeometry.centerRight,
                            value: 'مشاكل متعلقة بالنظافة',
                            child: Text(
                              'مشاكل متعلقة بالنظافة',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],

                        onChanged: (value) {
                          controller.setReportType(value);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // الموقع
                  // =========================
                  const Text(
                    'اختر الموقع / الموقع الحالي',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 7),

                  // الخريطة
                  ElevatedButton.icon(
                    onPressed: () async {
                      final location = await Get.toNamed(AppRoutes.location);

                      if (location != null) {
                        controller.setLocation(location as dynamic);
                      }
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text(
                      'اختيار الموقع',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  SizedBox(height: 20),

                  if (controller.selectedLocation != null)
                    Text(
                      "تم اختيار الموقع ✅",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),

                  const SizedBox(height: 30),

                  // =========================
                  // الملاحظات
                  // =========================
                  const Text(
                    'الملاحظات',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 7),

                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xffaaaaaa)),
                    ),
                    child: TextField(
                      controller: controller.notesController,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'يمكنك كتابة معلومات إضافية',
                        hintStyle: TextStyle(fontSize: 17, color: Colors.black),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // إضافة صورة
                  // =========================
                  const Text(
                    'أضف صورة',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // زر اختيار صورة
                      Container(
                        width: 100,
                        height: 105,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xffb7c8cf),
                            width: 1.5,
                          ),
                        ),
                        child: InkWell(
                          onTap: () async {
                            final picker = ImagePicker();

                            final source =
                                await showModalBottomSheet<ImageSource>(
                                  context: context,
                                  builder: (context) {
                                    return SafeArea(
                                      child: Wrap(
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                              Icons.camera_alt,
                                              size: 28,
                                            ),
                                            title: const Text(
                                              'الكاميرا',
                                              style: TextStyle(fontSize: 25),
                                            ),
                                            onTap: () {
                                              Get.back(
                                                result: ImageSource.camera,
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.photo_library,
                                              size: 28,
                                            ),
                                            title: const Text(
                                              'الاستوديو',
                                              style: TextStyle(fontSize: 25),
                                            ),
                                            onTap: () {
                                              Get.back(
                                                result: ImageSource.gallery,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );

                            if (source == null) return;

                            if (source == ImageSource.camera) {
                              final image = await picker.pickImage(
                                source: ImageSource.camera,
                              );

                              if (image != null) {
                                controller.addImage(image);
                              }
                            } else {
                              final images = await picker.pickMultiImage();

                              if (images.isNotEmpty) {
                                controller.addImages(images);
                              }
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 30,
                                color: Color(0xff71858d),
                              ),

                              SizedBox(height: 5),

                              Text(
                                'أرفق صورة',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff71858d),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // زر +
                    ],
                  ),

                  const SizedBox(height: 18),

                  // =========================
                  // زر إبلاغ
                  // =========================
                  SizedBox(
                    height: 62,
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.submitReport();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff32b94b),
                        foregroundColor: Colors.white,
                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        'إبلاغ',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

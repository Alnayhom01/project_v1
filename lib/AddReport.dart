import 'package:flutter/material.dart';
import 'package:project_v1/EditReport.dart';
// ignore: unused_import
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Addreport extends StatefulWidget {
  const Addreport({super.key});

  @override
  State<Addreport> createState() => _AddreportState();
}

class _AddreportState extends State<Addreport> {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Navigator.pop(context);
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
                        Navigator.pop(context);

                        // الانتقال إلى صفحة بلاغاتي
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Editreport(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // =========================
                    // تسجيل الخروج
                    // =========================
                    _drawerItem(
                      icon: Icons.logout,
                      title: 'تسجيل الخروج',

                      onTap: () {
                        Navigator.pop(context);
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
                      value: null,
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

                      onChanged: (value) {},
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 205,
                    width: double.infinity,
                    child: Image.network(
                      'https://pngimg.com/uploads/google_maps_pin/google_maps_pin_PNG61.png',
                      fit: BoxFit.scaleDown,

                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xffd9e8ef),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.map,
                            size: 70,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

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
                  child: const TextField(
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
                        onTap: () {
                          // اختيار صورة
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
                    onPressed: () {},

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

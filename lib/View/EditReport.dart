import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_v1/Controller/edit_report_controller.dart';
import 'package:project_v1/Routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editreport extends StatelessWidget {
  const Editreport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF4FC),
      appBar: AppBar(backgroundColor: const Color(0xff32b94b)),
      endDrawer: _drawer(),
      body: GetBuilder<EditReportController>(
        builder: (c) {
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (c.reports.isEmpty) {
            return const Center(
              child: Text(
                'لا يوجد بلاغ متاح للتعديل',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'تعديل البلاغات',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _selector(c),

                    const SizedBox(height: 18),

                    _form(context, c),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _selector(EditReportController c) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'البلاغات المتاحة للتعديل',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ...List.generate(c.reports.length, (i) {
            final d = c.reports[i];
            final selected = i == c.selectedReportIndex.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => c.selectReport(i),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xffe9f9ed)
                        : const Color(0xfff7f7f7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? const Color(0xff32b94b)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.report_outlined,
                        color: selected ? const Color(0xff32b94b) : Colors.grey,
                        size: 30,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          d.type,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Text(
                        '#${d.id.substring(d.id.length > 6 ? d.id.length - 6 : 0)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _form(BuildContext context, EditReportController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // الوقت
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              const Text(
                'الوقت المتبقي للتعديل',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                c.timeText,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: c.canEdit ? const Color(0xff32b94b) : Colors.red,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // نوع البلاغ
        const Text(
          'نوع البلاغ',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xffaaaaaa)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: c.selectedReportType.value,
              items: const [
                DropdownMenuItem(
                  value: 'حفرة في الطريق',
                  child: Text('حفرة في الطريق'),
                ),
                DropdownMenuItem(
                  value: 'مشاكل كهربائية',
                  child: Text('مشاكل كهربائية'),
                ),
                DropdownMenuItem(
                  value: 'مشاكل متعلقة بالنظافة',
                  child: Text('مشاكل متعلقة بالنظافة'),
                ),
              ],
              onChanged: c.canEdit ? c.setReportType : null,
            ),
          ),
        ),

        const SizedBox(height: 22),

        // الملاحظات
        const Text(
          'الملاحظات',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: c.notesController,
          enabled: c.canEdit,
          maxLines: 4,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
          ),
        ),

        const SizedBox(height: 22),

        // الموقع
        const Text(
          'الموقع',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(13),
            onTap: c.canEdit
                ? () async {
                    final location = await Get.toNamed(AppRoutes.location);

                    if (location != null) {
                      c.setLocation(location);
                    }
                  }
                : null,
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: c.selectedLocation.value != null
                      ? const Color(0xff32b94b)
                      : const Color(0xffaaaaaa),
                  width: c.selectedLocation.value != null ? 1.3 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    c.selectedLocation.value != null
                        ? Icons.check_circle_outline_rounded
                        : Icons.location_on_outlined,
                    color: const Color(0xff32b94b),
                    size: 25,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      c.selectedLocation.value != null
                          ? 'تم تحديد موقع البلاغ'
                          : 'اختيار موقع البلاغ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: c.selectedLocation.value != null
                            ? const Color(0xff32b94b)
                            : Colors.black87,
                      ),
                    ),
                  ),
                  if (c.canEdit && c.selectedLocation.value != null)
                    IconButton(
                      onPressed: () async {
                        final location = await Get.toNamed(AppRoutes.location);

                        if (location != null) {
                          c.setLocation(location);
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 38,
                        minHeight: 38,
                      ),
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 21,
                        color: Color(0xff32b94b),
                      ),
                    )
                  else if (c.canEdit)
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Colors.black45,
                    ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 22),

        // الصور
        const Text(
          'صور البلاغ',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        _localImages(c),

        const SizedBox(height: 10),

        OutlinedButton.icon(
          onPressed: c.canEdit ? () => _pick(context, c) : null,
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: const Text('إضافة صور'),
        ),

        const SizedBox(height: 28),

        // حفظ التعديل
        SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: c.canEdit && !c.isSaving.value ? c.updateReport : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff32b34a),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: c.isSaving.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'حفظ التعديل',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
          ),
        ),

        const SizedBox(height: 10),

        // إلغاء
        SizedBox(
          height: 60,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء', style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }

  Widget _localImages(EditReportController c) {
    final d = c.current;

    if (d == null || d.images.isEmpty) {
      return const Text(
        'لا توجد صور',
        textAlign: TextAlign.right,
        style: TextStyle(color: Colors.grey),
      );
    }

    return SizedBox(
      height: 125,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: d.images.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (_, i) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(d.images[i]),
              width: 125,
              height: 125,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 125,
                  height: 125,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _pick(BuildContext context, EditReportController c) async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('الكاميرا'),
                onTap: () {
                  Get.back(result: ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('الاستوديو'),
                onTap: () {
                  Get.back(result: ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    if (source == ImageSource.camera) {
      final image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        c.addImage(image);
      }
    } else {
      final images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        c.addImages(images);
      }
    }
  }

  Drawer _drawer() {
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
                  _drawerItem(
                    icon: Icons.home_outlined,
                    title: 'الرئيسية',
                    onTap: () {
                      Get.offAllNamed(AppRoutes.addReport);
                    },
                  ),
                  const SizedBox(height: 24),
                  _drawerItem(
                    icon: Icons.mail_outline,
                    title: 'بلاغاتي المرسلة',
                    onTap: () {
                      Get.toNamed(AppRoutes.myReport);
                    },
                  ),
                  const SizedBox(height: 24),
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
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
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

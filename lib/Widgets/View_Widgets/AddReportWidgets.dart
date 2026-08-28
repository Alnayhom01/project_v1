import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_v1/Controller/add_report_controller.dart';
import 'package:project_v1/Routes/app_routes.dart';
import 'package:project_v1/Widgets/AppTextField.dart';

const Color green = Color(0xff32b94b);
const Color background = Color(0xFFDDF4FC);
const Color border = Color(0xffc4cdd1);
const Color textDark = Color(0xff1f292d);
const double radius = 14;

Widget sectionTitle(String title) {
  return Text(
    title,
    textAlign: TextAlign.right,
    style: const TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: textDark,
    ),
  );
}

Widget buildReportType(AddReportController controller) {
  return Container(
    height: 58,
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: border),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: controller.selectedReportType,
        hint: const Text(
          'اختر نوع المشكلة',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.black54,
        ),
        alignment: Alignment.centerRight,
        items: const [
          DropdownMenuItem(
            alignment: Alignment.centerRight,
            value: 'مشاكل متعلقة بالطرق',
            child: Text('مشاكل متعلقة بالطرق', style: TextStyle(fontSize: 17)),
          ),
          DropdownMenuItem(
            alignment: Alignment.centerRight,
            value: ' مشاكل متعلقة بالكهرباء',
            child: Text(
              'مشاكل متعلقة بالكهرباء',
              style: TextStyle(fontSize: 17),
            ),
          ),
          DropdownMenuItem(
            alignment: Alignment.centerRight,
            value: 'مشاكل متعلقة بالنظافة',
            child: Text(
              'مشاكل متعلقة بالنظافة',
              style: TextStyle(fontSize: 17),
            ),
          ),
          DropdownMenuItem(
            alignment: Alignment.centerRight,
            value: ' مشاكل متعلقة بالمياه',
            child: Text('مشاكل متعلقة بالمياه', style: TextStyle(fontSize: 17)),
          ),
          DropdownMenuItem(
            alignment: Alignment.centerRight,
            value: 'مشاكل متعلقة بالإنارة',
            child: Text(
              'مشاكل متعلقة بالإنارة',
              style: TextStyle(fontSize: 17),
            ),
          ),
          DropdownMenuItem(
            alignment: Alignment.centerRight,
            value: 'غيرها من المشاكل',
            child: Text('غيرها من المشاكل', style: TextStyle(fontSize: 17)),
          ),
        ],
        onChanged: controller.setReportType,
      ),
    ),
  );
}

Widget buildLocation(AddReportController controller) {
  final selected = controller.selectedLocation != null;

  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: () => _chooseLocation(controller),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: selected ? green : border,
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.check_circle_outline_rounded
                  : Icons.location_on_outlined,
              color: green,
              size: 25,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selected ? 'تم تحديد موقع البلاغ' : 'اختيار موقع البلاغ',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16,
                  color: selected ? green : Colors.black54,
                ),
              ),
            ),
            if (selected)
              IconButton(
                onPressed: () => _chooseLocation(controller),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                icon: const Icon(Icons.edit_outlined, size: 21, color: green),
                tooltip: 'تغيير الموقع',
              )
            else
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Colors.black45,
              ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _chooseLocation(AddReportController controller) async {
  final location = await Get.toNamed(AppRoutes.location);

  if (location != null) {
    controller.setLocation(location as LatLng);
  }
}

Widget buildNotes(AddReportController controller) {
  return Container(
    constraints: const BoxConstraints(minHeight: 85),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: border),
    ),
    child: AppTextField(
      controller: controller.notesController,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      maxLines: 3,
      minLines: 3,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: controller.selectedReportType == 'غيرها من المشاكل'
            ? 'يرجى تحديد نوع البلاغ بالتفصيل'
            : 'يمكنك كتابة معلومات إضافية عن البلاغ',
        hintStyle: const TextStyle(fontSize: 15, color: Colors.black45),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(14),
      ),
    ),
  );
}

Widget buildImages(BuildContext context, AddReportController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: () => _pickImages(context, controller),
          child: Container(
            height: 82,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: green,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 13),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إرفاق صور',
                        style: TextStyle(fontSize: 17, color: Colors.black54),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'التقط صورة أو اختر صورًا من الاستوديو',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
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
      if (controller.selectedImages.isNotEmpty) ...[
        const SizedBox(height: 14),
        SizedBox(
          height: 116,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemCount: controller.selectedImages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final image = controller.selectedImages[index];

              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(image.path),
                      width: 116,
                      height: 116,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: 116,
                          height: 116,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => controller.removeImage(index),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 7),
        Text(
          '${controller.selectedImages.length} صورة مرفقة',
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    ],
  );
}

Future<void> _pickImages(
  BuildContext context,
  AddReportController controller,
) async {
  final picker = ImagePicker();

  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'إضافة صورة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: const Icon(
                      Icons.camera_alt_outlined,
                      color: green,
                      size: 27,
                    ),
                    title: const Text(
                      'الكاميرا',
                      style: TextStyle(fontSize: 17),
                    ),
                    onTap: () {
                      Get.back(result: ImageSource.camera);
                    },
                  ),
                  const SizedBox(height: 4),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: const Icon(
                      Icons.photo_library_outlined,
                      color: green,
                      size: 27,
                    ),
                    title: const Text(
                      'الاستوديو',
                      style: TextStyle(fontSize: 17),
                    ),
                    onTap: () {
                      Get.back(result: ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  if (source == null) return;

  if (source == ImageSource.camera) {
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      controller.addImage(image);
    }
  } else {
    final images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      controller.addImages(images);
    }
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReportController extends GetxController {
  LatLng? selectedLocation;
  String? selectedReportType;

  final notesController = TextEditingController();
  final selectedImages = <XFile>[].obs;

  final isLoading = false.obs;

  void setReportType(String? value) {
    selectedReportType = value;
    update();
  }

  void setLocation(LatLng? value) {
    selectedLocation = value;
    update();
  }

  void addImage(XFile image) {
    selectedImages.add(image);
  }

  void addImages(List<XFile> images) {
    selectedImages.addAll(images);
  }

  Future<String> uploadImageToCloudinary(XFile image) async {
    final bytes = await image.readAsBytes();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/evoubvae/image/upload'),
    );

    request.fields['upload_preset'] = 'ProjectV1';

    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: image.name),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception(
        'Cloudinary upload failed: ${response.statusCode} $responseBody',
      );
    }

    final data = jsonDecode(responseBody);

    final imageUrl = data['secure_url'];

    if (imageUrl == null || imageUrl.toString().isEmpty) {
      throw Exception('Cloudinary did not return image URL');
    }

    return imageUrl.toString();
  }

  Future<void> submitReport() async {
    if (selectedReportType == null || selectedReportType!.trim().isEmpty) {
      Get.snackbar('تنبيه', 'يرجى اختيار نوع البلاغ');
      return;
    }

    if (selectedLocation == null) {
      Get.snackbar('تنبيه', 'يرجى اختيار موقع البلاغ');
      return;
    }

    if (selectedImages.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إرفاق صورة للبلاغ');
      return;
    }

    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString('userPhone');

      if (phone == null || phone.isEmpty) {
        Get.snackbar('خطأ', 'لم يتم العثور على بيانات المستخدم');
        return;
      }

      // رفع الصورة إلى Cloudinary
      final imageUrl = await uploadImageToCloudinary(selectedImages.first);

      // إنشاء البلاغ في Firestore
      final reportRef = FirebaseFirestore.instance.collection('reports').doc();

      await reportRef.set({
        'userPhone': phone,
        'reportType': selectedReportType,
        'description': notesController.text.trim(),
        'latitude': selectedLocation!.latitude,
        'longitude': selectedLocation!.longitude,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'جديد',
      });

      Get.snackbar('تم الإرسال', 'تم إرسال البلاغ بنجاح');

      clearReport();
    } catch (e) {
      print('REPORT ERROR: $e');

      Get.snackbar(
        'خطأ',
        'تعذر إرسال البلاغ: $e',
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearReport() {
    selectedReportType = null;
    selectedLocation = null;
    notesController.clear();
    selectedImages.clear();

    update();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}

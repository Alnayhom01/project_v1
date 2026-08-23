import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_v1/Model/report_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AddReportController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => finalizeExpiredDrafts(),
    );
  }

  LatLng? selectedLocation;
  String? selectedReportType;
  final notesController = TextEditingController();
  final selectedImages = <XFile>[].obs;
  final isLoading = false.obs;
  Timer? _timer;

  void setReportType(String? v) {
    selectedReportType = v;
    update();
  }

  void setLocation(LatLng? v) {
    selectedLocation = v;
    update();
  }

  void addImage(XFile x) {
    selectedImages.add(x);
    update();
  }

  void addImages(List<XFile> x) {
    selectedImages.addAll(x);
    update();
  }

  void removeImage(int i) {
    if (i >= 0 && i < selectedImages.length) {
      selectedImages.removeAt(i);
      update();
    }
  }

  Future<String> _copyImage(XFile image, String draftId, int index) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/pending_reports/$draftId');
    if (!await folder.exists()) await folder.create(recursive: true);
    final ext = image.name.contains('.')
        ? image.name.substring(image.name.lastIndexOf('.'))
        : '.jpg';
    final file = File('${folder.path}/image_$index$ext');
    await File(image.path).copy(file.path);
    return file.path;
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
        'Cloudinary upload failed: '
        '${response.statusCode} $responseBody',
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
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار نوع البلاغ',
        titleText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'تنبيه',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight(200)),
          ),
        ),
        messageText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'يرجى اختيار نوع البلاغ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
          ),
        ),
      );
      return;
    }
    if (selectedLocation == null) {
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار موقع البلاغ',
        titleText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'تنبيه',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight(200)),
          ),
        ),
        messageText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'يرجى اختيار موقع البلاغ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
          ),
        ),
      );
      return;
    }
    if (selectedImages.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى إرفاق صورة للبلاغ',
        titleText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'تنبيه',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight(200)),
          ),
        ),
        messageText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'يرجى إرفاق صورة للبلاغ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
          ),
        ),
      );
      return;
    }
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString('userPhone');
      if (phone == null || phone.isEmpty) {
        Get.snackbar(
          'خطأ',
          'لم يتم العثور على بيانات المستخدم',
          titleText: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'خطأ',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight(200)),
            ),
          ),
          messageText: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'لم يتم العثور على بيانات المستخدم',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
            ),
          ),
        );
        return;
      }
      final id = 'local_${DateTime.now().microsecondsSinceEpoch}';
      final now = DateTime.now();
      final paths = <String>[];
      for (var i = 0; i < selectedImages.length; i++) {
        paths.add(await _copyImage(selectedImages[i], id, i));
      }
      final draft = ReportModel(
        id: id,
        type: selectedReportType!,
        notes: notesController.text.trim(),
        latitude: selectedLocation!.latitude,
        longitude: selectedLocation!.longitude,
        images: paths,
        createdAt: now,
        expiresAt: now.add(const Duration(minutes: 15)),
      );
      final drafts = _readDrafts(prefs);
      drafts.add({'userPhone': phone, ...draft.toMap()});
      await prefs.setString('pending_reports', jsonEncode(drafts));
      Get.snackbar(
        'تم حفظ البلاغ',
        'يمكنك تعديله لمدة 15 دقيقة',
        titleText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'تم حفظ البلاغ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight(200)),
          ),
        ),
        messageText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'يمكنك تعديله لمدة 15 دقيقة',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
          ),
        ),
      );
      clearReport();
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر حفظ البلاغ',
        duration: const Duration(seconds: 5),
        titleText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'خطأ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight(200)),
          ),
        ),
        messageText: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'تعذر حفظ البلاغ: $e',
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
          ),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> _readDrafts(SharedPreferences p) {
    final raw = p.getString('pending_reports');
    if (raw == null || raw.isEmpty) return [];
    final x = jsonDecode(raw);
    return (x as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> finalizeExpiredDrafts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString('userPhone');
      if (phone == null || phone.isEmpty) return;
      final raw = prefs.getString('pending_reports');
      if (raw == null || raw.isEmpty) return;
      final all = (jsonDecode(raw) as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      final keep = <Map<String, dynamic>>[];
      for (final m in all) {
        if (m['userPhone'] != phone) {
          keep.add(m);
          continue;
        }
        final d = ReportModel.fromMap(m);
        if (d.expiresAt.isAfter(DateTime.now())) {
          keep.add(m);
          continue;
        }
        try {
          final urls = <String>[];
          for (final path in d.images) {
            final f = File(path);
            if (await f.exists())
              urls.add(await uploadImageToCloudinary(XFile(path)));
          }
          await FirebaseFirestore.instance.collection('reports').doc(d.id).set({
            'userPhone': phone,
            'reportType': d.type,
            'description': d.notes,
            'latitude': d.latitude,
            'longitude': d.longitude,
            'imageUrls': urls,
            'imageUrl': urls.isNotEmpty ? urls.first : '',
            'createdAt': Timestamp.fromDate(d.createdAt),
            'expiresAt': Timestamp.fromDate(d.expiresAt),
            'status': 'جديد',
            'finalizedAt': FieldValue.serverTimestamp(),
          });
          final dir = await getApplicationDocumentsDirectory();
          final folder = Directory('${dir.path}/pending_reports/${d.id}');
          if (await folder.exists()) await folder.delete(recursive: true);
        } catch (e) {
          keep.add(m);
          debugPrint('FINALIZE ERROR: $e');
        }
      }
      await prefs.setString('pending_reports', jsonEncode(keep));
    } catch (e) {
      debugPrint('FINALIZE DRAFTS ERROR: $e');
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
    _timer?.cancel();
    notesController.dispose();
    super.onClose();
  }
}

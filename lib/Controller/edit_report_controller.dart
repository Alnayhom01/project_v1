import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_v1/Widgets/app_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_v1/Model/report_model.dart';

class EditReportController extends GetxController {
  final reports = <ReportModel>[].obs;
  final selectedReportIndex = 0.obs;
  final selectedLocation = Rxn<LatLng>();
  final selectedReportType = RxnString();
  final notesController = TextEditingController();
  final selectedImages = <XFile>[].obs;
  final remainingSeconds = 0.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  Timer? _timer;
  ReportModel? get current =>
      reports.isEmpty ? null : reports[selectedReportIndex.value];
  bool get canEdit => remainingSeconds.value > 0 && current != null;
  String get timeText =>
      '${remainingSeconds.value ~/ 60}:${(remainingSeconds.value % 60).toString().padLeft(2, '0')}';

  @override
  void onInit() {
    super.onInit();
    loadDraftReports();
  }

  List<Map<String, dynamic>> _read(SharedPreferences p) {
    final r = p.getString('pending_reports');
    if (r == null || r.isEmpty) return [];
    final x = jsonDecode(r);
    return (x as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> _write(
    SharedPreferences p,
    List<Map<String, dynamic>> x,
  ) async => p.setString('pending_reports', jsonEncode(x));
  Future<String?> _phone() async {
    final p = await SharedPreferences.getInstance();
    return p.getString('userPhone');
  }

  Future<String> _upload(XFile image) async {
    final req = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/evoubvae/image/upload'),
    );
    req.fields['upload_preset'] = 'ProjectV1';
    req.files.add(
      http.MultipartFile.fromBytes(
        'file',
        await image.readAsBytes(),
        filename: image.name,
      ),
    );
    final res = await req.send();
    final body = await res.stream.bytesToString();
    if (res.statusCode != 200) {
      throw Exception('Cloudinary upload failed: ${res.statusCode}');
    }
    return jsonDecode(body)['secure_url'].toString();
  }

  Future<void> loadDraftReports() async {
    try {
      isLoading.value = true;
      final p = await SharedPreferences.getInstance();
      final phone = await _phone();
      if (phone == null || phone.isEmpty) return;
      final all = _read(p);
      final active = <ReportModel>[];
      final now = DateTime.now();
      for (final m in all) {
        if (m['userPhone'] != phone) {
          continue;
        }
        final d = ReportModel.fromMap(m);
        if (d.expiresAt.isAfter(now)) {
          active.add(d);
        } else {
          await _finalizeLocal(p, m);
        }
      }
      // إعادة القراءة لأن _finalizeLocal يحذف المسودات ويضيفها إلى Firestore
      final fresh = _read(p);
      final active2 = <ReportModel>[];
      for (final m in fresh) {
        if (m['userPhone'] == phone) {
          final d = ReportModel.fromMap(m);
          if (d.expiresAt.isAfter(DateTime.now())) active2.add(d);
        }
      }
      active2.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      reports.assignAll(active2);
      if (reports.isEmpty) {
        clearSelected();
      } else {
        if (selectedReportIndex.value >= reports.length) {
          selectedReportIndex.value = 0;
        }
        selectReport(selectedReportIndex.value);
      }
    } catch (e) {
      AppSnackbar.show("خطأ", "تعذر تحميل البلاغات القابلة للتعديل");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> _finalizeLocal(
    SharedPreferences p,
    Map<String, dynamic> m,
  ) async {
    try {
      final d = ReportModel.fromMap(m);
      final urls = <String>[];
      for (final path in d.images) {
        final f = File(path);
        if (await f.exists()) urls.add(await _upload(XFile(path)));
      }
      await FirebaseFirestore.instance.collection('reports').doc(d.id).set({
        'userPhone': m['userPhone'],
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
      final all = _read(p)..removeWhere((x) => x['id'] == d.id);
      await _write(p, all);
      final dir = await getApplicationDocumentsDirectory();
      final folder = Directory('${dir.path}/pending_reports/${d.id}');
      if (await folder.exists()) await folder.delete(recursive: true);
    } catch (e) {
      debugPrint('FINALIZE LOCAL ERROR: $e');
    }
  }

  void selectReport(int i) {
    if (i < 0 || i >= reports.length) return;
    _timer?.cancel();
    selectedReportIndex.value = i;
    selectedImages.clear();
    final d = reports[i];
    selectedReportType.value = d.type;
    notesController.text = d.notes;
    selectedLocation.value = LatLng(d.latitude, d.longitude);
    remainingSeconds.value = d.expiresAt
        .difference(DateTime.now())
        .inSeconds
        .clamp(0, 999999)
        .toInt();
    if (canEdit) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => updateRemainingTime(),
      );
    }
    update();
  }

  void updateRemainingTime() {
    final d = current;
    if (d == null) {
      remainingSeconds.value = 0;
      return;
    }
    final s = d.expiresAt.difference(DateTime.now()).inSeconds;
    if (s <= 0) {
      remainingSeconds.value = 0;
      _timer?.cancel();
      loadDraftReports();
      return;
    }
    remainingSeconds.value = s;
    update();
  }

  void setReportType(String? v) {
    if (canEdit) {
      selectedReportType.value = v;
      update();
    }
  }

  void setLocation(LatLng? v) {
    if (canEdit) {
      selectedLocation.value = v;
      update();
    }
  }

  void addImage(XFile x) {
    if (canEdit) {
      selectedImages.add(x);
      update();
    }
  }

  void addImages(List<XFile> x) {
    if (canEdit) {
      selectedImages.addAll(x);
      update();
    }
  }

  void removeNewImage(int i) {
    if (i >= 0 && i < selectedImages.length) {
      selectedImages.removeAt(i);
      update();
    }
  }

  Future<void> updateReport() async {
    if (!canEdit || current == null) {
      AppSnackbar.show("انتهت المهلة", "انتهت مدة تعديل هذا البلاغ");

      return;
    }
    if (selectedReportType.value == null || selectedLocation.value == null) {
      AppSnackbar.show("تنبيه", "يرجى إكمال بيانات البلاغ");
      return;
    }
    if (selectedReportType.value == 'غيرها من المشاكل' &&
        notesController.text.trim().isEmpty) {
      AppSnackbar.show('تنبيه', 'يرجى تحديد نوع البلاغ في الملاحظات');
      return;
    }

    try {
      isSaving.value = true;
      final p = await SharedPreferences.getInstance();
      final all = _read(p);
      final i = all.indexWhere((m) => m['id'] == current!.id);
      if (i < 0) return;
      final old = ReportModel.fromMap(all[i]);
      final paths = [...old.images];
      for (final x in selectedImages) {
        final dir = await getApplicationDocumentsDirectory();
        final folder = Directory('${dir.path}/pending_reports/${old.id}');
        if (!await folder.exists()) await folder.create(recursive: true);
        final dest = File(
          '${folder.path}/image_${DateTime.now().microsecondsSinceEpoch}.jpg',
        );
        await File(x.path).copy(dest.path);
        paths.add(dest.path);
      }
      final updated = ReportModel(
        id: old.id,
        type: selectedReportType.value!,
        notes: notesController.text.trim(),
        latitude: selectedLocation.value!.latitude,
        longitude: selectedLocation.value!.longitude,
        images: paths,
        createdAt: old.createdAt,
        expiresAt: old.expiresAt,
      );
      all[i] = {'userPhone': all[i]['userPhone'], ...updated.toMap()};
      await _write(p, all);
      reports[selectedReportIndex.value] = updated;
      selectedImages.clear();
      AppSnackbar.show(
        "تم التعديل",
        "تم حفظ التعديلات ويمكن تعديل البلاغ حتى انتهاء المهلة",
      );

      selectReport(selectedReportIndex.value);
    } catch (e) {
      AppSnackbar.show("خطأ", "تعذر تعديل البلاغ");
    } finally {
      isSaving.value = false;
      update();
    }
  }

  Future<void> deleteReport() async {
    if (current == null) return;

    try {
      final p = await SharedPreferences.getInstance();
      final all = _read(p);

      all.removeWhere((m) => m['id'] == current!.id);
      await _write(p, all);

      reports.removeAt(selectedReportIndex.value);

      if (reports.isEmpty) {
        clearSelected();
      } else {
        selectedReportIndex.value = 0;
        selectReport(0);
      }

      AppSnackbar.show('تم الحذف', 'تم حذف البلاغ بنجاح');
    } catch (e) {
      AppSnackbar.show('خطأ', 'تعذر حذف البلاغ');
    }
  }

  void clearSelected() {
    _timer?.cancel();
    selectedReportType.value = null;
    selectedLocation.value = null;
    notesController.clear();
    selectedImages.clear();
    remainingSeconds.value = 0;
    update();
  }

  @override
  void onClose() {
    _timer?.cancel();
    notesController.dispose();
    super.onClose();
  }
}

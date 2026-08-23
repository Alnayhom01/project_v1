import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditReportController extends GetxController {
  final selectedLocation = ''.obs;
  final notesController = TextEditingController();
  final remainingSeconds = 272.obs;

  String get timeText {
    final m = remainingSeconds.value ~/ 60;
    final s = remainingSeconds.value % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void setLocation(String? value) {
    selectedLocation.value = value ?? '';
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}

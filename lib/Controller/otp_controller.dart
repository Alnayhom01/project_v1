import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project_v1/Controller/signup_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:project_v1/Widgets/app_snackbar.dart';

class OtpController extends GetxController {
  final otpControllers = List.generate(6, (_) => TextEditingController());

  final otpFocusNodes = List.generate(6, (_) => FocusNode());

  final isLoading = false.obs;

  String get otp => otpControllers.map((e) => e.text).join();

  void onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }

    update();
  }

  Future<void> resendOtp() async {
    final signupController = Get.find<SignUpController>();
    final phone = signupController.phoneController.value.trim();

    if (phone.isEmpty) {
      AppSnackbar.show('خطأ', 'رقم الهاتف غير موجود');
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/send-otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'phone': phone},
      );

      if (response.statusCode == 200) {
        clearOtp();
        AppSnackbar.show('تم الإرسال', 'تم إرسال رمز تحقق جديد');
      } else {
        AppSnackbar.show('خطأ', 'فشل إعادة إرسال الرمز');
      }
    } catch (e) {
      AppSnackbar.show('خطأ', 'تعذر الاتصال بالخادم');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verify() async {
    if (otp.length != 6) {
      AppSnackbar.show('تنبيه', 'أدخل رمز التحقق المكون من 6 أرقام');
      return false;
    }

    final signupController = Get.find<SignUpController>();
    final phone = signupController.phoneController.value.trim();

    if (phone.isEmpty) {
      AppSnackbar.show('خطأ', 'رقم الهاتف غير موجود');
      return false;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/verify-otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'phone': phone, 'otp': otp},
      );

      if (response.statusCode == 200) {
        final signupController = Get.find<SignUpController>();

        final passwordHash = sha256
            .convert(utf8.encode(signupController.passwordController.value))
            .toString();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(signupController.phoneController.value.trim())
            .set({
              'name': signupController.nameController.value.trim(),
              'phone': signupController.phoneController.value.trim(),
              'passwordHash': passwordHash,
              'latitude': signupController.selectedLocation!.latitude,
              'longitude': signupController.selectedLocation!.longitude,
              'phoneVerified': true,
              'createdAt': FieldValue.serverTimestamp(),
            });
        AppSnackbar.show('تم التحقق', 'تم تأكيد رقم الهاتف بنجاح');
        return true;
      }

      AppSnackbar.show('رمز غير صحيح', 'رمز التحقق غير صحيح أو منتهي');
      return false;
    } catch (e) {
      AppSnackbar.show('خطأ', 'تعذر الاتصال بالخادم');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearOtp() {
    for (final controller in otpControllers) {
      controller.clear();
    }

    otpFocusNodes.first.requestFocus();
    update();
  }

  @override
  void onClose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final node in otpFocusNodes) {
      node.dispose();
    }

    super.onClose();
  }
}

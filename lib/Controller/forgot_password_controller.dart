import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project_v1/Routes/app_routes.dart';
import 'package:project_v1/Widgets/app_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final phoneController = ''.obs;
  final otpControllers = List.generate(6, (_) => TextEditingController());
  final otpFocusNodes = List.generate(6, (_) => FocusNode());

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final step = 0.obs;

  String get otp => otpControllers.map((e) => e.text).join();

  String get fullPhone {
    final local = phoneController.value.trim();
    return local.isEmpty ? '' : '218$local';
  }

  void setPhone(String value) {
    phoneController.value = value;
  }

  void onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }

    update();
  }

  Future<void> sendOtp() async {
    final phone = fullPhone;

    if (phone.isEmpty) {
      AppSnackbar.show('خطأ', 'رقم الهاتف غير موجود');
      return;
    }

    try {
      isLoading.value = true;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(phone)
          .get();

      if (!userDoc.exists) {
        AppSnackbar.show('خطأ', 'رقم الهاتف غير مسجل');
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.1.102:8080/send-otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'phone': phone},
      );

      if (response.statusCode == 200) {
        clearOtp();
        step.value = 1;

        AppSnackbar.show('تم الإرسال', 'تم إرسال رمز التحقق إلى رقم هاتفك');
        return;
      }

      AppSnackbar.show('خطأ', 'فشل إرسال رمز التحقق');
    } catch (e) {
      AppSnackbar.show('خطأ', 'تعذر الاتصال بالخادم');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    final phone = fullPhone;

    if (phone.isEmpty) {
      AppSnackbar.show('خطأ', 'رقم الهاتف غير موجود');
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('http://192.168.1.102:8080/send-otp'),
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

  Future<void> verifyOtp() async {
    if (otp.length != 6) {
      AppSnackbar.show('خطأ', 'أدخل رمز التحقق المكون من 6 أرقام');
      return;
    }

    final phone = fullPhone;

    if (phone.isEmpty) {
      AppSnackbar.show('خطأ', 'رقم الهاتف غير موجود');
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('http://192.168.1.102:8080/verify-otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'phone': phone, 'otp': otp},
      );

      if (response.statusCode == 200) {
        step.value = 2;
        return;
      }

      AppSnackbar.show('خطأ', 'رمز التحقق غير صحيح أو منتهي');
    } catch (e) {
      AppSnackbar.show('خطأ', 'تعذر الاتصال بالخادم');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      AppSnackbar.show('خطأ', 'أدخل كلمة السر الجديدة');
      return;
    }

    if (newPassword != confirmPassword) {
      AppSnackbar.show('خطأ', 'كلمتا السر غير متطابقتين');
      return;
    }

    try {
      isLoading.value = true;

      final passwordHash = sha256.convert(utf8.encode(newPassword)).toString();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(fullPhone)
          .update({'passwordHash': passwordHash});

      AppSnackbar.show('تم التغيير', 'تم تغيير كلمة السر بنجاح');

      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      AppSnackbar.show('خطأ', 'تعذر تحديث كلمة السر');
    } finally {
      isLoading.value = false;
    }
  }

  void clearOtp() {
    for (final controller in otpControllers) {
      controller.clear();
    }

    if (otpFocusNodes.isNotEmpty) {
      otpFocusNodes.first.requestFocus();
    }

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

    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}

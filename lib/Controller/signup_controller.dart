import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class SignUpController extends GetxController {
  final nameController = ''.obs;
  final phoneController = ''.obs;
  final passwordController = ''.obs;

  LatLng? selectedLocation;

  void setName(String value) {
    nameController.value = value;
  }

  void setPhone(String value) {
    phoneController.value = value;
  }

  void setPassword(String value) {
    passwordController.value = value;
  }

  void setLocation(LatLng location) {
    selectedLocation = location;
    update();
  }

  Future<bool> sendOtp() async {
    if (nameController.value.trim().isEmpty ||
        phoneController.value.trim().isEmpty ||
        passwordController.value.isEmpty ||
        selectedLocation == null) {
      Get.snackbar(
        'تنبيه',
        'أكمل جميع البيانات',
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
            'أكمل جميع البيانات',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
          ),
        ),
      );

      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/send-otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'phone': phoneController.value.trim()},
      );

      if (response.statusCode == 200) {
        return true;
      }

      Get.snackbar(
        'خطأ',
        'فشل إرسال رمز التحقق',
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
            'فشل إرسال رمز التحقق',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
          ),
        ),
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر الاتصال بالخادم',
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
            'تعذر الاتصال بالخادم',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
          ),
        ),
      );
      return false;
    }
  }
}

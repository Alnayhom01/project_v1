import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:project_v1/Widgets/app_snackbar.dart';

class SignUpController extends GetxController {
  final nameController = ''.obs;
  final phoneController = ''.obs;
  final passwordController = ''.obs;
  final isLoading = false.obs;

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
    final phone = phoneController.value.trim();

    if (nameController.value.trim().isEmpty ||
        phone.isEmpty ||
        passwordController.value.isEmpty ||
        selectedLocation == null) {
      AppSnackbar.show("تنبيه", "أكمل جميع البيانات");
      return false;
    }

    try {
      isLoading.value = true;

      final existingUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(phone)
          .get();

      if (existingUser.exists) {
        AppSnackbar.show("تنبيه", "رقم الهاتف مسجل مسبقًا");
        return false;
      }

      final fullPhone = '218$phone';

      final response = await http.post(
        Uri.parse('https://desktop-8m6hgdo.tail5b9365.ts.net/send-otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'phone': fullPhone},
      );

      if (response.statusCode == 200) {
        return true;
      }

      AppSnackbar.show("خطأ", "فشل إرسال رمز التحقق");
      return false;
    } catch (e) {
      AppSnackbar.show("خطأ", "تعذر الاتصال بالخادم");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

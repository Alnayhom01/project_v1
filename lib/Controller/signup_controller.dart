import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:project_v1/Widgets/app_snackbar.dart';

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
      AppSnackbar.show("تنبيه", "أكمل جميع البيانات");

      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/send-otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'phone': '218${phoneController.value.trim()}'},
      );

      if (response.statusCode == 200) {
        return true;
      }

      AppSnackbar.show("خطأ", "فشل إرسال رمز التحقق");

      return false;
    } catch (e) {
      AppSnackbar.show("خطأ", "تعذر الاتصال بالخادم");

      return false;
    }
  }
}

import 'package:get/get.dart';
import 'package:project_v1/Controller/otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<OtpController>(() => OtpController());
}

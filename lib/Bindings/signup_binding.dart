import 'package:get/get.dart';
import 'package:project_v1/Controller/signup_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<SignUpController>(() => SignUpController());
}

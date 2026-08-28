import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_v1/Controller/forgot_password_controller.dart';
import 'package:project_v1/Widgets/View_Widgets/ForgotPasswordWidgets.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

    return Scaffold(
      backgroundColor: const Color(0xFFDDF4FC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Obx(
            () => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 45),
              child: controller.step.value == 0
                  ? phoneStep(controller)
                  : controller.step.value == 1
                  ? otpStep(controller)
                  : passwordStep(controller),
            ),
          ),
        ),
      ),
    );
  }
}

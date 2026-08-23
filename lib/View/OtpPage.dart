import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_v1/Controller/otp_controller.dart';
import 'package:project_v1/Routes/app_routes.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpController>();
    return Scaffold(
      backgroundColor: const Color(0xFFDDF4FC),

      body: Directionality(
        textDirection: TextDirection.rtl,

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 45),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 55),

                const Text(
                  'التحقق من رقم الهاتف',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'أرسلنا رمز التحقق إلى رقم هاتفك',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Color(0xff555555)),
                ),

                const SizedBox(height: 8),

                const Text(
                  'أدخل الرمز المكون من 6 أرقام للمتابعة',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff777777)),
                ),

                const SizedBox(height: 55),

                const Text(
                  'رمز التحقق',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                // OTP من اليسار إلى اليمين
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      6,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _otpBox(index),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  'لم يصلك الرمز؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff555555)),
                ),

                const SizedBox(height: 5),

                TextButton(
                  onPressed: () async {
                    await Get.find<OtpController>().resendOtp();
                  },
                  child: const Text(
                    'إعادة إرسال الرمز',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xff279C45),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Obx(
                  () => SizedBox(
                    height: 62,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              final success = await controller.verify();

                              if (success) {
                                Get.offAllNamed(AppRoutes.addReport);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff32B94B),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xff9fd9aa),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'تحقق',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'العودة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff555555),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: Get.find<OtpController>().otpControllers[index],
        focusNode: Get.find<OtpController>().otpFocusNodes[index],

        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,

        keyboardType: TextInputType.number,
        maxLength: 1,

        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

        onChanged: (value) {
          final controller = Get.find<OtpController>();
          controller.onOtpChanged(index, value);
        },

        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xffaaaaaa)),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xffaaaaaa)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xff32B94B), width: 2),
          ),
        ),
      ),
    );
  }
}

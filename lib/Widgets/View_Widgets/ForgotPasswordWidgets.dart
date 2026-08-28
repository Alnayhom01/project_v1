import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_v1/Controller/forgot_password_controller.dart';
import 'package:project_v1/Widgets/AppTextField.dart';

Widget phoneStep(ForgotPasswordController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 45),

      const Text(
        'نسيت كلمة السر',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),

      const SizedBox(height: 12),

      const Text(
        'أدخل رقم هاتفك لاستعادة كلمة السر',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Color(0xff555555)),
      ),

      const SizedBox(height: 55),

      const Text(
        'رقم الهاتف',
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),

      const SizedBox(height: 8),

      Container(
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xffaaaaaa)),
        ),
        child: Stack(
          children: [
            AppTextField(
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              onChanged: controller.setPhone,
              decoration: const InputDecoration(
                hintText: '92×××××××',
                hintTextDirection: TextDirection.ltr,
                hintStyle: TextStyle(color: Color(0xff888888), fontSize: 17),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: 105,
                  right: 15,
                  top: 18,
                  bottom: 18,
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 0,
              bottom: 0,
              child: Row(
                children: const [
                  Icon(Icons.phone_outlined, color: Color(0xff71858d)),
                  SizedBox(width: 8),
                  Text(
                    '218',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 30),

      SizedBox(
        height: 62,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.sendOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff32B94B),
            foregroundColor: Colors.white,
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
                  'إرسال رمز التحقق',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
        ),
      ),

      const SizedBox(height: 18),

      TextButton(
        onPressed: () => Get.back(),
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
  );
}

Widget otpStep(ForgotPasswordController controller) {
  return Column(
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

      Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            6,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _otpBox(controller, index),
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
        onPressed: controller.isLoading.value ? null : controller.resendOtp,
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

      SizedBox(
        height: 62,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.verifyOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff32B94B),
            foregroundColor: Colors.white,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
        ),
      ),

      const SizedBox(height: 18),

      TextButton(
        onPressed: () {
          controller.step.value = 0;
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
  );
}

Widget _otpBox(ForgotPasswordController controller, int index) {
  return SizedBox(
    width: 45,
    height: 55,
    child: AppTextField(
      controller: controller.otpControllers[index],
      focusNode: controller.otpFocusNodes[index],
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLength: 1,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      onChanged: (value) {
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

Widget passwordStep(ForgotPasswordController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 55),

      const Text(
        'تغيير كلمة السر',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 29,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),

      const SizedBox(height: 15),

      const Text(
        'أدخل كلمة السر الجديدة لحسابك',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 17, color: Color(0xff555555)),
      ),

      const SizedBox(height: 55),

      const Text(
        'كلمة السر الجديدة',
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),

      const SizedBox(height: 8),

      Container(
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xffaaaaaa)),
        ),
        child: AppTextField(
          controller: controller.newPasswordController,
          obscureText: true,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
            hintText: 'أدخل كلمة السر الجديدة',
            hintStyle: TextStyle(color: Color(0xff888888), fontSize: 17),
            prefixIcon: Icon(Icons.lock_outline, color: Color(0xff71858d)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          ),
        ),
      ),

      const SizedBox(height: 25),

      const Text(
        'تأكيد كلمة السر',
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),

      const SizedBox(height: 8),

      Container(
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xffaaaaaa)),
        ),
        child: AppTextField(
          controller: controller.confirmPasswordController,
          obscureText: true,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
            hintText: 'أعد إدخال كلمة السر',
            hintStyle: TextStyle(color: Color(0xff888888), fontSize: 17),
            prefixIcon: Icon(Icons.lock_outline, color: Color(0xff71858d)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          ),
        ),
      ),

      const SizedBox(height: 30),

      SizedBox(
        height: 62,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.resetPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff32B94B),
            foregroundColor: Colors.white,
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
                  'حفظ كلمة السر',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
        ),
      ),

      const SizedBox(height: 18),

      TextButton(
        onPressed: () => Get.back(),
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
  );
}

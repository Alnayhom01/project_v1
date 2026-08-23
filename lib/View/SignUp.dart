import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_v1/Controller/signup_controller.dart';
import 'package:project_v1/Routes/app_routes.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpController>();

    return Scaffold(
      backgroundColor: const Color(0xFFDDF4FC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 25),

                const Text(
                  'إنشاء حساب',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'أنشئ حسابك للبدء في استخدام التطبيق',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff666666)),
                ),

                const SizedBox(height: 40),

                const Text(
                  'الاسم',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Container(
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: const Color(0xffaaaaaa)),
                  ),
                  child: TextField(
                    textAlign: TextAlign.right,
                    onChanged: controller.setName,
                    decoration: const InputDecoration(
                      hintText: 'أدخل اسمك',
                      hintStyle: TextStyle(
                        color: Color(0xff888888),
                        fontSize: 17,
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Color(0xff71858d),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'رقم الهاتف',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Container(
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: const Color(0xffaaaaaa)),
                  ),
                  child: TextField(
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    onChanged: controller.setPhone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'أدخل رقم الهاتف',
                      hintStyle: TextStyle(
                        color: Color(0xff888888),
                        fontSize: 17,
                      ),
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: Color(0xff71858d),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'كلمة السر',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Container(
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: const Color(0xffaaaaaa)),
                  ),
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.right,
                    onChanged: controller.setPassword,
                    decoration: const InputDecoration(
                      hintText: 'أدخل كلمة السر',
                      hintStyle: TextStyle(
                        color: Color(0xff888888),
                        fontSize: 17,
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Color(0xff71858d),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'الموقع',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  height: 62,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final location = await Get.toNamed(AppRoutes.location);

                      if (location != null) {
                        controller.setLocation(location);
                      }
                    },
                    icon: const Icon(Icons.location_on_outlined, size: 26),
                    label: const Text(
                      'حدد موقعك',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xff279C45),
                      elevation: 0,
                      side: const BorderSide(color: Color(0xffaaaaaa)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  height: 62,
                  child: ElevatedButton(
                    onPressed: () async {
                      final success = await controller.sendOtp();

                      if (success) {
                        Get.toNamed(AppRoutes.otp);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff32B94B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      'إنشاء الحساب',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      ' لديك حساب؟',
                      style: TextStyle(fontSize: 16, color: Color(0xff555555)),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'تسجيل دخول',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff279C45),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

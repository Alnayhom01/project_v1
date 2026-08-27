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
                  child: Stack(
                    children: [
                      TextField(
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        onChanged: controller.setPhone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '92×××××××',
                          hintTextDirection: TextDirection.ltr,
                          hintStyle: TextStyle(
                            color: Color(0xff888888),
                            fontSize: 17,
                          ),
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
                            Icon(
                              Icons.phone_outlined,
                              color: Color(0xff71858d),
                            ),
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

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(13),
                    onTap: () async {
                      final location = await Get.toNamed(AppRoutes.location);

                      if (location != null) {
                        controller.setLocation(location);
                      }
                    },
                    child: Container(
                      height: 58,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: controller.selectedLocation != null
                              ? const Color(0xff32b94b)
                              : const Color(0xffaaaaaa),
                          width: controller.selectedLocation != null ? 1.3 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            controller.selectedLocation != null
                                ? Icons.check_circle_outline_rounded
                                : Icons.location_on_outlined,
                            color: const Color(0xff32b94b),
                            size: 25,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              controller.selectedLocation != null
                                  ? 'تم تحديد موقعك'
                                  : 'حدد موقعك',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: controller.selectedLocation != null
                                    ? const Color(0xff32b94b)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (controller.selectedLocation != null)
                            IconButton(
                              onPressed: () async {
                                final location = await Get.toNamed(
                                  AppRoutes.location,
                                );
                                if (location != null) {
                                  controller.setLocation(location);
                                }
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 38,
                                minHeight: 38,
                              ),
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 21,
                                color: Color(0xff32b94b),
                              ),
                            )
                          else
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Colors.black45,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                Obx(
                  () => SizedBox(
                    height: 62,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
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
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'إنشاء الحساب',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
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

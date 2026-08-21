import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_v1/View/AddReport.dart';
import 'package:project_v1/View/SignUp.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 45),

                // =========================
                // العنوان
                // =========================
                const Text(
                  'تسجيل الدخول',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'أدخل رقم الهاتف وكلمة السر للدخول إلى حسابك',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff555555)),
                ),

                const SizedBox(height: 55),

                // =========================
                // رقم الهاتف
                // =========================
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
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.right,

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

                // =========================
                // كلمة السر
                // =========================
                const Text(
                  'كلمة السر',
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
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.right,

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

                const SizedBox(height: 12),

                // =========================
                // نسيت كلمة السر
                // =========================
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // نسيت كلمة السر
                    },
                    child: const Text(
                      'نسيت كلمة السر؟',
                      style: TextStyle(
                        color: Color(0xff279C45),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // =========================
                // زر تسجيل الدخول
                // =========================
                SizedBox(
                  height: 62,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.off(Addreport());
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
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // =========================
                // إنشاء حساب
                // =========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ليس لديك حساب؟',
                      style: TextStyle(fontSize: 16, color: Color(0xff555555)),
                    ),

                    TextButton(
                      onPressed: () {
                        Get.to(SignUp());
                      },
                      child: const Text(
                        'إنشاء حساب',
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

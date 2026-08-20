import 'package:flutter/material.dart';
import 'package:project_v1/Location.dart';
import 'package:project_v1/OtpPage.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
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

                // =========================
                // العنوان
                // =========================
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

                // =========================
                // الاسم
                // =========================
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
                  child: const TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
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

                // =========================
                // رقم الهاتف
                // =========================
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
                  child: const TextField(
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
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
                  child: const TextField(
                    obscureText: true,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
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

                // =========================
                // تحديد الموقع
                // =========================
                const Text(
                  'الموقع',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  height: 62,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Location(),
                        ),
                      );
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

                // =========================
                // زر إنشاء الحساب
                // =========================
                SizedBox(
                  height: 62,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OtpPage(),
                        ),
                      );
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

                // =========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      ' لديك حساب؟',
                      style: TextStyle(fontSize: 16, color: Color(0xff555555)),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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

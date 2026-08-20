import 'package:flutter/material.dart';
import 'package:project_v1/AddReport.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final node in otpFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }

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
                  onPressed: () {},
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Addreport(),
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
                      'تحقق',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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
        controller: otpControllers[index],
        focusNode: otpFocusNodes[index],

        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,

        keyboardType: TextInputType.number,
        maxLength: 1,

        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            otpFocusNodes[index + 1].requestFocus();
          }

          if (value.isEmpty && index > 0) {
            otpFocusNodes[index - 1].requestFocus();
          }
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

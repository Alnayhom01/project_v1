import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_v1/Controller/otp_controller.dart';
  Widget otpBox(int index) {
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

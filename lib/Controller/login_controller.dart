import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final phoneController = ''.obs;
  final passwordController = ''.obs;

  final isLoading = false.obs;

  Future<bool> login() async {
    final phone = phoneController.value.trim();
    final password = passwordController.value;

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'أدخل رقم الهاتف وكلمة المرور',
        titleText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'تنبيه',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight(200)),
          ),
        ),
        messageText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'أدخل رقم الهاتف وكلمة المرور',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
          ),
        ),
      );
      return false;
    }

    try {
      isLoading.value = true;

      final passwordHash = sha256.convert(utf8.encode(password)).toString();

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(phone)
          .get();

      if (!doc.exists) {
        Get.snackbar(
          'خطأ',
          'رقم الهاتف غير مسجل',
          titleText: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'خطأ',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight(200)),
            ),
          ),
          messageText: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'رقم الهاتف غير مسجل',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
            ),
          ),
        );
        return false;
      }

      final data = doc.data();

      if (data == null) {
        Get.snackbar(
          'خطأ',
          'تعذر قراءة بيانات الحساب',
          titleText: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'خطأ',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight(200)),
            ),
          ),
          messageText: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'تعذر قراءة بيانات الحساب',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
            ),
          ),
        );
        return false;
      }

      final savedPasswordHash = data['passwordHash'];

      if (savedPasswordHash != passwordHash) {
        Get.snackbar(
          'خطأ',
          'رقم الهاتف أو كلمة المرور غير صحيحة',
          titleText: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'خطأ',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight(200)),
            ),
          ),
          messageText: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'رقم الهاتف أو كلمة المرور غير صحيحة',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
            ),
          ),
        );
        return false;
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userPhone', phone);

      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر الاتصال بقاعدة البيانات',
        titleText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'خطأ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight(200)),
          ),
        ),
        messageText: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'تعذر الاتصال بقاعدة البيانات',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight(150)),
          ),
        ),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

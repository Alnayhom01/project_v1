import 'dart:math';

import '../services/ultramsg_service.dart';

class OtpController {
  final UltramsgService ultramsg;

  OtpController(this.ultramsg);

  final Map<String, String> _otps = {};
  final Map<String, DateTime> _otpExpiry = {};

  String _generateOtp() {
    return (100000 + Random().nextInt(900000)).toString();
  }

  Future<bool> sendOtp(String phone) async {
    final otp = _generateOtp();

    // OTP جديد يلغي القديم
    _otps[phone] = otp;

    // صلاحية OTP لمدة 5 دقائق
    _otpExpiry[phone] = DateTime.now().add(const Duration(minutes: 5));

    final sent = await ultramsg.sendOtp(phone: phone, otp: otp);

    // إذا فشل الإرسال نحذف الرمز
    if (!sent) {
      _otps.remove(phone);
      _otpExpiry.remove(phone);
    }

    return sent;
  }

  bool verifyOtp({required String phone, required String otp}) {
    final savedOtp = _otps[phone];
    final expiry = _otpExpiry[phone];

    if (savedOtp == null || expiry == null) {
      return false;
    }

    // انتهت الصلاحية
    if (DateTime.now().isAfter(expiry)) {
      _otps.remove(phone);
      _otpExpiry.remove(phone);
      return false;
    }

    // الرمز صحيح
    if (savedOtp == otp) {
      _otps.remove(phone);
      _otpExpiry.remove(phone);
      return true;
    }

    return false;
  }
}

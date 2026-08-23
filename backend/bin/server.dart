import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../lib/services/ultramsg_service.dart';
import '../lib/controllers/otp_controller.dart';

void main() async {
  final env = DotEnv()..load();

  final ultramsg = UltramsgService(env);
  final otpController = OtpController(ultramsg);

  final router = Router();

  router.post('/send-otp', (Request request) async {
    final body = await request.readAsString();

    final phone = Uri.splitQueryString(body)['phone'];

    if (phone == null || phone.isEmpty) {
      return Response(400, body: 'Phone is required');
    }

    final sent = await otpController.sendOtp(phone);

    if (!sent) {
      return Response(500, body: 'Failed to send OTP');
    }

    return Response.ok('OTP sent');
  });

  router.post('/verify-otp', (Request request) async {
    final body = await request.readAsString();
    final data = Uri.splitQueryString(body);

    final phone = data['phone'];
    final otp = data['otp'];

    if (phone == null || otp == null) {
      return Response(400, body: 'Phone and OTP are required');
    }

    final valid = otpController.verifyOtp(
      phone: phone,
      otp: otp,
    );

    return valid
        ? Response.ok('OTP verified')
        : Response(400, body: 'Invalid OTP');
  });

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final server = await shelf_io.serve(
    handler,
    '0.0.0.0',
    8080,
  );

  print('Server running on http://${server.address.host}:${server.port}');
}
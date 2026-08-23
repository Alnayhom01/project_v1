import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

class UltramsgService {
  final DotEnv env;

  UltramsgService(this.env);

  Future<bool> sendOtp({
    required String phone,
    required String otp,
  }) async {
    final instanceId = env['ULTRAMSG_INSTANCE_ID'];
    final token = env['ULTRAMSG_TOKEN'];

    final url = Uri.parse(
      'https://api.ultramsg.com/$instanceId/messages/chat',
    );

    final message = 'رمز التحقق الخاص بك هو: $otp';

    final response = await http.post(
      url,
      body: {
        'token': token,
        'to': phone,
        'body': message,
      },
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
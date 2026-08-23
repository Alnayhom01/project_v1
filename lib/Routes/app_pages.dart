import 'package:get/get.dart';
import 'package:project_v1/Bindings/add_report_binding.dart';
import 'package:project_v1/Bindings/edit_report_binding.dart';
import 'package:project_v1/Bindings/location_binding.dart';
import 'package:project_v1/Bindings/login_binding.dart';
import 'package:project_v1/Bindings/otp_binding.dart';
import 'package:project_v1/Bindings/signup_binding.dart';
import 'package:project_v1/Routes/app_routes.dart';
import 'package:project_v1/View/AddReport.dart';
import 'package:project_v1/View/EditReport.dart';
import 'package:project_v1/View/Location.dart';
import 'package:project_v1/View/LogIn.dart';
import 'package:project_v1/View/MyReport.dart';
import 'package:project_v1/View/OtpPage.dart';
import 'package:project_v1/View/SignUp.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.login, page: () => const LogIn(), binding: LoginBinding()),
    GetPage(name: AppRoutes.signup, page: () => const SignUp(), binding: SignUpBinding()),
    GetPage(name: AppRoutes.otp, page: () => const OtpPage(), binding: OtpBinding()),
    GetPage(name: AppRoutes.location, page: () => const Location(), binding: LocationBinding()),
    GetPage(name: AppRoutes.addReport, page: () => const Addreport(), binding: AddReportBinding()),
    GetPage(name: AppRoutes.editReport, page: () => const Editreport(), binding: EditReportBinding()),
    GetPage(name: AppRoutes.myReport, page: () => const MyReport()),
  ];
}

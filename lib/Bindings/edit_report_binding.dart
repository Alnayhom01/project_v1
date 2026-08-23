import 'package:get/get.dart';
import 'package:project_v1/Controller/edit_report_controller.dart';

class EditReportBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<EditReportController>(() => EditReportController());
}

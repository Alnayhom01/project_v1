import 'package:get/get.dart';
import 'package:project_v1/Controller/add_report_controller.dart';

class AddReportBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<AddReportController>(() => AddReportController());
}

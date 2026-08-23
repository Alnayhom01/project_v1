import 'package:get/get.dart';
import 'package:project_v1/Controller/location_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<LocationController>(() => LocationController());
}

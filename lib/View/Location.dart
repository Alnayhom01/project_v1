import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_v1/Controller/location_controller.dart';

class Location extends StatelessWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocationController>();
    return GetBuilder<LocationController>(
      builder: (_) => Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xff32b94b)),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: controller.selectedLocation,
            zoom: 14,
          ),
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          onMapCreated: controller.onMapCreated,
          onTap: controller.selectLocation,
          markers: {
            Marker(
              markerId: const MarkerId('selected'),
              position: controller.selectedLocation,
            ),
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff32b94b),
          onPressed: controller.getCurrentLocation,
          child: const Icon(Icons.my_location),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: () => Get.back(result: controller.selectedLocation),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff32b94b),
                foregroundColor: Colors.white,
              ),
              child: const Text('تأكيد الموقع'),
            ),
          ),
        ),
      ),
    );
  }
}

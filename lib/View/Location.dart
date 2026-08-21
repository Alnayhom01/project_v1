import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  GoogleMapController? mapController;

  LatLng selectedLocation = const LatLng(32.76, 21.75);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختيار الموقع'), centerTitle: true),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLocation,
              zoom: 15,
            ),

            onMapCreated: (controller) {
              mapController = controller;
            },

            onCameraMove: (position) {
              selectedLocation = position.target;
            },

            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // الدبوس في منتصف الشاشة
          const Center(
            child: Icon(Icons.location_pin, size: 50, color: Colors.red),
          ),

          // زر موقعي الحالي
          Positioned(
            right: 16,
            bottom: 90,
            child: FloatingActionButton(
              heroTag: 'currentLocation',
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),

      // زر تأكيد الموقع
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'confirmLocation',
        onPressed: () {
          Get.back(result: selectedLocation);
        },
        label: const Text('تأكيد الموقع'),
        icon: const Icon(Icons.check),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    // التأكد من تشغيل خدمة الموقع
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // التأكد من الصلاحيات
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }

    // ==========================================
    // 1. نأخذ آخر موقع معروف فورًا
    // ==========================================

    final lastPosition = await Geolocator.getLastKnownPosition();

    if (lastPosition != null) {
      final lastLocation = LatLng(
        lastPosition.latitude,
        lastPosition.longitude,
      );

      setState(() {
        selectedLocation = lastLocation;
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(lastLocation, 17),
      );
    }

    // ==========================================
    // 2. بعدها نطلب الموقع الحالي الأدق
    // ==========================================

    try {
      final currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final currentLocation = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      setState(() {
        selectedLocation = currentLocation;
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation, 17),
      );
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }
}

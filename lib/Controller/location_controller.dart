import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  GoogleMapController? mapController;
  LatLng selectedLocation = const LatLng(32.76, 21.75);

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void selectLocation(LatLng location) {
    selectedLocation = location;
    update();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }

    final lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      selectLocation(LatLng(lastPosition.latitude, lastPosition.longitude));
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(selectedLocation, 17));
    }

    try {
      final currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      selectLocation(LatLng(currentPosition.latitude, currentPosition.longitude));
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(selectedLocation, 17));
    } catch (_) {}
  }
}

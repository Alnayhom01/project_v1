import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('اختيار الموقع'),
        centerTitle: true,
      ),

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
            child: Icon(
              Icons.location_pin,
              size: 50,
              color: Colors.red,
            ),
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
          Navigator.pop(context, selectedLocation);
        },
        label: const Text('تأكيد الموقع'),
        icon: const Icon(Icons.check),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    final newLocation = LatLng(
      position.latitude,
      position.longitude,
    );

    selectedLocation = newLocation;

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        newLocation,
        17,
      ),
    );

    setState(() {});
  }
}
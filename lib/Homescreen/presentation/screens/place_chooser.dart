import 'package:bhaada_customer_app/Homescreen/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  HomeScreenController homeScreenController=Get.put(HomeScreenController());
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(37.42796133580664, -122.085749655962); // Default location

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _selectedLocation = position.target;
  }

  void _onConfirmLocation() async{
    homeScreenController.selectedLocations.add(await getAddressFromLatLng(_selectedLocation));
    print('Selected Location: $_selectedLocation');
    Navigator.pop(context, _selectedLocation); // Return the location when confirmed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _onConfirmLocation, // Confirm selected location
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15,
            ),
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          // Red pointer in the center of the screen
          const Center(
            child: Icon(
              Icons.location_on,
              size: 50,
              color: Colors.red, // Red color for the pointer
            ),
          ),
        ],
      ),
    );
  }
}
Future<String> getAddressFromLatLng(LatLng latLng) async {
  try {
    // Get the list of placemarks based on the coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    if (placemarks.isNotEmpty) {
      // Get the first placemark from the list
      Placemark place = placemarks[0];

      // Create a human-readable address from the placemark
      String address = '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';

      return address; // Return the formatted address
    } else {
      return 'No address found';
    }
  } catch (e) {
    print(e);
    return 'Failed to get address';
  }
}
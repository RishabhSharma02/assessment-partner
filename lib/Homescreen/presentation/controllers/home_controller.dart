import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../screens/shipping_rate_calculator.dart';

class HomeScreenController extends GetxController{
  RxList<String> selectedLocations=<String>[].obs;
  RxString selectedVehicle="".obs;
  RxBool isSearching=false.obs;
  final Rx<TextEditingController> numPackagesController = TextEditingController().obs;
  final Rx<TextEditingController>  weightController = TextEditingController().obs;
  final Rx<TextEditingController>  lengthController = TextEditingController().obs;
  final Rx<TextEditingController>  widthController = TextEditingController().obs;
  final Rx<TextEditingController>  heightController = TextEditingController().obs;
  RxString startAdd="Select Address".obs;
  RxString midAdd="Select Address".obs;
  RxString destAdd="Select Address".obs;
  RxDouble estimatedFare = 0.0.obs;

  Future<void> calculateFare() async {
    int numberOfPackages = int.parse(numPackagesController.value.text);
    double actualWeight = double.parse(weightController.value.text);
    double length = double.parse(lengthController.value.text);
    double width = double.parse(widthController.value.text);
    double height = double.parse(heightController.value.text);

    // Get the city names from user input or selection
    String originCity = startAdd.value;
    String destinationCity = destAdd.value;

    estimatedFare.value = await estimateShippingFare(
      originCity: originCity,
      destinationCity: destinationCity,
      actualWeight: actualWeight,
      length: length,
      width: width,
      height: height,
      numberOfPackages: numberOfPackages,
    );
  }

  Future<double> estimateShippingFare({
    required String originCity,
    required String destinationCity,
    required double actualWeight,
    required double length,
    required double width,
    required double height,
    required int numberOfPackages,
  }) async {
    double distance = await calculateDistanceBetweenCities(originCity, destinationCity);
    double volumetricWeight = calculateVolumetricWeight(length, width, height);
    double chargeableWeight = calculateChargeableWeight(actualWeight, volumetricWeight);
    double baseFare = calculateBaseFare(chargeableWeight, distance);
    double totalFare = calculateTotalFare(baseFare, numberOfPackages);
    return totalFare;
  }

  double calculateVolumetricWeight(double length, double width, double height) {
    // Using 5000 as the volumetric divisor, common in India for air freight
    return (length * width * height) / 5000;
  }

  double calculateChargeableWeight(double actualWeight, double volumetricWeight) {
    return actualWeight > volumetricWeight ? actualWeight : volumetricWeight;
  }

  double calculateBaseFare(double chargeableWeight, double distance) {
    // Adjust the rate per kg per km based on typical Indian rates
    double ratePerKgPerKm = 0.02; // Example rate in INR per kg per km
    return chargeableWeight * distance * ratePerKgPerKm;
  }

  double calculateTotalFare(double baseFare, int numberOfPackages) {
    double handlingFeePerPackage = 50.0;   // Example handling fee in INR
    double fuelSurchargeRate = 0.15;       // 15% fuel surcharge
    double insuranceRate = 0.005;          // 0.5% insurance
    double gstRate = 0.18;                 // 18% GST in India

    double handlingFee = handlingFeePerPackage * numberOfPackages;
    double fuelSurcharge = baseFare * fuelSurchargeRate;
    double insurance = baseFare * insuranceRate;
    double subtotal = baseFare + handlingFee + fuelSurcharge + insurance;
    double gst = subtotal * gstRate;

    return subtotal + gst;
  }

  Future<double> calculateDistanceBetweenCities(String originCity, String destinationCity) async {
    try {
      // Get the coordinates of the origin city
      List<Location> originLocations = await locationFromAddress('$originCity, India');
      if (originLocations.isEmpty) {
        throw Exception('Origin city not found');
      }
      Location origin = originLocations.first;

      // Get the coordinates of the destination city
      List<Location> destinationLocations = await locationFromAddress('$destinationCity, India');
      if (destinationLocations.isEmpty) {
        throw Exception('Destination city not found');
      }
      Location destination = destinationLocations.first;

      // Calculate the distance between the two coordinates in meters
      double distanceInMeters = Geolocator.distanceBetween(
        origin.latitude,
        origin.longitude,
        destination.latitude,
        destination.longitude,
      );

      // Convert the distance to kilometers
      double distanceInKilometers = distanceInMeters / 1000;

      return distanceInKilometers;
    } catch (e) {
      print('Error calculating distance: $e');
      return 0.0;
    }
  }
  RxList<DocumentSnapshot> foundDocs = <DocumentSnapshot> [].obs;

  void searchDocument(String collectionName, String fieldName, String searchValue) async {
    try {
      isSearching.value=true;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where(fieldName, isEqualTo: searchValue)
          .limit(1) // Limiting the result to one document
          .get();

      // Check if any document is found
      if (querySnapshot.docs.isNotEmpty) {
        isSearching.value=false;
        // Add the first document found to the list
        foundDocs.add(querySnapshot.docs.first);
      } else {
        isSearching.value=false;
        Get.showSnackbar(const GetSnackBar(message: "No Order Found",backgroundColor: Colors.red,duration: Duration(seconds: 2),));
      }
    } catch (e) {
      isSearching.value=false;
      print("Error searching document: $e");
    }
  }
  Future<void> createDocument() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Document structure based on the screenshot
  try {
    await firestore.collection('orders').doc('EBsEjw2001gFuRo45abL').set({
      'cashAlloted': 1280,
      'distance': 10,
      'id': 'MVT001',
      'location': const GeoPoint(12.8406, 80.1534),  // Location as GeoPoint
      'orderDetails': [
        {
          'latLng': const GeoPoint(12.88544, 80.0826),
          'name': 'Rishabh',
          'otp': '7745',
          'phoneNumber': '6294443095',
          'type': 'startPoint'
        },
        {
          'latLng': const GeoPoint(12.8913, 80.081),
          'name': 'Mukund',
          'otp': '8876',
          'phoneNumber': '708955627',
          'type': 'dropOff'
        }
      ],
      'status': 'COMPLETED',
      'reciever': 'Rishabh',
      'sender': 'Mukund',
      'timestamp': FieldValue.serverTimestamp(), // You can also pass specific timestamps
    });
    print("Document added successfully");
  } catch (e) {
    print("Error adding document: $e");
  }
}
  Future<void> uploadDocumentWithDialog(BuildContext context) async {
    // Show the loading dialog while uploading
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Uploading..."),
              ],
            ),
          ),
        );
      },
    );

    // Upload the document to Firestore
    try {
      await _createDocument();
      // Close the loading dialog
      Navigator.pop(context);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Order Booked Succcessfully"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the success dialog
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Close the loading dialog if there's an error
      Navigator.pop(context);

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to upload document: $e"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the error dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  // The function to create the Firestore document
  // The function to create the Firestore document
  Future<void> _createDocument() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final orderId = generateRandomId(); // Generate a random order ID
    await firestore.collection('customers').doc("0000000000").collection("orders").add({
      'cashAlloted': 1280,
      'distance': 10,
      'id': orderId,
      'location': const GeoPoint(12.8406, 80.1534),
      'orderDetails': [
        {
          'latLng': const GeoPoint(12.88544, 80.0826),
          'name': 'Rishabh',
          'otp': '7745',
          'phoneNumber': '6294443095',
          'type': 'startPoint'
        },
        {
          'latLng': const GeoPoint(12.8913, 80.081),
          'name': 'Mukund',
          'otp': '8876',
          'phoneNumber': '708955627',
          'type': 'dropOff'
        }
      ],
      'status': 'PENDING',
      'receiver': 'Rishabh',
      'sender': 'Mukund',
      'timestamp': FieldValue.serverTimestamp(),
    });
    
    await firestore.collection('orders').add({
      'cashAlloted': 1280,
      'distance': 10,
      'id': orderId,
      'location': const GeoPoint(12.8406, 80.1534),
      'orderDetails': [
        {
          'latLng': const GeoPoint(12.88544, 80.0826),
          'name': 'Rishabh',
          'otp': '7745',
          'phoneNumber': '6294443095',
          'type': 'startPoint'
        },
        {
          'latLng': const GeoPoint(12.8913, 80.081),
          'name': 'Mukund',
          'otp': '8876',
          'phoneNumber': '708955627',
          'type': 'dropOff'
        }
      ],
      'status': 'PENDING',
      'receiver': 'Rishabh',
      'sender': 'Mukund',
      'timestamp': FieldValue.serverTimestamp(),
    });


  }
  String generateRandomId() {
    String prefix = "MVT";

    // Generate a random number between 1 and 999
    Random random = Random();
    int randomNum = random.nextInt(999) + 1;

    // Return the random ID with zero padding (e.g., MVT001, MVT567)
    return '$prefix${randomNum.toString().padLeft(3, '0')}';
  }
  Future<List<String>> getOrderNumbers() async {
    final orderNumbersBox = Hive.box<List<String>>('orderNumbersBox');

    // Retrieve the list of order IDs stored at index 0
    List<String>? orderIds = orderNumbersBox.get(0);

    // If the list doesn't exist yet, return an empty list
    return orderIds ?? [];
  }
}


import 'package:bhaada_customer_app/Common%20Widgets/common_widgets.dart';
import 'package:bhaada_customer_app/Constants/color_constants.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/best_price_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
class ShippingRateCalculator extends StatefulWidget {
  const ShippingRateCalculator({super.key});

  @override
  State<ShippingRateCalculator> createState() => _ShippingRateCalculatorState();
}

class _ShippingRateCalculatorState extends State<ShippingRateCalculator> {
  final TextEditingController _numPackagesController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _originCityController = TextEditingController();
  final TextEditingController _destinationCityController = TextEditingController();
  int itemCount=0;
  double _estimatedFare = 0.0;
  String? _selectedParcelType;
  Vehicle? _selectedVehicle;

  final List<String> _parcelTypes = [
    'Documents',
    'Electronics',
    'Fragile Items',
    'Perishable Goods',
    'Clothing',
    'Furniture',
    'Automotive Parts',
    'Other',
  ];

  // Define the list of vehicles
  final List<Vehicle> vehicles = [
    Vehicle(
      name: 'Motorbike',
      maxDistance: 35.0,
      maxWeight: parseLoadCapacity('Upto 50kg'),
      ratePerKm: 10.0,
      type: '2-Wheeler',
      order: 1,
    ),
    Vehicle(
      name: 'E-Rickshaw',
      maxDistance: 50.0,
      maxWeight: parseLoadCapacity('Upto 500 kg'),
      ratePerKm: 12.0,
      type: '3-Wheeler',
      order: 2,
    ),
    Vehicle(
      name: 'Mini Loader',
      maxDistance: 200.0,
      maxWeight: parseLoadCapacity('Upto 1500Kg'),
      ratePerKm: 15.0,
      type: '4-Wheeler',
      order: 3,
    ),
    Vehicle(
      name: 'Max Pickup',
      maxDistance: 500.0,
      maxWeight: parseLoadCapacity('Upto 2500kg'),
      ratePerKm: 18.0,
      type: '4-Wheeler',
      order: 4,
    ),
    Vehicle(
      name: 'DCM Truck',
      maxDistance: double.infinity,
      maxWeight: parseLoadCapacity('Upto 8000Kg'),
      ratePerKm: 25.0,
      type: '4-Wheeler',
      order: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildCommonButton(() {
        _calculateFare().then((_) {
          if (_estimatedFare != 0) {
            Get.to(() => BestPriceScreen(
              weight: double.tryParse(_weightController.text) ?? 0.0,
              packages: int.tryParse(_numPackagesController.text) ?? 0,
              stops: 2,
              startPrice: _estimatedFare,
              bestVehicleType: _selectedVehicle!.name,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please check the details provided."),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      }, "Calculate Shipment Rate", true).paddingOnly(
          left: 24.w, right: 24.w, bottom: 29.h, top: 10.h),
      appBar: buildCommonAppbar("Shipping Rate Calculator", false, true),
      backgroundColor: ColorConstants.bgColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildNameTextfield(_originCityController, "Enter Source Address").paddingOnly(top: 16.h, left: 21.w, right: 17.w),
            buildNameTextfield(_destinationCityController, "Enter Destination Address").paddingOnly(top: 16.h, left: 21.w, right: 17.w),
            buildTitle("Package Details")
                .paddingOnly(top: 30.h, left: 21.w, right: 17.w),

            buildParcelTypeDropdown(),
            buildTextfield(_numPackagesController, "Total Number of packages")
                .paddingOnly(top: 16.h, left: 21.w, right: 17.w),
            buildWeightField(_weightController, "Approximate total weight")
                .paddingOnly(top: 16.h, left: 21.w, right: 17.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildWeightContainer("Length", _lengthController, "Length"),
                Icon(
                  Icons.close,
                  size: 20.sp,
                ).paddingOnly(top: 25.h),
                buildWeightContainer("Width", _widthController, "Width"),
                Icon(
                  Icons.close,
                  size: 20.sp,
                ).paddingOnly(top: 25.h),
                buildWeightContainer("Height", _heightController, "Height"),
              ],
            ).paddingOnly(top: 16.h, left: 21.w, right: 17.w),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String title) => Text(
    title,
    style: TextStyle(
        fontSize: 14.sp,
        color: ColorConstants.blackColor,
        fontWeight: FontWeight.w600),
  );

  Widget buildParcelTypeDropdown() {
    return Container(
      margin: EdgeInsets.only(top: 16.h, left: 21.w, right: 17.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: ColorConstants.borderColor),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedParcelType,
          hint: const Text(
            'Select Parcel Type',
            style: TextStyle(color: ColorConstants.fontLightColor),
          ),
          items: _parcelTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedParcelType = newValue;
            });
          },
        ),
      ),
    );
  }
  Future<void> _calculateFare() async {
    try {
      int numberOfPackages = int.parse(_numPackagesController.text);
      double actualWeight = double.parse(_weightController.text);
      double length = double.parse(_lengthController.text);
      double width = double.parse(_widthController.text);
      double height = double.parse(_heightController.text);

      // Get the city names from user input or selection
      String originCity = _originCityController.text;
      String destinationCity = _destinationCityController.text;

      _estimatedFare = await estimateShippingFare(
        originCity: originCity,
        destinationCity: destinationCity,
        actualWeight: actualWeight,
        length: length,
        width: width,
        height: height,
        numberOfPackages: numberOfPackages,
      );
    } catch (e) {
     // Get.showSnackbar(const GetSnackBar(message: "Check Details",backgroundColor: Colors.red,duration: Duration(seconds: 2),));
      _estimatedFare = 0.0;
    }
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
    if (distance == 0.0) {
      throw Exception('Unable to calculate distance between cities.');
    }

    double volumetricWeight = calculateVolumetricWeight(length, width, height);
    double chargeableWeight = calculateChargeableWeight(actualWeight, volumetricWeight);

    // Get suitable vehicles
    List<Vehicle> suitableVehicles = getSuitableVehicles(distance, chargeableWeight);

    if (suitableVehicles.isEmpty) {
      throw Exception('No suitable vehicle available for the shipment.');
    }

    // Select the most cost-effective vehicle
    Vehicle selectedVehicle = selectBestVehicle(suitableVehicles);

    double baseFare = calculateBaseFare(chargeableWeight, distance, selectedVehicle.ratePerKm);
    double totalFare = calculateTotalFare(baseFare, numberOfPackages);

    // Store the selected vehicle
    _selectedVehicle = selectedVehicle;

    return totalFare;
  }

  double calculateVolumetricWeight(double length, double width, double height) {
    // Using 5000 as the volumetric divisor, common in India for air freight
    return (length * width * height) / 5000;
  }

  double calculateChargeableWeight(double actualWeight, double volumetricWeight) {
    return actualWeight > volumetricWeight ? actualWeight : volumetricWeight;
  }

  List<Vehicle> getSuitableVehicles(double distance, double chargeableWeight) {
    return vehicles.where((vehicle) {
      return distance <= vehicle.maxDistance && chargeableWeight <= vehicle.maxWeight;
    }).toList();
  }

  Vehicle selectBestVehicle(List<Vehicle> suitableVehicles) {
    // Sort based on ratePerKm and then order
    suitableVehicles.sort((a, b) {
      int rateComparison = a.ratePerKm.compareTo(b.ratePerKm);
      if (rateComparison != 0) {
        return rateComparison;
      } else {
        return a.order.compareTo(b.order);
      }
    });
    return suitableVehicles.first;
  }

  double calculateBaseFare(double chargeableWeight, double distance, double ratePerKm) {
    return chargeableWeight * distance * ratePerKm;
  }

  double calculateTotalFare(double baseFare, int numberOfPackages) {
    double handlingFeePerPackage = 50.0; // Example handling fee in INR
    double fuelSurchargeRate = 0.15;     // 15% fuel surcharge
    double insuranceRate = 0.005;        // 0.5% insurance
    double gstRate = 0.18;               // 18% GST in India

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
}

// Define the Vehicle class outside the State class
class Vehicle {
  final String name;
  final double maxDistance; // in kilometers
  final double maxWeight;   // in kilograms
  final double ratePerKm;   // in INR per kg per km
  final String type;
  final int order;

  Vehicle({
    required this.name,
    required this.maxDistance,
    required this.maxWeight,
    required this.ratePerKm,
    required this.type,
    required this.order,
  });
}

// Function to parse load capacity strings
double parseLoadCapacity(String loadCapacity) {
  // Remove 'Upto' and 'kg', then parse the number
  String numberStr = loadCapacity.replaceAll(RegExp(r'[^\d.]'), '');
  return double.tryParse(numberStr) ?? 0.0;
}

// Extension method for Vehicle
extension VehicleExtension on Vehicle {
  String loadCapacityString() {
    return 'Upto ${maxWeight.toStringAsFixed(0)}kg';
  }
}
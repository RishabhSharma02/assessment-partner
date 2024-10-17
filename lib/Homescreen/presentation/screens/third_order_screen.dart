import 'package:bhaada_customer_app/Homescreen/presentation/controllers/home_controller.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/shipping_rate_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Common Widgets/common_widgets.dart';
import '../../../Constants/color_constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class ThirdOrderScreen extends StatelessWidget {
  ThirdOrderScreen({super.key});
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  Vehicle? _selectedVehicle;
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
    return Column(
      children: [
        // Build the container displaying shipping rate details and best vehicle options
        Obx(() {
          return buildBestContainer(
              "Motorbike",
              double.tryParse(homeScreenController.weightController.value.text) ??
                  0.0,
              double.tryParse(
                  homeScreenController.numPackagesController.value.text) ??
                  0.0,
              3,
              homeScreenController.estimatedFare.value ?? 0.0,
              homeScreenController.estimatedFare.value + 73,context);
        }),
        buildTitle("Want to book another vehicle?")
            .paddingOnly(top: 40.h, left: 21.w),

        // List of suitable vehicle options based on the calculated fare and other inputs
        Expanded(
            child: ListView.builder(
              itemBuilder: (c, i) {
                return buildOptions(vehicles[i]);
              },
              itemCount: vehicles.length,
            ))
      ],
    );
  }

  // This method calculates fare and vehicle options for a given context.
  Future<void> _calculateFare() async {
    try {
      double weight = double.parse(homeScreenController.weightController.value.text);
      double packages = double.parse(homeScreenController.numPackagesController.value.text);
      double distance = 50.0; // You can fetch this dynamically

      double estimatedFare = calculateTotalFare(weight, distance, packages.toInt());
      homeScreenController.estimatedFare.value = estimatedFare;

      // Get suitable vehicles
      List<Vehicle> suitableVehicles = getSuitableVehicles(distance, weight);

      // Select the most cost-effective vehicle
      Vehicle selectedVehicle = selectBestVehicle(suitableVehicles);

      // Update the vehicle and fare in the controller for further use in the UI
      homeScreenController.selectedVehicle.value= selectedVehicle.name;
      homeScreenController.estimatedFare.value = estimatedFare;
    } catch (e) {
      homeScreenController.estimatedFare.value = 0.0;
    }
  }

  Widget buildOptions(Vehicle vehicle) => Container(
      margin: EdgeInsets.only(left: 21.w, right: 21.w, top: 15.h),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          border: Border.all(
            color: ColorConstants.lightGreyColor,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Image.asset(
            "assets/MOTOR_BIKE.png",
            width: 48.w,
            height: 36.h,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vehicle.name,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorConstants.textColor,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "Load upto ${vehicle.maxWeight.toStringAsFixed(0)} kg",
                style: TextStyle(
                    fontSize: 12.sp, color: ColorConstants.hintColor),
              )
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${vehicle.ratePerKm * 10} - ₹${vehicle.ratePerKm * 12}",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorConstants.textColor,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "₹${vehicle.ratePerKm * 15}",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorConstants.hintColor,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: ColorConstants.hintColor),
              )
            ],
          )
        ],
      ));

  Widget buildBestContainer(String nameOfService, double weight,
      double packages, double stops, double lowPrice, double highPrice,BuildContext context) =>
      Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 35.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorConstants.bestContainerColor,
            ),
            padding: EdgeInsets.only(
                top: 16.h, left: 27.w, right: 27.w, bottom: 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  nameOfService,
                  style:
                  TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    buildBestBox("Weight", weight),
                    const Spacer(),
                    buildBestBox("Packages", packages),
                    const Spacer(),
                    buildBestBox("Stops", stops)
                  ],
                ).paddingOnly(top: 27.h),
                buildCommonButton(() {
                  _calculateFare();
                  homeScreenController.uploadDocumentWithDialog(context) ;
                }, "Book @ ₹$lowPrice - ₹$highPrice", true)
                    .paddingOnly(top: 22.h),
              ],
            ),
          ),
          Positioned(
              top: 26.h,
              left: 10.w,
              child: Image.asset(
                "assets/BEST_CHOICE.png",
                width: 86.w,
                height: 82.5.h,
              )),
        ],
      );

  Widget buildBestBox(String parameter, double value) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: ColorConstants.bestContainerParaColor,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          value.toString(),
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      Text(
        parameter,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
      ).paddingOnly(top: 12.h)
    ],
  );

  List<Vehicle> getSuitableVehicles(double distance, double chargeableWeight) {
    return vehicles.where((vehicle) {
      return distance <= vehicle.maxDistance && chargeableWeight <= vehicle.maxWeight;
    }).toList();
  }

  Vehicle selectBestVehicle(List<Vehicle> suitableVehicles) {
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

  double calculateTotalFare(double weight, double distance, int packages) {
    double baseFare = weight * distance * 12; // Simplified fare calculation
    return baseFare + (packages * 50); // Add package handling fee
  }

  Widget buildTitle(String title) => Text(
    title,
    style: TextStyle(
        fontSize: 14.sp,
        color: ColorConstants.blackColor,
        fontWeight: FontWeight.w500),
  );
}

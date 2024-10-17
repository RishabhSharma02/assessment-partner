import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../Common Widgets/common_widgets.dart';
import '../../../Constants/color_constants.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppbar("Order Details", false, true),
      backgroundColor: ColorConstants.bgColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders') // Replace with your collection name
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Order not found'));
          }

          // Fetching order data from the document
          var orderData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildOrderText(orderData['id'] ?? 'Unknown'),
                    buildProgressWidget(orderData['status'])
                  ],
                ).paddingOnly(left: 20.w, right: 20.w, top: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 100.w,
                        child: const Divider(
                          color: ColorConstants.lightGreyColor,
                        )).paddingOnly(right: 7.w),
                    buildDateText(formatDateWithOrdinal( orderData['timestamp'].toDate())),
                    SizedBox(
                        width: 100.w,
                        child: const Divider(
                          color: ColorConstants.lightGreyColor,
                        )).paddingOnly(left: 7.w),
                  ],
                ).paddingOnly(left: 18.w, right: 18.w, top: 30.h),
                if(orderData['status']=="IN TRANSIT")
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
                  width: 360.w,
                  height: 381.h,
                  child: GoogleMap(
                    onTap: (val) {
                      // homeScreenController.testing(val.latitude, val.longitude);
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("Currpos"),
                        position: LatLng(
                            (orderData['location'] as GeoPoint).latitude ,
                          (orderData['location'] as GeoPoint).longitude
                          ,
                        ),
                        infoWindow:  InfoWindow(title: "Your Location".tr),
                      ),
                    },
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      zoom: 17,
                      target: LatLng(
                          (orderData['location'] as GeoPoint).latitude ,
                          (orderData['location'] as GeoPoint).longitude
                      ),
                    ),
                  ),
                ),
                CustomTimeline( orderDetails:orderData['orderDetails']??[] ,),
                buildOrderItem("Receiver", orderData['reciever'] ?? 'Unknown')
                    .paddingOnly(left: 18.w, right: 18.w, top: 30.h),
                const Divider(
                  color: ColorConstants.lightGreyColor,
                ).paddingOnly(left: 18.w, right: 18.w, top: 11.h),
                buildOrderItem("Sender", orderData['sender'] ?? 'Unknown')
                    .paddingOnly(left: 18.w, right: 18.w),
                const Divider(
                  color: ColorConstants.lightGreyColor,
                ).paddingOnly(left: 18.w, right: 18.w, top: 11.h),
                buildOrderEbill("E-way bill", "View Bill", () {})
                    .paddingOnly(left: 18.w, right: 18.w),
                buildTitleText("Bill Details")
                    .paddingOnly(left: 18.w, right: 18.w, top: 43.h),
                buildOrderItem("Trip Fare", "₹${orderData['cashAlloted'] ?? '0.00'}")
                    .paddingOnly(left: 18.w, right: 18.w, top: 27.h),
                const Divider(
                  color: ColorConstants.lightGreyColor,
                ).paddingOnly(left: 18.w, right: 18.w),
                buildOrderItem("Cash collected", "₹${orderData['cashAlloted'] ?? '0.00'}")
                    .paddingOnly(left: 18.w, right: 18.w, top: 11.h),

              ],
            ),
          );
        },
      ),
    );
  }


  Widget buildOrderEbill(
      String leftText, String rightText, Function() onTapped) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: ColorConstants.textColor),
          ),
          InkWell(
            onTap: onTapped,
            child: Text(
              rightText,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.btnColor,
                  decoration: TextDecoration.underline,
                  decorationColor: ColorConstants.btnColor),
            ),
          )
        ],
      );
  Widget buildOrderEarning(
      String leftText, String rightText, bool isDeduction) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: ColorConstants.textColor),
          ),
          Text(
            rightText,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDeduction
                    ? ColorConstants.redColor
                    : ColorConstants.greenColor),
          )
        ],
      );
  Widget buildOrderItem(String leftText, String rightText) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        leftText,
        style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: ColorConstants.textColor),
      ),
      Text(
        rightText,
        style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.blackColor),
      )
    ],
  );
  Widget buildProgressWidget(String status) => Container(
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 3.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(17.r),
      color: ColorConstants.bgColor,
      border: Border.all(
        color: status == "COMPLETED"
            ? ColorConstants.greenColor
            : status == "IN TRANSIT"
            ? ColorConstants.greenColor
            : status == "PENDING"
            ? Colors.amber
            : ColorConstants.redColor, // Default to red for cancelled or other states
      ),
    ),
    child: Text(
      status.tr, // Translated status text
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: status == "COMPLETED"
            ? ColorConstants.greenColor
            : status == "IN TRANSIT"
            ? ColorConstants.greenColor
            : status == "PENDING"
            ? Colors.amber
            : ColorConstants.redColor, // Same logic as border color
      ),
    ),
  );
  Widget buildDateText(String date) => Text(
    date,
    style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: ColorConstants.textColor),
  );
  Widget buildOrderText(String orderId) => Text(
    "Order ID: $orderId".tr,
    style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: ColorConstants.blackColor),
  );
}

Widget buildTitleText(String text) => Text(
  text,
  style: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: ColorConstants.blackColor),
);

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating - 0.5
              ? Icons.star
              : index < rating
              ? Icons.star_half
              : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }
}

class CustomTimeline extends StatelessWidget {
  final List<dynamic> orderDetails;

  const CustomTimeline({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(orderDetails.length, (index) {
        final orderDetail = orderDetails[index];
        final isFirst = index == 0;
        final isLast = index == orderDetails.length - 1;
        final latLng = orderDetail['latLng'] as GeoPoint;
        final name = orderDetail['name'] ?? 'Unknown';
        final phoneNumber = orderDetail['phoneNumber'] ?? 'N/A';
        final type = orderDetail['type'] ?? 'Unknown';

        return FutureBuilder(
          future: getAddressFromLatLng(latLng.latitude, latLng.longitude),
          builder: (ctx, strVal) =>
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: buildTimelineTile(
                  name: name,
                  phoneNumber: phoneNumber,
                  description: strVal.data ?? "Unknown Location",
                  isFirst: isFirst,
                  isLast: isLast,
                  indicatorColor: determineIndicatorColor(type),
                ),
              ),
        );
      }),
    );
  }

  // String formatLatLng( latLng) {
  //   if (latLng.isNotEmpty && latLng.length == 2) {
  //     return '${latLng[0]}°, ${latLng[1]}°';
  //   }
  //   return 'Location not available';
  // }

  Color determineIndicatorColor(String type) {
    if (type == 'startPoint') {
      return Colors.green;
    } else if (type == 'dropOff') {
      return Colors.red;
    }
    return Colors.green;
  }

  Widget buildTimelineTile({
    required String name,
    required String phoneNumber,
    required String description,
    required bool isFirst,
    required bool isLast,
    required Color indicatorColor,
  }) {
    return TimelineTile(

      alignment: TimelineAlign.start,
      // Align the timeline to the left
      lineXY: 0.1,
      // Adjust the position of the timeline line (closer to the left)
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: indicatorColor,
        padding: const EdgeInsets.all(6),
      ),
      beforeLineStyle: const LineStyle(
        color: Colors.grey,
        thickness: 2,
      ),
      afterLineStyle: const LineStyle(
        color: Colors.grey,
        thickness: 2,
      ),
      endChild: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        // Adjust padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Add some space between name and phone number
            Text(
              phoneNumber,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            // Add space between phone number and description
            Text(description),
          ],
        ),
      ),
    );
  }
}
Future<String> getAddressFromLatLng(double lat, double lng) async {
  try {
    // Getting the list of placemarks from the latitude and longitude
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      // We are using the first placemark here; it contains address information
      Placemark place = placemarks[0];
      // Constructing the address from the placemark data
      return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    }
    return "No address available";
  } catch (e) {
    print("Error occurred: $e");
    return "Error: Unable to fetch address";
  }
}
String formatDateWithOrdinal(DateTime dateTime) {
  final DateFormat dayFormatter = DateFormat('d'); // Day without suffix
  final DateFormat monthYearFormatter = DateFormat('MMMM yyyy'); // Month and year

  String day = dayFormatter.format(dateTime);
  String monthYear = monthYearFormatter.format(dateTime);

  // Get the ordinal suffix for the day
  String suffix = getDaySuffix(int.parse(day));

  return '$day$suffix $monthYear';
}

// Function to get the ordinal suffix for the day
String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
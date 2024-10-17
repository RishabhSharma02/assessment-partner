import 'package:bhaada_customer_app/Constants/color_constants.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/add_order_screen.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/shipping_rate_calculator.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/track_order_screen.dart';
import 'package:bhaada_customer_app/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderOnForeground: false,
      color: ColorConstants.bgColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0,4.9],
                  colors: <Color>[

                  Color.fromARGB(255, 188, 228, 255),
                    Colors.white,

                   // ColorConstants.bgColor,
                  ],

                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildPickupLocation("Dlf Capital Greens, Moti Nagar")
                      .paddingOnly(left: 25.w, top: 51.h),
                  buildName("Hi, Testing!").paddingOnly(top: 49.h, left: 25.w),
                  buildAdSection(["assets/AD.png", "assets/AD.png"]).paddingOnly(top: 26.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCta("Add Order", "assets/ADD_ORDER.png", () {
                        Get.to(()=>AddOrderScreen());
                      }),
                      buildCta("Estimate Price", "assets/ESTIMATE_PRICE.png",
                          () {
                        Get.to(() => ShippingRateCalculator());
                      }),
                      buildCta("Track Order", "assets/TRACK_PARCEL.png", () {
                        Get.to(()=>TrackOrderScreen());
                      })
                    ],
                  ).paddingOnly(top: 22.h),
                  buildTitle("Available vehicles")
                      .paddingOnly(top: 33.h, left: 25.w),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 342.w,
                  height: 221.h,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('vehicles').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return buildVehicleContainer(
                            snapshot.data!.docs[index].get("name"),
                            snapshot.data!.docs[index].get("imgUrl"),
                            snapshot.data!.docs[index].get("loadCapacity"),
                          );
                        },
                      );
                    },
                  ),
                ),
                buildTitle("Popular services")
                    .paddingOnly(top: 24.h, left: 25.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.to(AddOrderScreen());
                      },
                      child: buildPopularServices(
                          "Part Truck Load",
                          "Opt for our cost-effective and Shared Truck Service",
                          "assets/TRUCK_LOAD.png"),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(AddOrderScreen());
                      },
                      child: buildPopularServices(
                          "Multi Pickup & drop",
                          "Schedule multiple pickups in one trip",
                          "assets/MULTI_DROP.png"),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(()=>TrackOrderScreen());
                      },
                      child: buildPopularServices(
                          "Track Parcel",
                          "Check the real-time status of your package",
                          "assets/TRACK.png"),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(AddOrderScreen());
                      },
                      child: buildPopularServices(
                          "Schedule Pickup",
                          "Set the timings for your parcel pickup & delivery",
                          "assets/SCHEDULE.png"),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [buildTitle("Recent bookings"), buildSeeAll(() {})],
                ).paddingOnly(top: 24.h, left: 25.w, bottom: 15.h, right: 30.w),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('customers').doc("0000000000").collection("orders").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No bookings available."));
                    }

                    final orderDocs = snapshot.data!.docs;

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: orderDocs.length,
                      itemBuilder: (context, index) {
                        // Get order data from Firestore
                        final orderData = orderDocs[index].data() as Map<String, dynamic>;
                        final orderId = orderData['id'] ?? 'Unknown ID';
                        final distance = orderData['distance'].toString();
                        final cashAlloted = orderData['cashAlloted'].toString();
                        final price = orderData['price'].toString(); // Assuming price is stored in Firestore
                        final timestamp = orderData['timestamp'] as Timestamp? ?? Timestamp.now();
                        final time = TimeOfDay.fromDateTime(timestamp.toDate()).format(context);
                        final date = "${timestamp.toDate().day} ${_getMonthName(timestamp.toDate().month)} ${timestamp.toDate().year}";


                        // Call your buildRecentBookings widget
                        return buildRecentBookings(
                          "#ID $orderId",
                          distance,
                         "1",
                          cashAlloted,
                          time,
                          date,
                        );
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  String _getMonthName(int monthNumber) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[monthNumber - 1];
  }
  Widget buildAdSection(List<String> images) => SizedBox(
    width: 410,
    height: 100,
    child:Image.asset(images[0]),
  );
  Widget buildSeeAll(Function() onTapped) => Text(
        "See All",
        style: TextStyle(
            fontSize: 12.sp,
            color: ColorConstants.textColor,
            decoration: TextDecoration.underline),
      );
  Widget buildPopularServices(
          String title, String subTitle, String assetPath) =>
      Container(
        decoration: BoxDecoration(
            color: ColorConstants.bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorConstants.borderColor)),
        margin: EdgeInsets.only(left: 15.w, top: 10.h, right: 15.w),
        padding:
            EdgeInsets.only(left: 14.w, right: 24.w, top: 14.h, bottom: 14.h),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                assetPath,
                width: 28.w,
                height: 28.h,
              ).paddingOnly(right: 12.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorConstants.blackColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      subTitle,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 10.sp, color: ColorConstants.textColor),
                    )
                  ],
                ),
              )
            ]),
      );
  Widget buildRecentBookings(String orderId, String weight, String items,
          String amount, String time, String date) =>
      Container(
        margin: EdgeInsets.only(left: 18.w, right: 25.w,top: 10.h,bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstants.blackColor,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "$weight Kgs• $items items",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorConstants.textColor,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹$amount",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstants.blackColor,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "$time• $date",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorConstants.textColor,
                  ),
                )
              ],
            )
          ],
        ),
      );
  Widget buildVehicleContainer(String name, String assetPath, String quantity) {
    return CustomPaint(
      painter: GradientBorderPainter(),
      child: Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: ColorConstants.bgColor,
        ),
        padding: EdgeInsets.only(
            top: 16.h, left: 13.w, bottom: 7.h), // Adjusted without w and h
        width: 127.w, // Adjusted without w
        height: 191.h, // Adjusted without h
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
            ),
            Text(
              "Load Capacity:",
              style:
                  TextStyle(fontSize: 12.sp, color: ColorConstants.textColor),
            ),
            Text(
              quantity,
              style: TextStyle(
                  fontSize: 12.sp, color: ColorConstants.fontLightColor),
            ),
            Image.network(assetPath).paddingOnly(top: 20.h, left: 33.w)
          ],
        ),
      ),
    ).paddingOnly(
      left: 18.w,
      top: 17.h,
    );
  }

  Widget buildCta(String name, String assetsPath, Function() onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: ColorConstants.bgColor,
              borderRadius: BorderRadius.circular(10)),
          width: 99.w,
          height: 87.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                assetsPath,
                width: 28.w,
                height: 28.h,
              ),
              Text(
                name,
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      );
  Widget buildTitle(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 14.sp,
            color: ColorConstants.blackColor,
            fontWeight: FontWeight.w500),
      );
  // Widget buildAdSection(List<String> images) => CarouselSlider.builder(
  //     itemCount: 2,
  //     itemBuilder: (ctx, idx, id) {
  //       return Container(
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             image: DecorationImage(
  //                 image: AssetImage(
  //                   images[idx],
  //                 ),
  //                 fit: BoxFit.cover)),
  //       );
  //     },
  //     options: CarouselOptions(
  //         autoPlayAnimationDuration: Durations.medium3,
  //         viewportFraction: 0.9,
  //         aspectRatio: 21 / 5,
  //         enlargeCenterPage: true,
  //         autoPlay: true));
  Widget buildName(String name) => Text(
        name,
        style: TextStyle(
            fontSize: 22.sp,
            color: ColorConstants.blackColor,
            fontWeight: FontWeight.w700),
      );

  Widget buildPickupLocation(String location) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/LOCATION_PIN.png")
                      .paddingOnly(right: 5.w),
                  Text(
                    "Pickup Location",
                    style: TextStyle(
                        fontSize: 12.sp, color: ColorConstants.blackColor),
                  ),
                ],
              ),
              Text(
                location,
                style:
                    TextStyle(fontSize: 12.sp, color: ColorConstants.textColor),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          Image.asset(
            "assets/BELL_ICON.png",
            width: 18.1.w,
            height: 21.h,
          ).paddingOnly(right: 14.w),
        ],
      );
}
Future<String> getCurrentAddress() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return 'Location services are disabled.';
  }

  // Check for location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return 'Location permissions are denied';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return 'Location permissions are permanently denied.';
  }

  // Get the current position (latitude and longitude)
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  try {
    // Use the latitude and longitude to get the address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Get the first result
    Placemark place = placemarks[0];

    // Construct the address from the placemark details
    String address =
        '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';

    return address;
  } catch (e) {
    return 'Failed to get address: $e';
  }
}
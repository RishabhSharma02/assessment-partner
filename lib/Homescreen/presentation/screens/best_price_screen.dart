import 'package:bhaada_customer_app/Common%20Widgets/common_widgets.dart';
import 'package:bhaada_customer_app/Constants/color_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BestPriceScreen extends StatelessWidget {
  final double weight;
  final int packages;
  final int stops;
  final double startPrice;
  final String bestVehicleType;
  const BestPriceScreen({super.key, required this.weight, required this.packages, required this.stops, required this.startPrice, required this.bestVehicleType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      appBar: buildCommonAppbar("Check rates", true, true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBestContainer(bestVehicleType, weight,packages.toDouble(), stops.toDouble(),startPrice,startPrice+300),
          buildTitle("Want to book another vehicle?").paddingOnly(top: 40.h,left: 21.w),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('vehicles').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                height: 322.h,
                width: 360.w,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return buildOptions(
                      snapshot.data!.docs[index].get("imgUrl"),
                      snapshot.data!.docs[index].get("name"),

                      snapshot.data!.docs[index].get("loadCapacity"),
                      startPrice.toInt()+index*300
                    );
                  },
                ),
              );
            },
          ),


        ],
      ),
    );
  }

  Widget buildOptions(String imagePath,String type,String capacity,int price) => Container(
    margin: EdgeInsets.only(left: 21.w,right: 21.w,top: 15.h),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          border: Border.all(
            color: ColorConstants.lightGreyColor,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Image.network(
            imagePath,
            width: 48.w,
            height: 36.h,
          ),
        SizedBox(width: 20.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  type,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorConstants.textColor,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                capacity,
                style:
                    TextStyle(fontSize: 12.sp, color: ColorConstants.hintColor),
              )
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("₹$price",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorConstants.textColor,
                    fontWeight: FontWeight.w600),
              ),
              Text("₹${price+1000}",
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
          double packages, double stops, double lowPrice, double highPrice) =>
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
                buildCommonButton(() {}, "Book @ ₹${lowPrice.toStringAsFixed(0)} - ₹${highPrice.toStringAsFixed(0)} ", true)
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
  Widget buildTitle(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 14.sp,
            color: ColorConstants.blackColor,
            fontWeight: FontWeight.w500),
      );
}

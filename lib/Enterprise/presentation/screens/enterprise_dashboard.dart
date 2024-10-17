import 'package:bhaada_customer_app/Common%20Widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Constants/color_constants.dart';
import '../../controllers/enterprise_controller.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});
  EnterpriseController enterpriseController=Get.put(EnterpriseController());
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      appBar: buildCommonAppbar("Dashboard", true, true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          buildTitle("Orders").paddingOnly(top: 10.h, left: 25.w),
          buildActionsRequired(),
          buildTitle("Shipment Metrics")
              .paddingOnly(left: 25.w, bottom: 10.h),
          ShipmentBarGraph(),
        ],),
      ),
    );
  }
  Widget buildTitle(String title) => Text(
    title,
    style: TextStyle(
        fontSize: 14.sp,
        color: ColorConstants.blackColor,
        fontWeight: FontWeight.w500),
  );
  Widget buildActionsRequired() => Container(
    margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
    decoration: BoxDecoration(
        color: ColorConstants.bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: ColorConstants.lightGreyColor,
            blurRadius: 10.0,
          ),
        ]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: ColorConstants.greenColor.shade50,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "Today's Orders",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    enterpriseController.totalOrders.toString(),
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "Yesterday's Orders",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    "0",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
        ),
        buildActions( enterpriseController.totalOrders, "Total Orders", "All orders made by seller", false),
        buildActions( enterpriseController.cancelled, "Cancelled Orders",
            "Cancelled and cancellation request orders", false),
        buildActions( 30, "Total Freight Charges",
            "Total freight charges of the orders", true),
        buildActions( enterpriseController.avgCost.toInt(), "Average Shipping Cost",
            "Sum of all non-cancelled AWB/total non-cancelled AWB", true),
      ],
    ),
  );
  Widget buildActions(
      int amount, String titleText, String desc, bool isPrice) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: TextStyle(
                      fontSize: 14.sp, color: ColorConstants.blackColor),
                ),
                Text(
                  desc,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12.sp, color: ColorConstants.textColor),
                ),
                const Divider(
                  color: ColorConstants.dividerColor,
                ),
              ],
            ),
          ),
          Text(
            isPrice ? "₹$amount" : amount.toString(),
            style: TextStyle(
                fontSize: 14.sp,
                color: ColorConstants.blackColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ).paddingSymmetric(horizontal: 10.w);
}

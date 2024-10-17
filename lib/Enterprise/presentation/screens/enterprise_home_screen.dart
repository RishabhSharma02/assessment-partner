import 'package:bhaada_customer_app/Common%20Widgets/common_widgets.dart';
import 'package:bhaada_customer_app/Constants/color_constants.dart';
import 'package:bhaada_customer_app/Enterprise/controllers/enterprise_controller.dart';
import 'package:bhaada_customer_app/Enterprise/presentation/screens/enterprise_dashboard.dart';
import 'package:bhaada_customer_app/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EnterpriseHomeScreen extends StatelessWidget {
  EnterpriseHomeScreen({super.key});
  EnterpriseController enterpriseController=Get.put(EnterpriseController());
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
                  stops: [0.0, 0.7],
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
                  buildPickupLocation("Dlf Capital Greens, Moti Nagar,")
                      .paddingOnly(left: 25.w, top: 51.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildName("Hi, Testing!")
                          .paddingOnly(top: 49.h, left: 25.w),
                      const Spacer(),
                      buildEditionType().paddingOnly(top: 49.h, right: 25.w),
                    ],
                  ),
                  buildAdSection(["assets/AD.png", "assets/AD.png"]).paddingOnly(top: 26.h),
                  buildTitle("Available Fleet")
                      .paddingOnly(top: 33.h, left: 25.w),
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
                ],
              ),
            ])),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCtsContainer(12, "In Transit"),
                buildCtsContainer(12, "RTO"),
                buildCtsContainer(12, "Picked-Up"),
              ],
            ).paddingOnly(top: 10.h),
            buildCommonButton((){Get.to(()=>Dashboard());}, 'View More', true).paddingOnly(left: 25.w,top: 25.h)
          ],
        ),
      ),
    );
  }

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
  Widget buildAdSection(List<String> images) => SizedBox(
    width: 410,
    height: 100,
    child:Image.asset(images[0]),
  );
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
  Widget buildEditionType() => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Icon(Icons.work_outline).paddingOnly(right: 8.w),
          Text(
            "ADMIN",
            style: TextStyle(fontSize: 12.sp, color: ColorConstants.blackColor),
          ),
        ],
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
                        "0",
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
            buildActions(5, "Total Orders", "All orders made by seller", false),
            buildActions(5, "Cancelled Orders",
                "Cancelled and cancellation request orders", false),
            buildActions(5, "Total Freight Charges",
                "Total freight charges of the orders", true),
            buildActions(5, "Average Shipping Cost",
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
  Widget buildCtsContainer(int cts, String title) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              cts.toString(),
              style:
                  TextStyle(fontSize: 24.sp, color: ColorConstants.textColor),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  border: BorderDirectional(
                      top: BorderSide(color: ColorConstants.borderColor))),
              width: 75.w,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: ColorConstants.textColor, fontSize: 12.sp),
              ),
            )
          ],
        ),
      );
}

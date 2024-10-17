import 'package:bhaada_customer_app/Constants/color_constants.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/controllers/home_controller.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/detail_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Common Widgets/common_widgets.dart';

class TrackOrderScreen extends StatelessWidget {
  TrackOrderScreen({super.key});
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      appBar: buildCommonAppbar("Track Order", false, true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle("Tracking ID")
              .paddingOnly(top: 30.h, left: 21.w, right: 17.w),
          buildNameTextfield(idController, "Enter tracking ID")
              .paddingOnly(top: 16.h, left: 21.w, right: 17.w),
          Obx(
            () => buildCommonButton(() {
              homeScreenController.searchDocument(
                  "orders", "id", idController.text);
            },
                    homeScreenController.isSearching.value
                        ? "Loading..Please Wait"
                        : "Search",
                    true)
                .paddingOnly(top: 16.h, left: 21.w, right: 17.w),
          ),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemBuilder: (c, i) {
                return GestureDetector(
                  onTap: (){
                    Get.to( OrderDetailsScreen(orderId: homeScreenController.foundDocs[i].id,));
                  },
                  child: buildOrderTile(
                      homeScreenController.foundDocs[i].get("id"),
                      homeScreenController.foundDocs[i]
                          .get("timestamp")
                          .toDate()
                          .toString(),
                      homeScreenController.foundDocs[i].get("status")),
                );
              },
              itemCount: homeScreenController.foundDocs.value.length,
            ),
          )

        ],
      ),
    );
  }

  Widget buildOrderTile(String orderId, String timeStamp, String status) =>
      Padding(
        padding: const EdgeInsets.all(25),
        child: ListTile(
          title: Text(
            orderId,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(timeStamp),
          trailing: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color:status=="PENDING"? Colors.amber : status=="IN TRANSIT"||status=="COMPLETED"?Colors.green:Colors.red ),
            child: Text(
              status,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: ColorConstants.borderColor)),
        ),
      );
  Widget buildTitle(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 14.sp,
            color: ColorConstants.blackColor,
            fontWeight: FontWeight.w600),
      );
}

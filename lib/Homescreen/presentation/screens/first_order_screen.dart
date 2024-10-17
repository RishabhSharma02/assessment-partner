import 'package:bhaada_customer_app/Homescreen/presentation/controllers/home_controller.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/place_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Common Widgets/common_widgets.dart';
import '../../../Constants/color_constants.dart';

class FirstOrderScreen extends StatelessWidget {
  FirstOrderScreen({super.key});
 int cts=0;
 var endPts='A';
 HomeScreenController homeScreenController=Get.put(HomeScreenController());


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildOrderRoute(context).paddingOnly(left: 21.w),
          buildTitle("Pickup Address").paddingOnly(left: 21.w, top: 25.h),
          buildEntryBox("Mukund", "A", "1134 Dlf Capital Greens, Moti Nagar, Karam", true),
          buildTitle("Delivery Address").paddingOnly(left: 21.w, top: 20.h),
          buildEntryBox("Mukund", "B", "1134 Dlf Capital Greens, Moti Nagar, Karam", false)
        ],
      ),
    );
  }

  Widget buildEntryBox(
          String name, String locationTag, String location, bool isNameAdded) =>
      Container(
        margin: EdgeInsets.only(left: 21.w, right: 17.w, top: 14.h),
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 19.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorConstants.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !isNameAdded
                      ? Text(
                          'Enter senders details',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorConstants.extraLightTextColor),
                        )
                      : Row(
                        children: [
                          Text(name,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstants.btnColor)),
                          Icon(Icons.edit,color: ColorConstants.btnColor,size: 15.sp).paddingOnly(left: 8.w)
                        ],
                      ),
                  Text(
                    'Location $locationTag • $location',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.extraExtraLightTextColor),
                  ),
                  if(isNameAdded)
                  const Divider(color: ColorConstants.dividerColor,),
                  if(isNameAdded)
                    Row(
                    mainAxisAlignment: MainAxisAlignment.end  ,
                    children: [
                      const Icon(Icons.phone_outlined,color: ColorConstants.btnColor,).paddingOnly(right: 8.w),
                      Text(
                        '+91 920101011',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.extraExtraLightTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      );
  Widget buildTitle(String title) => Text(
        title,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
      );
  Widget buildOrderRoute(BuildContext context) => Obx(()=>
   Container(
          width: 322.w,
          height: 270.h,
          decoration: BoxDecoration(
              color: ColorConstants.lightGreyColor,
              borderRadius: BorderRadius.circular(10)),
          padding:
              EdgeInsets.only(left: 19.w, top: 12.h, right: 15.w, bottom: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: (){

                },
                child: Text(
                  "Order route",
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),

              // const Spacer(),
              buildStartRoute("A",homeScreenController.selectedLocations.length>1?homeScreenController.selectedLocations[0]:"Select Location",() {
                Get.to(()=>LocationPickerScreen());

              },(){

              }).paddingOnly(top: 20.h),
              //
              buildEndRoute("B",homeScreenController.selectedLocations.length>=2?homeScreenController.selectedLocations[homeScreenController.selectedLocations.length-1]:"Select Location" ,() {
                Get.to(()=>LocationPickerScreen());

              })
            ],
          ),
        ),
  );
  Widget buildLocationContent(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Pickup Address',
                style: TextStyle(
                    fontSize: 16.sp, color: ColorConstants.blackColor),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: 25.sp,
                  color: ColorConstants.blackColor,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 15.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: ColorConstants.timeLineColor.withOpacity(0.25)),
            child: Row(
              children: [
                Image.asset("assets/LOCATION_ICON.png"),
                Text(
                  "Select new address",
                  style: TextStyle(
                      fontSize: 16.sp, color: ColorConstants.btnColor),
                ).paddingOnly(left: 14.5.w),
              ],
            ),
          ).paddingOnly(top: 21.h, bottom: 24.h),
          Expanded(
            child: ListView.builder(
              itemBuilder: (c, i) {
                return GestureDetector(
                  onTap: (){
                    if(i==0){
                      homeScreenController. startAdd.value="1134 Dlf Capital Greens, Moti Nagar, Karampur Delhi - 1250001";
                    }
                    else if(i==1){
                   homeScreenController. midAdd.value="CP, Delhi - 1250001";
                    }
                    else{
                     homeScreenController. destAdd.value="India Gate, Karampur Delhi - 1250001";
                    }

                  },
                  child: buildAddress("Nanda",
                      "1134 Dlf Capital Greens, Moti Nagar, Karampur Delhi - 1250001"),
                );
              },
              itemCount: 3,
            ),
          )
        ],
      );
  Widget buildAddress(String name, String address) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 7.h,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 17.sp, color: ColorConstants.blackColor),
          ),
          Text(
            address,
            maxLines: 3,
            style: TextStyle(fontSize: 12.sp, color: ColorConstants.textColor),
          ).paddingOnly(top: 7.h),
          SizedBox(
            height: 7.h,
          ),
          const Divider(
            color: ColorConstants.dividerColor,
          )
        ],
      );
}

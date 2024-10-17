
import 'package:bhaada_customer_app/Common%20Widgets/common_widgets.dart';
import 'package:bhaada_customer_app/Constants/color_constants.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/controllers/home_controller.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/first_order_screen.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/second_order_screen.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/third_order_screen.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class AddOrderScreen extends StatelessWidget {
  AddOrderScreen({super.key});
  RxInt idx=0.obs;
  PageController pageController = PageController();
  HomeScreenController homeScreenController=Get.put(HomeScreenController());
  @override
  Widget build(BuildContext context) {

    return Obx(()=> Scaffold(
      bottomNavigationBar: buildCommonButton((){
        idx.value++;
        if(idx.value==2){
          homeScreenController.calculateFare();

        }
        pageController.animateToPage(idx.value,
            duration: Durations.medium1, curve: Curves.easeInOut);
      }, "Next Step", true).paddingSymmetric(horizontal: 12.w,vertical: 24.h),
        backgroundColor: ColorConstants.bgColor,
        appBar: buildCommonAppbar("Add Order", true, true),
        body: Column(
          children: [

          buildStepperWidget(idx.value,(idx){}).paddingOnly(top: 10.h),
            Flexible(
              flex: 1,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                padEnds: false,
                controller: pageController,
                children:[FirstOrderScreen(),SecondOrderScreen(),ThirdOrderScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildStepperWidget(int currIdx,Function(int) onDone)=>EasyStepper(
    padding: EdgeInsets.zero,
      activeStep: currIdx,
      disableScroll: true,
      finishedStepBackgroundColor: ColorConstants.btnColor,
      activeStepBackgroundColor: ColorConstants.btnColor,
      activeStepTextColor: Colors.black87,

      fitWidth: true,
      lineStyle: LineStyle(
          lineType: LineType.normal,
          lineLength: 81.6.w,
          unreachedLineColor: ColorConstants.lightGreyColor,
          activeLineColor:  ColorConstants.lightGreyColor,
          finishedLineColor: ColorConstants.btnColor,

          lineThickness: 2),
      finishedStepBorderType: BorderType.normal,
      finishedStepTextColor: Colors.black87,
      showLoadingAnimation: true,
      stepRadius: 20,
      showStepBorder: true,
      steppingEnabled: true,
      steps: [
        EasyStep(
          customStep: Text(
            "1",
            style: TextStyle(
                color: ColorConstants.bgColor, fontSize: 14.sp),
          ),
        ),
        EasyStep(

          customStep: Text(
            "2",
            style: TextStyle(
                color: ColorConstants.bgColor, fontSize: 14.sp),
          ),
        ),
        EasyStep(
          customStep: Text(
            "3",
            style: TextStyle(
                color: ColorConstants.bgColor, fontSize: 14.sp),
          ),
        ),
      ],
      onStepReached:onDone
    // setState(() => activeStep = index),
  );
}

import 'package:bhaada_customer_app/Constants/color_constants.dart';
import 'package:bhaada_customer_app/Enterprise/presentation/screens/enterprise_home_screen.dart';
import 'package:bhaada_customer_app/Enterprise/presentation/screens/enterprise_nav_screen.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/nav_screen.dart';
import 'package:bhaada_customer_app/Onboarding/presentation/controllers/onboarding_controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Common Widgets/common_widgets.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  OnboardingController onboardingController=Get.put(OnboardingController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.bgColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleText("Enter your\nmobile number")
                .paddingOnly(top: 60.h, left: 25.w),
            buildSubtitleText(
                    "We will send you an OTP via SMS to confirm your mobile number")
                .paddingOnly(top: 13.h, left: 25.w, right: 25.w),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCountryPicker(),
                  SizedBox(width: 5.w),
                  buildPhoneTextfield(_phoneController,
                      "Enter Mobile Number", () async {}),
                ]).paddingOnly(top: 13.h, left: 25.w),
            buildNameTextfield(_nameController, "Enter your name").paddingOnly(top: 13.h, left: 25.w),
            buildCommonButton(() {
              Get.to(const EnterpriseNavScreen());
            }, "Admin Login", true)
                .paddingOnly(top: 310.h, left: 25.w, right: 25.w),
            buildCommonButton(() {
             _sendOtp();
            }, "Login", true)
                .paddingOnly(top: 10.h, left: 25.w, right: 25.w)
          ],
        ),
      ),
    );
  }
  void _sendOtp() async {
    if(_phoneController.value.text=="0000000000"){
      Get.to(NavScreen());
    }
    else{
      Get.showSnackbar(const GetSnackBar(message: "Please check your details!",duration: Duration(seconds: 2),backgroundColor: Colors.red,));
    }

    // String phone = _phoneController.text.trim();
    //
    // if (phone.isEmpty || phone.length < 10) {
    //   print("Please enter a valid phone number");
    //   return;
    // }
    //
    // await _auth.verifyPhoneNumber(
    //   phoneNumber: '+91 $phone', // Add country code before number
    //   verificationCompleted: (PhoneAuthCredential credential) async {
    //     await _auth.signInWithCredential(credential);
    //     // Handle automatic OTP verification and sign-in if completed
    //   },
    //   verificationFailed: (FirebaseAuthException e) {
    //     // Handle verification failure
    //     print("Verification Failed: ${e.message}");
    //   },
    //   codeSent: (String verificationId, int? resendToken) {
    //     onboardingController.phoneNumber.value=_phoneController.value.text;
    //     onboardingController.userName.value=_nameController.value.text;
    //     Get.to(() => OtpScreen(
    //       verificationId: verificationId,
    //       resendToken: resendToken!,
    //       phoneNumber: _phoneController.value.text,
    //     ));
    //   },
    //   codeAutoRetrievalTimeout: (String verificationId) {
    //     // Handle timeout scenario
    //   },
    // );
  }
  Widget buildTitleText(String text) => Text(
        text,
        maxLines: 2,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26.sp,
            color: ColorConstants.textColor),
      );
  Widget buildSubtitleText(String text) => Text(
        text,
        maxLines: 2,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 14.sp, color: ColorConstants.textColor),
      );
}

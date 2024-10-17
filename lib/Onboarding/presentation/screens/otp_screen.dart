import 'dart:async';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/nav_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../Constants/color_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final int? resendToken;
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.resendToken,
    required this.phoneNumber,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isResendEnabled = false;
  int _resendCooldown = 30; // Cooldown in seconds
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  void _startResendCooldown() {
    setState(() {
      _isResendEnabled = false;
      _resendCooldown = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown > 0) {
        setState(() {
          _resendCooldown--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  void _verifyOTP() async {
    String smsCode = _otpController.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: smsCode,
    );

    try {
      // Sign in the user
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to the main screen
      Get.offAll(() => NavScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  void _resendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      forceResendingToken: widget.resendToken,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resend failed. Error: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent successfully.')),
        );
        setState(() {
          verificationId = verificationId;
          resendToken = resendToken;
        });
        _startResendCooldown();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitleText("Verify your number").paddingOnly(top: 60.h),
              buildSubtitleText(
                  "We’ve sent a verification code to the number below")
                  .paddingOnly(top: 13.h),
              Row(
                children: [
                  buildPhoneNumber(widget.phoneNumber),
                  IconButton(
                    icon: Icon(Icons.edit, size: 20.sp),
                    onPressed: () {
                      // Navigate back to phone number input screen
                      Get.back();
                    },
                  ),
                ],
              ).paddingOnly(top: 13.h),
              Pinput(
                controller: _otpController,
                length: 6,
                obscureText: false,
                onCompleted: (val) {
                  _verifyOTP();
                },
                animationDuration: const Duration(milliseconds: 200),
                defaultPinTheme: PinTheme(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorConstants.borderColor),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    color: ColorConstants.textColor,
                  ),
                  width: 45.5.w,
                  height: 48.h,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                ),
              ).paddingOnly(top: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _isResendEnabled ? _resendOTP : null,
                    child: Text(
                      _isResendEnabled
                          ? 'Resend OTP'
                          : 'Resend in $_resendCooldown s',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _verifyOTP,
                    child: const Text('Verify'),
                  ),
                ],
              ).paddingOnly(top: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPhoneNumber(String text) => Text(
    text,
    maxLines: 2,
    textAlign: TextAlign.left,
    style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.sp,
        color: ColorConstants.textColor),
  );

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

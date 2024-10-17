import 'dart:io';

import 'package:bhaada_customer_app/Homescreen/presentation/controllers/home_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Common Widgets/common_widgets.dart';
import '../../../Constants/color_constants.dart';

class SecondOrderScreen extends StatefulWidget {
  const SecondOrderScreen({super.key});

  @override
  State<SecondOrderScreen> createState() => _SecondOrderScreenState();
}

class _SecondOrderScreenState extends State<SecondOrderScreen> {
  HomeScreenController homeScreenController=Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        buildTitle("Package Details").paddingOnly(left: 18.w),
          buildAddressContainer(),
          buildTextfield(homeScreenController. numPackagesController.value,"Total Number of packages").paddingOnly(left: 21.w,right: 17.w),
          buildWeightField(homeScreenController. weightController.value,"Approximate total weight").paddingOnly(top: 16.h,left: 21.w,right: 17.w),
          buildUploadPhoto(),
          buildTitle("Please specify the size of the largest package among all the packages you are sending.").paddingOnly(left: 18.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildWeightContainer("Length", homeScreenController. lengthController.value, "Length"),
              Icon(Icons.close,size: 20.sp,).paddingOnly(top: 25.h),
              buildWeightContainer("Width", homeScreenController. widthController.value, "Width"),
              Icon(Icons.close,size: 20.sp,).paddingOnly(top: 25.h),
              buildWeightContainer("Height", homeScreenController. heightController.value, "Height"),

            ],
          ).paddingOnly(top: 16.h,left: 21.w,right: 17.w),

        ],
      ),
    );
  }

  File? _image;
 // File to hold the selected image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery); // You can also use ImageSource.camera for camera access

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the selected image
      });
    }
  }


  Widget buildUploadPhoto() => GestureDetector(
    onTap: _pickImage, // Trigger image picking when tapping the widget
    child: DottedBorder(
      borderType: BorderType.RRect,
      dashPattern: const [10, 3],
      radius: const Radius.circular(10),
      color: Colors.grey, // Replace with your ColorConstants.borderColor
      strokeWidth: 1,
      child: Container(
        width: double.infinity,
        height: 200, // Set a fixed height for the box
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: _image == null // Display the icon and text if no image is selected
            ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 45),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_a_photo_outlined).paddingOnly(right: 8),
              const Text(
                "Upload photo of items",
                style: TextStyle(fontSize: 14, color: Colors.grey), // Replace with your ColorConstants.textColor
              ),
            ],
          ),
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            _image!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover, // Ensure the image covers the entire container
          ),
        ),
      ),
    ).paddingSymmetric(horizontal: 18, vertical: 19),
  );

  Widget buildAddressContainer()=>  Container(
    margin: EdgeInsets.symmetric(horizontal: 18.w,vertical: 19.h),
    padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 15.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: ColorConstants.timeLineColor.withOpacity(0.25)),
    child: Text(
      "Pickup  •  Location A  •  1134 Dlf Capital Greens, Moti Nagar, Karamampur",
      style: TextStyle(
          fontSize: 12.sp, color: ColorConstants.btnColor),
    ).paddingOnly(left: 14.5.w),
  );

  Widget buildTitle(String title) => Text(
    title,
    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
  );
}

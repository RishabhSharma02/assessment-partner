import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../Constants/color_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget buildPhoneTextfield(TextEditingController phoneController,
        String hintText, Function() onTap) =>
    TextField(
      onTap: onTap,
      style: TextStyle(fontSize: 14.sp),
      cursorColor: ColorConstants.btnColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 10.48.w),
        constraints: BoxConstraints(maxHeight: 42.h, maxWidth: 215.w),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
        hintText: hintText,
        hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 14.sp),
        enabled: true,
        counterText: '',
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.borderColor,
            ),
            borderRadius: BorderRadius.circular(11)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.btnColor,
            ),
            borderRadius: BorderRadius.circular(11)),
      ),
      maxLength: 10,
      keyboardType: TextInputType.phone,
      controller: phoneController,
    );
Widget buildCommonButton(Function() onPressed, String btnText, bool isActive) =>
    MaterialButton(
      elevation: 0,
      onPressed: isActive ? onPressed : () {},
      height: 50.h,
      minWidth: 312.w,
      color: isActive ? ColorConstants.btnColor : ColorConstants.greyColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      child: Text(
        btnText,
        style: TextStyle(
            color: isActive
                ? ColorConstants.bgColor
                : ColorConstants.semiTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500),
      ),
    );

Widget buildDynamicButton(Function() onPressed, String btnText, Color btnColor,
        bool isBorder, Color bdrColor, Color txtColor) =>
    MaterialButton(
      onPressed: onPressed,
      height: 50.h,
      minWidth: 311.87.w,
      elevation: 0,
      color: btnColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
        side: isBorder ? BorderSide(color: bdrColor) : BorderSide.none,
      ),
      child: Text(
        btnText,
        style: TextStyle(
            color: isBorder ? txtColor : ColorConstants.bgColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500),
      ),
    );
Widget buildCountryPicker() => Container(
      height: 42.h,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          border: Border.all(color: ColorConstants.borderColor),
          borderRadius: BorderRadius.circular(11)),
      child: CountryCodePicker(
        showDropDownButton: false,
        padding: EdgeInsets.zero,
        hideMainText: false,
        initialSelection: 'IN',
        // Initial country selection (India in this case)
        showFlag: true,
        enabled: true,
        boxDecoration: BoxDecoration(
            border: Border.all(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
      ),
    );

Widget buildNavBar(Function(int) onChanged, int selectedIndex) => Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 10.h),
      width: 336.w,
      height: 76.h,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: ColorConstants.bgColor,
            spreadRadius: 40,
            blurRadius: 40,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(14),
        color: ColorConstants.bgColor,
        border: Border.all(color: ColorConstants.clickButtonColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconWithIndicator(
              "assets/HOME_ICON.png", selectedIndex == 0, () => onChanged(0)),
          _buildIconWithIndicator(
              "assets/SEARCH_ICON.png", selectedIndex == 1, () => onChanged(1)),
          GestureDetector(
            onTap: () => onChanged(2),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstants.btnColor,
              ),
              width: 52.w,
              height: 52.h,
              child: const Icon(
                Icons.add,
                color: ColorConstants.bgColor,
              ),
            ),
          ),
          _buildIconWithIndicator(
              "assets/HISTORY.png", selectedIndex == 3, () => onChanged(3)),
          _buildIconWithIndicator(
              "assets/PROFILE.png", selectedIndex == 4, () => onChanged(4)),
        ],
      ),
    );

Widget _buildIconWithIndicator(
    String imagePath, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          imagePath,
          width: 22.w,
          height: 22.h,
          color: isSelected
              ? ColorConstants.btnColor
              : ColorConstants.unselectedColor,
          fit: BoxFit.cover,
        ).paddingOnly(top: 25.h),
        if (isSelected)
          Image.asset(
            "assets/INDICATOR.png",
            fit: BoxFit.cover,
          ),
      ],
    ),
  );
}

PreferredSizeWidget buildCommonAppbar(String title, bool isHelp, bool isBack) =>
    AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: ColorConstants.bgColor,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: ColorConstants.textColor,
        ),
      ),
      titleSpacing: 0,
      leading: isBack
          ? GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: ColorConstants.blackColor,
              ))
          : null,
      actions: isHelp
          ? [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(129),
                    border: Border.all(
                        color: ColorConstants
                            .borderColor)), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.help_outline,
                      color: ColorConstants.btnColor,
                    ),
                    const SizedBox(
                        width: 5), // Add some space between icon and text
                    Text(
                      "Help",
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ).paddingOnly(right: 24.w),
            ]
          : null,
    );

class OrderRouteWidget extends StatefulWidget {
  const OrderRouteWidget({super.key});

  @override
  _OrderRouteWidgetState createState() => _OrderRouteWidgetState();
}

class _OrderRouteWidgetState extends State<OrderRouteWidget> {
  List<String> locations = [
    "Choose Pickup location via maps",
    "Choose Drop-off location via maps"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return LocationInput(
                  location: locations[index],
                  onRemove: () {
                    setState(() {
                      locations.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    locations.add("Choose location via maps");
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Location'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = size.width;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
Widget buildNameTextfield(TextEditingController textController, String hintText) =>
    TextField(
      style: TextStyle(fontSize: 14.sp),
      onChanged: (val) {
        textController.text = val;
      },
      cursorColor: ColorConstants.btnColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxHeight: 42.h, maxWidth: 312.w),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
        hintText: hintText,
        hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 14.sp),
        enabled: true,
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.btnColor,
            ),
            borderRadius: BorderRadius.circular(11)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.borderColor,
            ),
            borderRadius: BorderRadius.circular(11)),
      ),
      keyboardType: TextInputType.text,
    );
Widget buildTextfield(TextEditingController textController, String hintText) =>
    TextField(
      style: TextStyle(fontSize: 14.sp),
      onChanged: (val) {
        textController.text = val;
      },
      cursorColor: ColorConstants.btnColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxHeight: 42.h, maxWidth: 312.w),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
        hintText: hintText,
        hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 14.sp),
        enabled: true,
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.btnColor,
            ),
            borderRadius: BorderRadius.circular(11)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.borderColor,
            ),
            borderRadius: BorderRadius.circular(11)),
      ),
      keyboardType: TextInputType.number,
    );
Widget buildWeightField(
        TextEditingController textController, String hintText) =>
    TextField(
      style: TextStyle(fontSize: 14.sp),
      onChanged: (val) {
        textController.text = val;
      },
      cursorColor: ColorConstants.btnColor,
      decoration: InputDecoration(
        suffix: Text(
          "KG",
          style: TextStyle(color: ColorConstants.btnColor, fontSize: 14.sp),
        ),
        contentPadding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxHeight: 42.h, maxWidth: 312.w),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
        hintText: hintText,
        hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 14.sp),
        enabled: true,
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.btnColor,
            ),
            borderRadius: BorderRadius.circular(11)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.borderColor,
            ),
            borderRadius: BorderRadius.circular(11)),
      ),
      keyboardType: TextInputType.number,
    );
Widget buildWeightContainer(String titleText,
        TextEditingController textController, String hintText) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: TextStyle(fontSize: 13.sp, color: ColorConstants.textColor),
        ).paddingOnly(bottom: 10.h),

        TextField(
          style: TextStyle(fontSize: 14.sp),
          onChanged: (val) {
            textController.text = val;
          },
          cursorColor: ColorConstants.btnColor,
          decoration: InputDecoration(
            suffix: Text(
              "CM",
              style: TextStyle(color: ColorConstants.btnColor, fontSize: 14.sp),
            ),
            contentPadding: const EdgeInsets.all(10),
            constraints: BoxConstraints(maxHeight: 48.h, maxWidth: 90.w),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorConstants.borderColor),
                borderRadius: BorderRadius.circular(11)),
            hintText: hintText,
            hintStyle:
                TextStyle(color: ColorConstants.hintColor, fontSize: 14.sp),
            enabled: true,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: ColorConstants.btnColor,
                ),
                borderRadius: BorderRadius.circular(11)),
            border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: ColorConstants.borderColor,
                ),
                borderRadius: BorderRadius.circular(11)),
          ),
          keyboardType: TextInputType.number,
        )
      ],
    );
Widget buildStartRoute(String labelText, String bodyText,Function() onTap,Function() onAddMore) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: ColorConstants.greenColor,
              child: Text(labelText,
                  style:
                      TextStyle(color: ColorConstants.bgColor, fontSize: 9.sp)),
            ),
            CustomPaint(size: const Size(1, 50), painter: DashedLineVerticalPainter())
          ],
        ).paddingOnly(right: 16.w, top: 13.h),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.only(left: 10.w, top: 5.h),
                width: 246.w,
                height:50.h,
                decoration: BoxDecoration(
                    color: ColorConstants.bgColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  bodyText,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.extraLightTextColor,
                      fontSize: 13.sp),
                ),
              ),
            ),
            GestureDetector(
              onTap: onAddMore,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorConstants.bgColor),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 20.sp,
                    ),
                    Text(
                      "Add more",
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
              ).paddingOnly(top: 5.h),
            )
          ],
        )
      ],
    );
Widget buildEndRoute(String labelText,String bodyText, Function() onTap) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          children: [
            CustomPaint(
                size: const Size(1, 60), painter: DashedLineVerticalPainter()),
            CircleAvatar(
              radius: 10,
              backgroundColor: ColorConstants.redColor,
              child: Text(labelText,
                  style:
                      TextStyle(color: ColorConstants.bgColor, fontSize: 9.sp)),
            ).paddingOnly(bottom: 40.h),
          ],
        ).paddingOnly(right: 16.w),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap:onTap,
              child: Container(
                padding: EdgeInsets.only(left: 10.w, top: 5.h),
                width: 246.w,
                height: 50.h,
                decoration: BoxDecoration(
                    color: ColorConstants.bgColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  bodyText,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.extraLightTextColor,
                      fontSize: 13.sp),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorConstants.bgColor),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 20.sp,
                  ),
                  Text(
                    "Add more",
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ],
              ),
            ).paddingOnly(top: 5.h)
          ],
        ).paddingOnly(top: 20.h)
      ],
    );

class LocationInput extends StatelessWidget {
  final String location;
  final VoidCallback onRemove;

  const LocationInput({super.key, required this.location, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(location),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.red),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
class ShipmentBarGraph extends StatefulWidget {
  const ShipmentBarGraph({super.key});

  @override
  _ShipmentBarGraphState createState() => _ShipmentBarGraphState();
}

class _ShipmentBarGraphState extends State<ShipmentBarGraph> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
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

      child: AspectRatio(
        aspectRatio:1.3,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(),
                      swapAnimationDuration: animDuration,
                    ),
                  ),
                ),
               
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Indicator(color: ColorConstants.pickedUpColor, text: 'Picked Up'),
                    SizedBox(width: 4),
                    Indicator(color: ColorConstants.inTransitColor, text: 'In-Transit'),
                    SizedBox(width: 4),
                    Indicator(color: ColorConstants.deliveredColor, text: 'Delivered'),
                    SizedBox(width: 4),
                    Indicator(color: ColorConstants.ndrColor, text: 'NDR'),
                    SizedBox(width: 4),
                    Indicator(color: ColorConstants.rtoColor, text: 'RTO'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 15,
    List<int> showTooltips = const [],
  }) {
    barColor ??= ColorConstants.lightGreyColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.grey : barColor,
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.white, width: 2)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 5,
            color: ColorConstants.lightGreyColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(5, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 4, barColor: ColorConstants.pickedUpColor);
          case 1:
            return makeGroupData(1, 4, barColor: ColorConstants.inTransitColor);
          case 2:
            return makeGroupData(2, 3, barColor: ColorConstants.deliveredColor);
          case 3:
            return makeGroupData(3, 3, barColor: ColorConstants.ndrColor);
          case 4:
            return makeGroupData(4, 2, barColor: ColorConstants.rtoColor);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              'Value : ${rod.toY.toInt()}',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: true,drawHorizontalLine: true,drawVerticalLine: false,),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 9,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Picked Up', style: style);
        break;
      case 1:
        text = const Text('In-Transit', style: style);
        break;
      case 2:
        text = const Text('Delivered', style: style);
        break;
      case 3:
        text = const Text('NDR', style: style);
        break;
      case 4:
        text = const Text('RTO', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 16.w,
          height: 16.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 9.sp,
          ),
        ),
      ],
    );
  }
}


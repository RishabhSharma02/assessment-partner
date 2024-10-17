import 'package:bhaada_customer_app/Common%20Widgets/common_widgets.dart';
import 'package:bhaada_customer_app/Enterprise/presentation/screens/enterprise_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class EnterpriseNavScreen extends StatelessWidget {
  const EnterpriseNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
  RxInt currIdx = 0.obs;
  PageController pageController = PageController();

    return  Scaffold(
        body: PageView(
          controller: pageController,
          children:  [EnterpriseHomeScreen()],
        ),

      );

  }
  }

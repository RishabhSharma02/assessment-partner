import 'package:bhaada_customer_app/Common%20Widgets/common_widgets.dart';
import 'package:bhaada_customer_app/Enterprise/presentation/screens/enterprise_home_screen.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/home_screen.dart';
import 'package:bhaada_customer_app/Homescreen/presentation/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavScreen extends StatelessWidget {
  NavScreen({super.key});
  RxInt currIdx = 0.obs;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: PageView(
          controller: pageController,
          children: const [HomeScreen()],
        ),

      );

  }
}

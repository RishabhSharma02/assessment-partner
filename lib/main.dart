import 'package:bhaada_customer_app/Constants/color_constants.dart';
import 'package:bhaada_customer_app/Onboarding/presentation/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

import 'firebase_options.dart';
void main() async{
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: ColorConstants.bgColor,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness:
        Brightness.dark, // Dark icons for light backgrounds
    statusBarBrightness: Brightness.dark, // Light status bar
  ));
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    await Hive.initFlutter();
    await Hive.openBox('orderNumbersBox');
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme:
              GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme),
              useMaterial3: true,
            ),
            home: child,
          );
        },
        child: LoginScreen()
    );
  }
}



import 'package:beat_buddy/Views/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Res/constants.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: bgColor,
          useMaterial3: true,
          textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white,)
              .copyWith(
            bodyText1: const TextStyle(color: bodyTextColor),
            bodyText2: const TextStyle(color: bodyTextColor),
          ),
        ),

        home: const SplashView()
    );
  }
}



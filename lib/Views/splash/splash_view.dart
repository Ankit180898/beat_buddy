import 'dart:async';
import 'package:beat_buddy/Views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import '../../Res/constants.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}
class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/music.svg",),
          const SizedBox(height: defaultPadding/10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              'Welcome To BeatBuddy',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.black,
                  fontSize: 24,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: defaultPadding,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding ),
            child: Text(
              "Your ultimate companion for discovering, creating, and sharing music.",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, wordSpacing: 2, fontSize: 16,),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 3),
            child: GestureDetector(
              onTap: (){
                Get.offAll(HomeScreen(),curve: ElasticInOutCurve());
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(24)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Get Started',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.normal),
                      ),
                      Icon(Icons.arrow_circle_right,color: Colors.white,size: 32,)
                    ],
                  ),
                ),
              ),
            ),
          ),
          Spacer()

        ],
      )
    );
  }
}

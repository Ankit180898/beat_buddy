import 'dart:async';
import 'package:beat_buddy/Views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import '../../Res/constants.dart';
import '../demo_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: MediaQuery.of(context).size.height*0.60,width:MediaQuery.of(context).size.width,decoration:BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),bottomLeft:Radius.circular(100) ),
            color: Colors.black12
      ),child: ClipRRect(    borderRadius: BorderRadius.circular(100.0),
      child: Image.network("https://mir-s3-cdn-cf.behance.net/project_modules/fs/8e1029153848787.633b2511e65fb.gif",fit: BoxFit.cover,))),
          Spacer(),
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
                Get.offAll(DemoView(),curve: ElasticInOutCurve());
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../Controllers/player_controller.dart';
import 'package:beat_buddy/Res/constants.dart';

import '../Res/app_navigator.dart';

class DemoView extends StatelessWidget {
  const DemoView({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: AppNavigator(), // Replace HomeScreen() with AppNavigator()
        // Other widgets...
      ),
    );
  }
}

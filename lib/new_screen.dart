import 'package:beat_buddy/Controllers/player_controller.dart';
import 'package:beat_buddy/Res/constants.dart';
import 'package:beat_buddy/Views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // SvgPicture.asset("assets/music.svg"),
      buildMiniPlayer(controller, controller.playingIndex.value, context),
        ],
      ),
    );
  }
}

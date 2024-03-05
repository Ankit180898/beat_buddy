import 'package:beat_buddy/Res/constants.dart';
import 'package:beat_buddy/Views/albums/playlists_screen.dart';
import 'package:flutter/material.dart';
import 'package:beat_buddy/Controllers/player_controller.dart';
import 'package:beat_buddy/Views/home/home_screen.dart';
import 'package:get/get.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final controller = Get.put(PlayerController());
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    HomeScreen(),
    PlaylistsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensure _selectedIndex falls within the valid range
    _selectedIndex = _selectedIndex.clamp(0, _tabs.length - 1);

    return Scaffold(
      body: Obx(()=>
        Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _tabs,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: buildMiniPlayer(controller, controller.playingIndex.value, context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: secondaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Playlist',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

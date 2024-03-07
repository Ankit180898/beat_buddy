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
  var tapped=false.obs;
  final PageController _pageController = PageController();
  final List<Widget> _tabs = [
    HomeScreen(),
    PlaylistsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    tapped.value=true;
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure _selectedIndex falls within the valid range
    _selectedIndex = _selectedIndex.clamp(0, _tabs.length - 1);

    return Scaffold(
      body: Obx(()=>
        Stack(
          children: [
            PageView(
              controller: _pageController,
              children: _tabs,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
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
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex==0?Icon(Icons.home_filled,color: primaryColor,):Icon(Icons.home_outlined,color: primaryColor,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex==1?Icon(Icons.library_music,color: primaryColor,):Icon(Icons.library_music_outlined,color: primaryColor,),
            label: 'Playlist',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(
          color: primaryColor,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          color: primaryColor,
          fontSize: 12,
        ),
        unselectedItemColor: primaryColor,
      ),
    );
  }
}

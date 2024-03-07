import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/player_controller.dart';

class PlaylistsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Playlists'),
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.playlists.isEmpty) {
            return Center(
              child: Text('No playlists found'),
            );
          } else {
            return ListView.builder(
              itemCount: controller.playlists.length,
              itemBuilder: (context, index) {
                final playlist = controller.playlists[index];
                print("all playlists: ${playlist.name}");
                return ListTile(
                  title: Text(playlist.name), // Update this line
                  onTap: () {
                    // Implement the logic to handle playlist selection
                    // For example, you can navigate to a screen to show the songs in the selected playlist
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

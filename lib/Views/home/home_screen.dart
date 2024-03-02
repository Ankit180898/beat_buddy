import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../Controllers/player_controller.dart';
import 'package:beat_buddy/Res/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Obx(() => Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                var song = controller.playlist[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    color: darkColor,
                    child: ListTile(
                      leading: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note_rounded,
                          size: 32,
                        ),
                      ),
                      title: Text(
                        song.title ?? '',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: bodyTextColor,
                          letterSpacing: 1.2,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        song.artist ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey, wordSpacing: 2, fontSize: 16,),
                      ),
                      trailing: Obx(()=>
                        IconButton(
                          icon: controller.playingIndex.value == index && controller.isPlaying.value==true
                              ? const Icon(Icons.pause_rounded)
                              : const Icon(Icons.play_arrow_rounded),
                          onPressed: () {
                            if (controller.playingIndex.value == index && controller.isPlaying.value==true) {
                              controller.pauseSong();
                            } else {
                              controller.playSongs(song.uri, index);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: controller.playlist.length,
            ),
          ),
        ],
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../Controllers/player_controller.dart';
import 'package:beat_buddy/Res/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
        // appBar: AppBar(
        //   backgroundColor: Colors.black,
        // ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Stack(
              children: [
                ListView.builder(
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
                          onTap: () {
                            controller.playSongOrShuffle(index); // Play song or start shuffling
                          },
                          trailing: Obx(() =>
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
                Positioned(
                  right: 16,
                bottom: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    controller.shuffleMode.toggle(); // Toggle shuffle mode
                    if (controller.shuffleMode.value) {
                      controller.shuffleSongs(); // Start playing shuffled songs if shuffle mode is enabled
                    }
                  },
                  child: Icon(Icons.shuffle_rounded),
                ),),
                buildMiniPlayer(controller, controller.playingIndex.value, context),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget buildMiniPlayer(PlayerController controller, int index, BuildContext context) {
    var song = controller.playlist[index];
    return Miniplayer(
      backgroundColor: Colors.black,
      minHeight: MediaQuery.of(context).size.height*0.10,
      maxHeight: MediaQuery.of(context).size.height,
      builder: (height, percentage) {
        if (height <= MediaQuery.of(context).size.height*0.20) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(()=>
              Column(
                children: [
                  Row(
                    children: [
                      QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note_rounded,
                          size: 32,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title ?? '',
                              maxLines: 1,
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: bodyTextColor,
                                letterSpacing: 1.2,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              song.artist ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey, wordSpacing: 2, fontSize: 16,),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: controller.isPlaying.value ? const Icon(Icons.pause_rounded) : const Icon(Icons.play_arrow_rounded),
                        onPressed: () {
                          if (controller.isPlaying.value) {
                            controller.pauseSong();
                          } else {
                            controller.playSongs(song.uri, index);
                          }
                        },
                      ),

                    ],
                  ),
                     Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width - 100, // Adjust the width as needed
                      margin: EdgeInsets.symmetric(vertical: 8), // Add margin for positioning
                      child: Slider(
                        allowedInteraction: null,
                        value: controller.currentPosition.value.inSeconds.toDouble(),
                        min: 0,
                        max: controller.totalDuration.value.inSeconds.toDouble(),
                        onChanged: (value) {
                          // Seek to the specified position when slider value changes
                           controller.audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                        // onChangeEnd: (value) {
                        //   controller.audioPlayer.seek(Duration(seconds: value.toInt()));
                        // },
                      ),
                    ),

                ],
              ),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Obx(()=>
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Container(height: 200,width: 200,decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(24),
                      ),child: Icon(Icons.music_note_rounded,size: 100,)),
                    ),
                  ),
                  Text(song.title),
                  Text(song.artist.toString()),
                  Slider(
                    value: controller.currentPosition.value.inSeconds.toDouble(),
                    min: 0,
                    max: controller.totalDuration.value.inSeconds.toDouble(),
                    onChanged: (value) {},
                    onChangeEnd: (value) {
                      controller.audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous),
                        onPressed: () {
                          controller.playPreviousSong();
                        },
                      ),
                      IconButton(
                        icon: controller.isPlaying.value ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                        onPressed: () {
                          if (controller.isPlaying.value) {
                            controller.pauseSong();
                          } else {
                            controller.playSongs(song.uri, index);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        onPressed: () {
                          controller.playNextSong();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

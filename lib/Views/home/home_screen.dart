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
    var controller = Get.find<PlayerController>();

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
                Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(),
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50)),
                            child: Image.network(
                              "https://mir-s3-cdn-cf.behance.net/project_modules/fs/45532e153848787.633b3013a2043.gif",
                              fit: BoxFit.cover,
                            ))),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          var song = controller.playlist[index];
                          return ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: QueryArtworkWidget(
                                id: song.id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note_rounded,
                                  color: primaryColor,
                                  size: 32,
                                ),
                              ),
                            ),
                            title: Text(
                              song.title ?? '',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: primaryColor,
                                    letterSpacing: 1.2,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            subtitle: Text(
                              song.artist ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: bodyTextColor,
                                wordSpacing: 2,
                                fontSize: 16,
                              ),
                            ),
                            // onTap: () {
                            //   controller.playSongOrShuffle(
                            //       index); // Play song or start shuffling
                            // },
                            trailing: Obx(
                              () => IconButton(
                                icon: controller.playingIndex.value == index &&
                                        controller.isPlaying.value == true
                                    ? const Icon(
                                        Icons.pause_rounded,
                                        color: primaryColor,
                                      )
                                    : const Icon(
                                        Icons.play_arrow_rounded,
                                        color: primaryColor,
                                      ),
                                onPressed: () {
                                  if (controller.playingIndex.value == index &&
                                      controller.isPlaying.value == true) {
                                    controller.pauseSong();
                                  } else {
                                    controller.playSongs(song.uri, index);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          color: secondaryColor,
                        ), // Separator between items
                        itemCount: controller.playlist.length,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  left: 24,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0, bottom: 24.0),
                    child: Text(
                      'Device Songs',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: primaryColor,
                            letterSpacing: 1.2,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: MediaQuery.of(context).size.height * 0.12,
                  child: FloatingActionButton(
                    backgroundColor: primaryColor,
                    onPressed: () {
                      controller.shuffleMode.toggle(); // Toggle shuffle mode
                      if (controller.shuffleMode.value) {
                        controller
                            .shuffleSongs(); // Start playing shuffled songs if shuffle mode is enabled
                      }
                    },
                    child: Icon(
                      Icons.shuffle_rounded,
                      color: bgColor,
                    ),
                  ),
                ),
                buildMiniPlayer(
                    controller, controller.playingIndex.value, context),
              ],
            );
          }
        }),
      ),
    );
  }
}


Widget buildMiniPlayer(
    PlayerController controller, int index, BuildContext context) {
  if (controller.playlist.isEmpty) {
    // Handle empty playlist case
    return Container(
      height: 100,
      decoration: BoxDecoration(color: secondaryColor),
      child: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:const Icon(
                          Icons.music_note_rounded,
                          size: 32,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "None",
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(
                          color: primaryColor,
                          overflow: TextOverflow.fade,
                          letterSpacing: 1.2,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'None',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: bodyTextColor,
                          wordSpacing: 2,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: controller.isPlaying.value
                        ? const Icon(
                      Icons.pause_rounded,
                      color: primaryColor,
                    )
                        : const Icon(
                      Icons.play_arrow_rounded,
                      color: primaryColor,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.blue), // Color of the progress indicator// Calculate the progress value only if total duration is not zero
          ),
        ],
      ),
    );
  }else{
    var song = controller.playlist[index];
    return Miniplayer(
      onDismiss: null,
      onDismissed: null,
      elevation: 10.0,
      minHeight: MediaQuery.of(context).size.height * 0.10,
      maxHeight: MediaQuery.of(context).size.height,
      builder: (height, percentage) {
        if (height <= MediaQuery.of(context).size.height * 0.12) {
          return Obx(
                () => Container(
              decoration: BoxDecoration(color: secondaryColor),
              child: Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: QueryArtworkWidget(
                                id: song.id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note_rounded,
                                  size: 32,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title ?? '',
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                  color: primaryColor,
                                  overflow: TextOverflow.fade,
                                  letterSpacing: 1.2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                song.artist ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: bodyTextColor,
                                  wordSpacing: 2,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: controller.isPlaying.value
                                ? const Icon(
                              Icons.pause_rounded,
                              color: primaryColor,
                            )
                                : const Icon(
                              Icons.play_arrow_rounded,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              if (controller.isPlaying.value) {
                                controller.pauseSong();
                              } else {
                                controller.playSongs(song.uri, index);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue), // Color of the progress indicator
                    value: controller.totalDuration.value.inSeconds > 0
                        ? controller.currentPosition.value.inSeconds.toDouble() /
                        controller.totalDuration.value.inSeconds.toDouble()
                        : 0.0, // Calculate the progress value only if total duration is not zero
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            color: secondaryColor,
            child: SingleChildScrollView(
              child: Obx(
                    () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                size: 32, color: primaryColor),
                            onPressed: () {},
                          ),
                          Icon(
                            Icons.more_horiz_rounded,
                            size: 32,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: QueryArtworkWidget(
                              id: song.id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Builder(
                                builder: (context) {
                                  final iconSize = MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.5; // Adjust the size according to your needs
                                  return Icon(
                                    Icons.album_rounded,
                                    size: iconSize,
                                    color: secondaryColor,
                                  );
                                },
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        song.title ?? '',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: primaryColor,
                          overflow: TextOverflow.fade,
                          letterSpacing: 1.2,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        song.artist ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: bodyTextColor,
                          wordSpacing: 2,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Slider(
                          value: controller.currentPosition.value.inSeconds
                              .toDouble(),
                          min: 0,
                          max:
                          controller.totalDuration.value.inSeconds.toDouble(),
                          onChanged: (value) {},
                          onChangeEnd: (value) {
                            controller.audioPlayer
                                .seek(Duration(seconds: value.toInt()));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${controller.currentPosition.value.inMinutes}:${(controller.currentPosition.value.inSeconds % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(color: primaryColor),
                              ),
                              Text(
                                '${controller.totalDuration.value.inMinutes}:${(controller.totalDuration.value.inSeconds % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(color: primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            size: 48,
                            color: primaryColor,
                          ),
                          onPressed: () {
                            controller.playPreviousSong();
                          },
                        ),
                        IconButton(
                          icon: controller.isPlaying.value
                              ? Icon(
                            Icons.pause_circle_filled_rounded,
                            size: 64,
                            color: primaryColor,
                          )
                              : Icon(
                            Icons.play_circle_fill_rounded,
                            size: 64,
                            color: primaryColor,
                          ),
                          onPressed: () {
                            if (controller.isPlaying.value) {
                              controller.pauseSong();
                            } else {
                              controller.playSongs(song.uri, index);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.skip_next_rounded,
                            size: 48,
                            color: primaryColor,
                          ),
                          onPressed: () {
                            controller.playNextSong();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

}

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  var playlist = <SongModel>[].obs;
  final audioPlayer = AudioPlayer();
  var playingIndex = 0.obs;
  var isPlaying = false.obs;
  var isLoading = true.obs;
  var shuffleMode = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs; // Track total duration

  late StreamSubscription<Duration> _positionSubscription;

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
    fetchSongs();
    setupAudioPlayerListeners();

  }

  checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.audio,
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();
    if (statuses.values.every((status) => status.isGranted)) {
      return;
    } else {
      checkPermissions();
    }
  }

  void fetchSongs() async {
    isLoading.value = true;
    try {
      final songs = await audioQuery.querySongs(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: null,
        uriType: UriType.EXTERNAL,
      );
      playlist.clear();
      playlist.addAll(songs);
      isLoading.value = false;
      if (kDebugMode) {
        print("my songs: $playlist");
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  void playSongs(String? url, int index) {
    // Turn off shuffle mode if it's enabled
    if (shuffleMode.value) {
      shuffleMode.value = false;
    }

    playingIndex.value = index;
    try {
      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(url!),
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: '${playlist[index].id}',
            // Metadata to display in the notification:
            album: "${playlist[index].album}",
            title: playlist[index].displayNameWOExt,
            artUri: Uri.parse('${playlist[index].id}'),
          ),
        ),
      );
      audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      print(e.toString());
    }

    _positionSubscription = audioPlayer.positionStream.listen((position) {
      currentPosition.value = position;
    });

    // Get total duration when audio is loaded
    audioPlayer.durationStream.listen((duration) {
      totalDuration.value = duration ?? Duration.zero;
    });
  }

  pauseSong() {
    audioPlayer.pause();
    isPlaying.value = false;
  }

  void shuffleSongs() {
    playlist.value = playlist.toList()
      ..shuffle(Random());
    playingIndex.value = 0;
    playSongs(playlist[0].uri, 0);
    shuffleMode.value = true; // Set shuffle mode to true after shuffling
  }


  playSongOrShuffle(int index) {
    if (shuffleMode.value) {
      playShuffledSongs();
    } else {
      playSongs(playlist[index].uri, index);
    }
  }

  playShuffledSongs() {
    playlist.shuffle();
    playingIndex.value = 0;
    playSongs(playlist[playingIndex.value].uri, playingIndex.value);
  }

  void selectSong(int index) {
    playingIndex.value = index;
    shuffleMode.value = false;
    playSongs(playlist[index].uri, index);
  }
  void playPreviousSong() {
    int previousIndex = playingIndex.value - 1;
    if (previousIndex < 0) {
      previousIndex = playlist.length - 1; // Wrap around to the last song
    }
    playSongs(playlist[previousIndex].uri, previousIndex);
  }

  void playNextSong() {
    if (shuffleMode.value) {
      playShuffledSongs();
    } else {
      int nextIndex = playingIndex.value + 1;
      if (nextIndex < playlist.length) {
        selectSong(nextIndex);
      } else {
        // Reached the end of the playlist
        // You can handle this scenario based on your app's requirements
      }
    }
  }

  void setupAudioPlayerListeners() {
    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        playNextSong();
      }
    });
  }
}

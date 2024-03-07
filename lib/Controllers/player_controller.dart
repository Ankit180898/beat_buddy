import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/playlist_model.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  var songsList = <SongModel>[].obs;
  var playlists = <PlaylistsModel>[].obs;
  final audioPlayer = AudioPlayer();
  var playingIndex = 0.obs;
  var isPlaying = false.obs;
  var isLoading = true.obs;
  var shuffleMode = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs; // Track total duration

  late StreamSubscription<Duration> _positionSubscription;
  late Database _database;

  @override
  void onInit() async{
    super.onInit();
    checkPermissions();
    await _initDatabase(); // Wait for the database initialization to complete
    fetchSongs();
    fetchPlaylists();
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
      songsList.clear();
      songsList.addAll(songs);
      isLoading.value = false;
      if (kDebugMode) {
        print("my songs: $songsList");
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
    if (url == null) {
      // Show warning popup for invalid audio URL
      Get.dialog(
        AlertDialog(
          title: Text('Warning'),
          content: Text('Invalid audio URL'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    playingIndex.value = index;
    try {
      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(url!),
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: '${songsList[index].id}',
            // Metadata to display in the notification:
            album: "${songsList[index].album}",
            title: songsList[index].displayNameWOExt,
            artUri: Uri.parse('https://www.behance.net/gallery/192703743/From-This-cover-art-album-cover-music-cover-art/modules/1090107787'),
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
    songsList.value = songsList.toList()
      ..shuffle(Random());
    playingIndex.value = 0;
    playSongs(songsList[0].uri, 0);
    shuffleMode.value = true; // Set shuffle mode to true after shuffling
  }


  playSongOrShuffle(int index) {
    if (shuffleMode.value) {
      playShuffledSongs();
    } else {
      playSongs(songsList[index].uri, index);
    }
  }

  playShuffledSongs() {
    songsList.shuffle();
    playingIndex.value = 0;
    playSongs(songsList[playingIndex.value].uri, playingIndex.value);
  }

  void selectSong(int index) {
    playingIndex.value = index;
    shuffleMode.value = false;
    playSongs(songsList[index].uri, index);
  }
  void playPreviousSong() {
    int previousIndex = playingIndex.value - 1;
    if (previousIndex < 0) {
      previousIndex = songsList.length - 1; // Wrap around to the last song
    }
    playSongs(songsList[previousIndex].uri, previousIndex);
  }

  void playNextSong() {
    if (shuffleMode.value) {
      playShuffledSongs();
    } else {
      int nextIndex = playingIndex.value + 1;
      if (nextIndex < songsList.length) {
        selectSong(nextIndex);
      } else {
        // Reached the end of the songsList
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
  Future<void> _initDatabase() async {
    _database = await openDatabase(
      'playlist_database.db',
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE playlists(id INTEGER PRIMARY KEY, name TEXT)',
        );
      },
      version: 1,
    );
  }
  Future<List<PlaylistsModel>> fetchPlaylists() async {
    try {
      final List<Map<String, dynamic>> playlists = await _database.query('playlists');
      return List.generate(playlists.length, (i) {
        return PlaylistsModel(
          id: playlists[i]['id'],
          name: playlists[i]['name'],
        );
      });
    } catch (e) {
      print('Error fetching playlists: $e');
      return []; // Return an empty list if there's an error
    }
  }


  void addSongToPlaylist(int playlistId, int songId) async {
    // Check if the songsList exists
    final List<Map<String, dynamic>> playlists = await _database.query(
      'playlists',
      where: 'id = ?',
      whereArgs: [playlistId],
    );

    if (playlists.isEmpty) {
      // Handle the case where the songsList does not exist
      print('Playlist with ID $playlistId does not exist.');
      return;
    }

    // Insert a new record into the junction table
    await _database.insert(
      'playlist_songs',
      {'playlist_id': playlistId, 'song_id': songId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    // Show a toast to indicate that the song has been saved to the songsList
    Get.snackbar(
      'Success',
      'Song saved to songsList',
      backgroundColor: Colors.black,
      colorText: Colors.white,
    );
  }


  Future<void> createPlaylist(String playlistName) async {
    try {
      await _database.insert(
        'playlists',
        {'name': playlistName},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // Fetch playlists after creating the new one
      await fetchPlaylists(); // Await the completion of fetchPlaylists
    } catch (e) {
      print('Error creating playlist: $e');
    }
  }


}

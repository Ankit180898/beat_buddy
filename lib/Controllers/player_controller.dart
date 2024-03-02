import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController{

  final audioQuery=OnAudioQuery();
  var playlist = <SongModel>[].obs;
  final audioPlayer=AudioPlayer();
  var playingIndex=0.obs;
  var isPlaying=false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkPermissions();
    fetchSongs();
  }

   checkPermissions() async{
     // Request necessary permissions
     Map<Permission, PermissionStatus> statuses = await [
       Permission.audio,
       Permission.storage,
       Permission.manageExternalStorage,
     ].request();
    if(statuses.values.every((status) => status.isGranted)){
      return ;
    }
    else{
      checkPermissions();
    }
  }
  void fetchSongs() async {
    // Initialize the audio query instance
    // Fetch all songs
    final songs = await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: null,
      uriType: UriType.EXTERNAL
    );
    // Clear existing playlist
    playlist.clear();
    // Map audio_query SongInfo objects to our Song model
    playlist.addAll(songs);
    if (kDebugMode) {
      print("my songs: $playlist");
    }
  }

  playSongs(String? url,int index){
    playingIndex.value=index;
    try {
      audioPlayer.setAudioSource(
      AudioSource.uri(Uri.parse(url!)),
      );
      audioPlayer.play();
      isPlaying.value=true;
    } on Exception catch (e) {
      print(e.toString());
      // TODO
    }
  }
  pauseSong(){
    audioPlayer.pause();
    isPlaying.value=false;
  }

}
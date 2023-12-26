import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  final _songList=<SongModel>[].obs;
  List<SongModel> get songList => _songList;

  RxInt indexd = 0.obs;
  RxBool isPlaying = false.obs;
  RxBool isLoading = true.obs;
  RxString duration=''.obs;
  RxString position=''.obs;
  RxString title=''.obs;

  RxDouble max = 0.0.obs;
  RxDouble value = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    cheakPermission();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  cheakPermission() async {
    var per = await Permission.storage.request();
    if (per.isGranted) {
      getAllSongs();
    } else {
      cheakPermission();
    }
  }

  Future<void> getAllSongs() async {
    await audioQuery.querySongs(ignoreCase: true, orderType: OrderType.ASC_OR_SMALLER, sortType: null, uriType: UriType.EXTERNAL).then((value) {
      for (var m in value) {
       // print(m.toString());
        _songList.add(m);
      }
    });
    isLoading.value = false;
    print('lent of songlist ${songList.length}');
  }

  playSong({String? uri, int index = 0}) {
    indexd.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();

    } on Exception catch (e) {
      print(e.toString());
    }
  }

  updatePosition() {
   audioPlayer.durationStream.listen((event) {
     duration.value=event.toString().split(".")[0];
     max.value=event!.inSeconds.toDouble();
   });
   audioPlayer.positionStream.listen((event) {
     position.value=event.toString().split('.')[0];
     value.value=event.inSeconds.toDouble();
   });
  }

  changeDurationSeconds(seconds){
    var duration=Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }
}

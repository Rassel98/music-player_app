import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controllers/home_controller.dart';
import 'details_play.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        ),
        backgroundColor: Colors.black,
        body: Obx(() => Padding(
              padding: const EdgeInsets.all(8.0),
              child: controller.isLoading.value == true
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                  : controller.songList.isEmpty
                      ? const Center(
                          child: Text('No Audio Found!!'),
                        )
                      : ListView.builder(
                          itemCount: controller.songList.length,
                          itemBuilder: (context, index) {
                            final model = controller.songList[index];
                            return Container(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: ListTile(
                                  onTap: () {
                                    Get.to(() => MusicPlayDetails(
                                          controller: controller,
                                        ),
                                        curve: Curves.easeInOut,
                                        duration: const Duration(milliseconds:365 ),
                                        transition: Transition.downToUp);
                                    controller.playSong(uri: model.uri, index: index);
                                  },
                                  style: ListTileStyle.list,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  title: Text(
                                    model.displayNameWOExt ?? "",
                                    maxLines: 2,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    model.artist ?? "",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: controller.indexd.value == index && controller.isPlaying.value
                                      ? const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                        )
                                      : null,
                                  leading: IconButton(
                                    onPressed: () {
                                      if (controller.isPlaying.value == true && controller.indexd.value == index) {
                                        controller.isPlaying.value = false;
                                        controller.audioPlayer.stop();
                                      } else {
                                        controller.playSong(uri: model.uri, index: index);
                                      }
                                    },
                                    icon: QueryArtworkWidget(
                                      id: model.id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: const Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            );
                          },
                        ),
            )));
  }
}

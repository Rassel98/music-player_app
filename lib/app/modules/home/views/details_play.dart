import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/app/modules/home/controllers/home_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayDetails extends StatelessWidget {
  MusicPlayDetails({Key? key,  required this.controller}) : super(key: key);
  HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Obx(
          () => Column(
            children: [
              const SizedBox(height: 10,),
              SizedBox(
                height: 40,
                child: Marquee(
                  text: controller.songList[controller.indexd.value].displayNameWOExt,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20,
                  velocity: 10,
                  pauseAfterRound: const Duration(seconds: 1),
                  showFadingOnlyWhenScrolling: true,
                  fadingEdgeStartFraction: 0.1,
                  fadingEdgeEndFraction: 0.1,
                  numberOfRounds: 3,
                  startPadding: 10,
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                  textDirection: TextDirection.ltr,
                ),
              ),
              Text(controller.songList[controller.indexd.value].artist??"",maxLines: 2,),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    height: 300,
                    width: 300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: QueryArtworkWidget(
                      id: controller.songList[controller.indexd.value].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        size: 100,
                        color: Colors.white,
                      ),
                    )),
              ),
              Container(
                height: Get.height * .19444,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.position.value),
                        Expanded(
                            child: Slider(
                                value: controller.value.value,
                                max: controller.max.value,
                                min: const Duration(seconds: 0).inSeconds.toDouble(),
                                activeColor: Colors.pink,
                                inactiveColor: Colors.grey,
                                thumbColor: Colors.blue,
                                onChanged: (value) {
                                  controller.changeDurationSeconds(value.toInt());
                                })),
                        Text(controller.duration.value),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              controller.playSong(uri: controller.songList[controller.indexd.value-1].uri, index: controller.indexd.value - 1);
                            },
                            icon: const Icon(
                              Icons.skip_previous_outlined,
                              size: 40,
                            )),
                        CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 35,
                          child: Transform.scale(
                            scale: 2.5,
                            child: IconButton(
                                onPressed: () {
                                  if (controller.isPlaying.value == true) {
                                    controller.isPlaying.value = false;
                                    controller.audioPlayer.pause();
                                  } else {
                                    controller.audioPlayer.play();
                                    controller.isPlaying(true);
                                  }
                                },
                                icon: controller.isPlaying.value == true
                                    ? const Icon(
                                        Icons.pause,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.play_arrow,
                                        color: Colors.red,
                                      )),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              controller.playSong(uri: controller.songList[controller.indexd.value+1].uri, index: controller.indexd.value + 1);
                            },
                            icon: const Icon(
                              Icons.skip_next_outlined,
                              size: 40,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

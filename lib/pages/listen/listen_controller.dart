import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/listen/listen_model.dart';
import 'package:novel/services/listen.dart';
import 'package:sp_util/sp_util.dart';

class ListenController extends SuperController
    with GetSingleTickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  RxList<Item> chapters = RxList<Item>();
  RxList<ListenSearchModel> searchs = RxList<ListenSearchModel>();
  Rx<ListenSearchModel> model = ListenSearchModel().obs;
  RxString url = "".obs;
  AudioPlayer audioPlayer = AudioPlayer();
  Rx<Duration> duration = Duration(seconds: 2).obs;
  Rx<Duration> position = Duration(seconds: 1).obs;
  Rx<PlayerState> playerState = PlayerState.STOPPED.obs;
  RxBool play = false.obs;
  RxBool moving = false.obs;
  RxInt idx = 0.obs;
  @override
  void onInit() {
    super.onInit();
    init();
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');

      duration.value = d;
    });

    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (!moving.value) position.value = p;
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState s) async {
      print('Current player state: $s');
      playerState.value = s;
      if (playerState.value == PlayerState.PLAYING) {
        play.value = true;
        position.value = Duration(seconds: 0);
        await audioPlayer
            .seek(Duration(milliseconds: model.value.position ?? 0));
        // if (Get.isBottomSheetOpen ?? false) Get.close(1);
        print(Get.isBottomSheetOpen ?? false);
      }
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      position.value = duration.value;

      onComplete();
    });
    audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      playerState.value = PlayerState.STOPPED;
      duration.value = Duration(seconds: 1);
      position.value = Duration(seconds: 0);
      BotToast.showText(text: "播放失败");
    });
  }

  init() async {
    if (SpUtil.haveKey("v") ?? false) {
      model.value = SpUtil.getObj("v", (v) => ListenSearchModel.fromJson(v))!;
      idx.value = model.value.idx!;
      position.value = Duration(microseconds: model.value.position ?? 0);

      await detail(model.value.id.toString());
      await getUrl(idx.value);
      play.value = true;
    }
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    audioPlayer.release();
    model.value.idx = idx.value;
    SpUtil.putObject("v", model.value);
  }

  search(String v) async {
    searchs.clear();
    searchs.value = await ListenApi().search(v);
    play.value = false;
  }

  clear() {
    searchs.clear();
    textEditingController.text = "";
  }

  detail(String id) async {
    chapters.value = await ListenApi().getChapters(id);
  }

  getUrl(int i) async {
    idx.value = i;
    try {
      url.value = await ListenApi()
          .chapterUrl(chapters[i].link ?? "", model.value.id, idx.value);
      if (url.value.isEmpty) return;

      await playAudio();
    } catch (E) {}
  }

  playAudio() async {
    int result = await audioPlayer.play(url.value);
    if (result == 1) {
      print(result);
    }
  }

  Future<void> onComplete() async {
    await audioPlayer.release();
    await next();
  }

  playToggle() async {
    if (playerState.value == PlayerState.PLAYING) {
      playerState.value = PlayerState.PAUSED;
      await audioPlayer.pause();
    } else if (playerState.value == PlayerState.PAUSED) {
      playerState.value = PlayerState.PLAYING;
      await audioPlayer.resume();
    }
  }

  pre() async {
    if (idx.value == 0) {
      return;
    }
    idx.value = idx.value - 1;
    await getUrl(idx.value);
  }

  next() async {
    if (idx.value == chapters.length - 1) {
      return;
    }
    idx.value = idx.value + 1;
    await getUrl(idx.value);
  }

  movePosition(double v) async {
    position.value = Duration(seconds: v.toInt());
  }

  changeEnd(double value) async {
    moving.value = false;
    var x = Duration(seconds: value.toInt());
    position.value = x;
    await audioPlayer.seek(x);
  }

  changeStart() {
    moving.value = true;
  }

  forward() async {
    position.value = Duration(
        seconds: min(position.value.inSeconds + 10, duration.value.inSeconds));
    await audioPlayer.seek(position.value);
    if (playerState.value != PlayerState.PLAYING) {
      await audioPlayer.resume();
    }
  }

  replay() async {
    position.value = Duration(seconds: max(0, position.value.inSeconds - 10));
    await audioPlayer.seek(position.value);
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
    model.value.idx = idx.value;
    model.value.position = position.value.inMilliseconds;
    SpUtil.putObject("v", model.value);
    audioPlayer.pause();
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
    audioPlayer.resume();
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }
}

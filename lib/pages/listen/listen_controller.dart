import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
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
  Rx<Duration> duration = Duration(seconds: 0).obs;
  Rx<Duration> position = Duration(seconds: 0).obs;
  Rx<PlayerState> playerState = PlayerState.STOPPED.obs;
  RxBool play = false.obs;
  RxBool moving = false.obs;
  RxInt idx = 0.obs;
  RxDouble fast = (1.0).obs;
  late FloatingSearchBarController? controller;
  late ScrollController? scrollcontroller;
  bool firstOpen = false;
  @override
  void onInit() {
    // SpUtil.remove("v");
    super.onInit();
    controller = FloatingSearchBarController();

    ever(idx, (_) {
      scrollcontroller =
          ScrollController(initialScrollOffset: (idx.value - 4) * 40);
    });
    ever(fast, (_) {
      audioPlayer.setPlaybackRate(fast.value);
    });
    init();
    audioPlayer.onDurationChanged.listen((Duration d) {
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
        // position.value = Duration(seconds: 0);
        // await audioPlayer
        //     .seek(Duration(milliseconds: model.value.position ?? 0));
      }
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      // position.value = duration.value;
      print("complete");
      //有可能资源为空 是为报错
      if (duration.value.inMilliseconds > 100) {
        next();
      }
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
      // if (await getUrl(idx.value) == 1) {
      firstOpen = true;
      // }
      play.value = true;

      detail(model.value.id.toString());
    }
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    audioPlayer.release();
    saveState();
  }

  saveState() {
    model.value.idx = idx.value;
    model.value.position = max(position.value.inMilliseconds - 1000, 0);
    model.value.url = url.value;
    SpUtil.putObject("v", model.value);
  }

  search(String v) async {
    if (v.isEmpty) return;
    searchs.clear();
    searchs.value = (await ListenApi().search(v))!;
    play.value = false;
    controller!.close();
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
      if (url.isEmpty) {
        url.value = await ListenApi()
            .chapterUrl(chapters[i].link ?? "", model.value.id, idx.value);
        if (url.value.isEmpty) {
          print("get source url failed");
          throw Exception("e");
        }
      }
      print("audio url ${url.value}");
      return await playAudio();
    } catch (e) {
      BotToast.showText(text: "播放失败,请重试!!!");
      print(e);
    }
    return -1;
  }

  reset() async {
    url.value="";
    playerState.value = PlayerState.STOPPED;
    duration.value = Duration(seconds: 1);
    position.value = Duration(seconds: 0);
    await audioPlayer.release();
  }

  playAudio() async {
    if (audioPlayer.state == PlayerState.PLAYING) {
      audioPlayer.stop();
    }

    // List<int> res =
    //     await Request().getAsByte("${url.value}");
    // int result = await audioPlayer.playBytes(Uint8List.fromList(res));
    int result =
        await audioPlayer.play("${url.value}?v=${DateUtil.getNowDateMs()}");
    if (firstOpen) {
      position.value = Duration(milliseconds: model.value.position ?? 0);

      await audioPlayer.seek(position.value);
      firstOpen = false;
    }
    return result;
  }

  playToggle() async {
    switch (playerState.value) {
      case PlayerState.PLAYING:
        playerState.value = PlayerState.PAUSED;
        await audioPlayer.pause();
        saveState();
        break;
      case PlayerState.PAUSED:
        playerState.value = PlayerState.PLAYING;
        await audioPlayer.resume();
        saveState();

        break;
      case PlayerState.STOPPED:
        await getUrl(idx.value);
        break;
      default:
    }
  }

  pre() async {
    if (idx.value == 0) {
      return;
    }
    audioPlayer.pause();

    url.value = "";
    var x = idx.value;
    int result = await getUrl(x - 1);
    if (result == 1) idx.value = x - 1;
  }

  next() async {
    if (idx.value == chapters.length - 1) {
      return;
    }
    audioPlayer.pause();
    url.value = "";
    var x = idx.value;
    int result = await getUrl(x + 1);
    print(result);
    if (result == 1) idx.value = x + 1;
  }

  movePosition(double v) async {
    if (playerState.value == PlayerState.STOPPED) return;

    position.value = Duration(seconds: v.toInt());
  }

  changeEnd(double value) async {
    if (playerState.value == PlayerState.STOPPED) return;

    moving.value = false;
    var x = Duration(seconds: value.toInt());
    position.value = x;
    await audioPlayer.seek(x);
  }

  changeStart() {
    if (playerState.value == PlayerState.STOPPED) return;

    moving.value = true;
  }

  forward() async {
    if (playerState.value == PlayerState.STOPPED) return;

    position.value = Duration(
        seconds: min(position.value.inSeconds + 10, duration.value.inSeconds));
    await audioPlayer.seek(position.value);
    if (playerState.value != PlayerState.PLAYING) {
      await audioPlayer.resume();
    }
  }

  replay() async {
    if (playerState.value == PlayerState.STOPPED) return;
    position.value = Duration(seconds: max(0, position.value.inSeconds - 10));
    await audioPlayer.seek(position.value);
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
    audioPlayer.pause();

    saveState();
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

  moveCp(double v) {
    idx.value = v.toInt();
  }

  changeCpEnd(double v) async {
    idx.value = v.toInt();
    await getUrl(idx.value);
  }
}

import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:novel/pages/listen/listen_model.dart';
import 'package:novel/services/listen.dart';
import 'package:novel/utils/CustomCacheManager.dart';
import 'package:sp_util/sp_util.dart';

class ListenController extends SuperController
    with GetSingleTickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  RxList<Item> chapters = RxList<Item>();
  RxList<ListenSearchModel> searchs = RxList<ListenSearchModel>();
  Rx<ListenSearchModel> model = ListenSearchModel().obs;
  RxString url = "".obs;
  late AudioPlayer audioPlayer;
  Rx<Duration>? duration = Duration(seconds: 0).obs;
  Rx<Duration>? position = Duration(seconds: 0).obs;
  Rx<ProcessingState> playerState = ProcessingState.idle.obs;
  RxBool showPlay = false.obs;
  RxBool moving = false.obs;
  RxBool playing = false.obs;
  RxInt idx = 0.obs;
  RxDouble fast = (1.0).obs;
  late FloatingSearchBarController? controller;
  late ScrollController? scrollcontroller;

  bool firstOpen = false;
  bool preload = false;
  @override
  void onInit() {
    // SpUtil.remove("v");
    super.onInit();

    controller = FloatingSearchBarController();
    audioPlayer = AudioPlayer();
    scrollcontroller = ScrollController();
    init();

    ever(idx, (_) {
      scrollcontroller =
          ScrollController(initialScrollOffset: idx.value  * 40);
    });
    ever(fast, (_) {
      audioPlayer.setSpeed(fast.value);
    });

    audioPlayer.playerStateStream.listen((state) {
      // if (state.playing) ... else ...
      saveState();

      playerState.value = state.processingState;
      print(
          "state >>>>>>${state.processingState}  playing >>>>${state.playing}");
      // if (audioPlayer.playing) {
      //   play.value = true;
      //   // position.value = Duration(seconds: 0);
      //   // await audioPlayer
      //   //     .seek(Duration(milliseconds: model.value.position ?? 0));
      // }
      playing.value =
          state.playing && state.processingState != ProcessingState.idle;

      switch (state.processingState) {
        case ProcessingState.idle:
          break;
        case ProcessingState.loading:
          break;
        case ProcessingState.buffering:
          break;
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          next();
          break;
      }
    });

    audioPlayer.positionStream.listen((Duration p) {
      if (!moving.value) {
        if (audioPlayer.playing) {
          position!.value = p;
        }
      }
    });

    // audioPlayer.onPlayerCompletion.listen((event) {
    //   // position.value = duration.value;
    //   print("complete");
    //   //有可能资源为空 是为报错
    //   if (!playFailed) {
    //     next();
    //   }
    // });

    // audioPlayer.onPlayerError.listen((msg) {
    //   print('audioPlayer error : $msg');
    //   playerState.value = PlayerState.STOPPED;
    //   duration.value = Duration(seconds: 1);
    //   position.value = Duration(seconds: 0);
    //   BotToast.showText(text: "播放失败");
    // });
  }

  init() async {
    if (SpUtil.haveKey("v") ?? false) {
      model.value = SpUtil.getObj("v", (v) => ListenSearchModel.fromJson(v))!;
      idx.value = model.value.idx!;
      // if (await getUrl(idx.value) == 1) {
      firstOpen = true;
      showPlay.toggle();
      position!.value = Duration(milliseconds: model.value.position ?? 0);
      duration!.value = Duration(milliseconds: model.value.duration ?? 0);
      // }

      await detail(model.value.id.toString());

      getUrl(idx.value);
    }
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    saveState();

    audioPlayer.dispose();
  }

  saveState() {
    model.value.idx = idx.value;
    model.value.position = max(position!.value.inMilliseconds - 1000, 0);
    model.value.duration = duration!.value.inMilliseconds;
    SpUtil.putObject("v", model.value);
  }

  search(String v) async {
    if (v.isEmpty) return;
    searchs.clear();
    searchs.value = (await ListenApi().search(v))!;
    // showPlay.value = false;
    // controller!.close();
  }

  clear() {
    searchs.clear();
    textEditingController.text = "";
  }

  detail(String id) async {
    chapters.value = await ListenApi().getChapters(id);
  }

  getUrl(int i) async {
    url.value =
        await ListenApi().chapterUrl(chapters[i].link ?? "", model.value.id, i);
    print("audio url ${url.value}");
    return await playAudio();
  }

  playAudio() async {
    if (audioPlayer.playing) {
      audioPlayer.stop();
    }
    try {
      await audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(url.value),
          tag: MediaItem(
            id: '$idx',
            album: model.value.title,
            title: "${model.value.title}-第${model.value.idx}回",
            artUri: Uri.parse(
              "https://img.ting55.com/${DateUtil.formatDateMs(model.value.addtime ?? 0, format: "yyyy/MM")}/${model.value.picture}!300",
            ),
          ),
        ),
      );

      duration!.value = (await audioPlayer.load())!;
      await audioPlayer.seek(firstOpen ? position!.value : Duration.zero);
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      print("Error code: ${e.code}");
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
      print("Error message: ${e.message}");
      playerState.value = ProcessingState.idle;
      playing.value = false;
      BotToast.showText(text: "加载音频资源失败,请重试....");
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      print("Connection aborted: ${e.message}");
      await audioPlayer.pause();
    } catch (e) {
      // Fallback for all errors
      print(e);
    }

    // int result =
    //     await audioPlayer.play("${url.value}?v=${DateUtil.getNowDateMs()}");
    // preloadAsset();
    firstOpen = !firstOpen;
    return 1;
  }

  playToggle() async {
    if (playerState.value == ProcessingState.ready) {
      if (playing.value) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
      }
    } else if (audioPlayer.processingState == ProcessingState.idle) {
      await getUrl(idx.value);
      await audioPlayer.play();
    } else {
      BotToast.showText(text: '加载资源中...');
    }
  }

  preloadAsset() async {
    int x = idx.value;
    x += 1;
    final cacheFile = await CustomCacheManager.instanceVoice
        .getFileFromCache("${model.value.id}$x ");

    if (cacheFile != null && cacheFile.validTill.isAfter(DateTime.now())) {
      url.value = cacheFile.file.path;
    } else {
      url.value = await ListenApi()
          .chapterUrl(chapters[x].link ?? "", model.value.id, idx.value);
      if (url.value.isEmpty) {
        print("get source url failed");
        throw Exception("e");
      }
      await CustomCacheManager.instanceVoice
          .getSingleFile(url.value, key: "${model.value.id}$x");
      print("preload asset success");
    }
  }

  pre() async {
    if (idx.value == 0) {
      return;
    }
    // audioPlayer.pause();

    // url.value = "";
    int result = await getUrl(idx.value - 1);
    if (result == 1) {
      idx.value = idx.value - 1;
      await audioPlayer.play();
    }
  }

  next() async {
    if (idx.value == chapters.length - 1) {
      return;
    }
    // await reset();
    // audioPlayer.pause();
    // url.value = "";
    int result = await getUrl(idx.value + 1);
    print(result);
    if (result == 1) {
      idx.value = idx.value + 1;
      await audioPlayer.play();
    }
  }

  movePosition(double v) async {
    if (!audioPlayer.playing) return;

    position!.value = Duration(seconds: v.toInt());
  }

  changeEnd(double value) async {
    if (playerState.value == ProcessingState.idle) return;

    moving.value = false;
    var x = Duration(seconds: value.toInt());
    position!.value = x;
    await audioPlayer.seek(x);
  }

  changeStart() {
    if (playerState.value == ProcessingState.idle) return;

    moving.value = true;
  }

  forward() async {
    if (playerState.value == ProcessingState.idle) return;

    position!.value = Duration(
        seconds: min(
            (position?.value.inSeconds ?? 0) + 10, duration!.value.inSeconds));
    await audioPlayer.seek(position!.value);
  }

  replay() async {
    if (playerState.value == ProcessingState.idle) return;
    position?.value = Duration(seconds: max(0, position!.value.inSeconds - 10));
    await audioPlayer.seek(position!.value);
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
    // audioPlayer.pause();

    saveState();
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
    // audioPlayer.resume();
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }
}

import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novel/pages/listen/listen_model.dart';
import 'package:novel/services/listen.dart';
import 'package:novel/utils/database_provider.dart';
import 'package:palette_generator/palette_generator.dart';

class ListenController extends SuperController
    with GetSingleTickerProviderStateMixin {
  RxList<Search> history = RxList<Search>();
  Rx<Search> model = Search().obs;
  String url = "";
  late AudioPlayer audioPlayer;
  Rx<Duration>? cache = Duration(seconds: 0).obs;
  Rx<ProcessingState> playerState = ProcessingState.idle.obs;
  RxBool moving = false.obs;
  RxBool playing = false.obs;
  RxBool useProxy = false.obs;
  RxBool getLink = false.obs;
  RxBool syncPosition = false.obs;
  RxBool online = false.obs;
  final bgColor = Colors.transparent.obs;
  RxInt idx = 0.obs;
  RxDouble fast = (1.0).obs;
  late ScrollController? scrollcontroller;
  PaletteGenerator? paletteGenerator;
  Color color1 = Colors.black87;
  Color color2 = Colors.black54;
  Color color3 = Colors.black38;
  late TabController tabController;
  late AudioSource _audioSource;

  final tabs = ["当前播放", "播放历史"];
  bool preload = false;

  @override
  void onInit() {
    super.onInit();
    audioPlayer = AudioPlayer();
    scrollcontroller = ScrollController();
    tabController =
        TabController(initialIndex: 0, length: tabs.length, vsync: this);
    ever(idx, (_) {
      scrollcontroller = ScrollController(initialScrollOffset: idx.value * 40);
      model.value.idx = idx.value;
    });

    ever(fast, (_) {
      audioPlayer.setSpeed(fast.value);
    });

    init();

    audioPlayer.playerStateStream.listen((state) {
      saveState();

      playerState.value = state.processingState;
      Get.log(
          "state >>>>>>${state.processingState}  playing >>>>${state.playing}");
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
          syncPosition.value = false;
          next();
          break;
      }
    });

    audioPlayer.positionStream.listen((Duration p) {
      if (!moving.value) {
        if (audioPlayer.playing &&
            playerState.value != ProcessingState.completed) {
          // Get.log(playerState.value.name);

          model.update((val) {
            val!.position = p;
          });
        }
      }
    });

    audioPlayer.bufferedPositionStream.listen((event) {
      cache!.value = event;
    });
  }

  initHistory() async {
    history.value = await DataBaseProvider.dbProvider.voices();
    print(1);
  }

  updatePlay() {
    if (model.value.idx != -1) {
      history[0] = model.value;
      if (!getLink.value) {
        history.refresh();
      }
    }
  }

  init() async {
    await initHistory();
    checkSite();
    if (history.isNotEmpty) {
      model.value = history.first;
      idx.value = model.value.idx!;
      getUrl(idx.value);
      detail(model.value.id.toString());
    }
  }

  checkSite() async {
    int? ok = await compute(ListenApi().checkSite, "");
    online.value = ok == 200;
  }

  removeHistory(int idx) async {
    var h = history[idx];
    await DataBaseProvider.dbProvider.delById(int.parse(h.id ?? ''));
    history.removeAt(idx);
  }

  saveState() async {
    if ((model.value.id ?? "").isNotEmpty) {
      model.value.idx = idx.value;
      model.update((val) {
        val!.idx = idx.value;
      });
      await DataBaseProvider.dbProvider.addVoiceOrUpdate(model.value);
    }
  }

  detail(String id) async {
    int count = await compute(ListenApi().getChapters, id);

    model.update((val) {
      val!.count = count;
    });
    DataBaseProvider.dbProvider.addVoiceOrUpdate(model.value);
  }

  toTop(int i) {
    var temp = history[i];
    history.removeAt(i);
    history.insert(0, temp);
  }

  //跳转
  toPlay(int i, Search pickSearch) async {
    Get.back();
    // getBackgroundColor();
    await audioPlayer.stop();
    saveState();
    DataBaseProvider.dbProvider.addVoiceOrUpdate(pickSearch);
    // Search? v = await DataBaseProvider.dbProvider
    //     .voiceById(int.parse(pickSearch.id.toString()));
    bool exist = false;
    history.forEach((f) {
      if (f.id == pickSearch.id) {
        exist = true;
      }
    });

    if (exist) {
      if (model.value.id == pickSearch.id) {
        return;
      } else {
        for (var i = 0; i < history.length; i++) {
          var item = history[i];
          if (item.id == pickSearch.id) {
            toTop(i);
            model.value = item;
            idx.value = model.value.idx ?? 0;
            playerState.value = ProcessingState.idle;

            await getUrl(idx.value);

            detail(item.id.toString());
            break;
          }
        }
      }
    } else {
      model.value = pickSearch;
      history.insert(0, pickSearch);

      idx.value = model.value.idx ?? 0;
      // controller.getBackgroundColor();
      playerState.value = ProcessingState.idle;

      await getUrl(idx.value);
      detail(pickSearch.id.toString());
    }
  }

  getUrl(int i) async {
    getLink.value = true;
    try {
      url = "";
      url = await compute(ListenApi().chapterUrl,
          'http://m.tingshubao.com/video/?${model.value.id}-0-$i.html');
    } catch (e) {
      print(e);
      getLink.value = false;
    }
    // url =
    //     'https://pp.ting55.com/202201261454/cf07754102fc5c1a60aee3f712f6358d/2015/12/3705/4.mp3';
    print("audio url $url $getLink");
    if (url.isEmpty) {
      BotToast.showText(text: "获取资源链接失败,请重试...");
      getLink.value = false;
      return;
    }

    try {
      _audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: '1',
          album: model.value.title,
          title: "${model.value.title}-第${idx.value + 1}回",
          artUri: Uri.parse(model.value.cover ?? ""),
        ),
      );
      await audioPlayer.setAudioSource(_audioSource);
      var duration = (await audioPlayer.load())!;
      model.update((val) async {
        val!.duration = duration;
      });
      getLink.value = false;
      await audioPlayer.seek(model.value.position);
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");
      getLink.value = false;
      print("Error message: ${e.message}");
      playerState.value = ProcessingState.idle;
      playing.value = false;
      BotToast.showText(text: "加载音频资源失败,请重试....");
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
      await audioPlayer.pause();
    } catch (e) {
      print(e);
    }
    model.value.url = url;

    detail(model.value.id ?? "");
    return 1;
  }

  playToggle() async {
    if (playerState.value == ProcessingState.ready) {
      if (playing.value) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
      }
    } else {
      BotToast.showText(text: '加载资源中...');

      await getUrl(idx.value);
      await audioPlayer.play();
    }
  }

  pre() async {
    if (idx.value == 0) {
      return;
    }

    cache!.value = Duration.zero;
    await Future.delayed(Duration(seconds: 1));
    model.update((val) {
      val!.position = Duration.zero;
    });
    int result = await getUrl(idx.value - 1);
    if (result == 1) {
      idx.value = idx.value - 1;
      await audioPlayer.play();
      updatePlay();
    }
  }

  next() async {
    Get.log('next');

    if (idx.value == model.value.count! - 1) {
      return;
    }
    await Future.delayed(
        Duration(seconds: 1), () => BotToast.showText(text: '播放下一集'));

    cache!.value = Duration.zero;
    model.update((val) {
      val!.position = Duration.zero;
    });
    int result = await getUrl(idx.value + 1);
    if (result == 1) {
      idx.value = idx.value + 1;
      await audioPlayer.play();
      updatePlay();
    }
  }

  movePosition(double v) async {
    // if (!audioPlayer.playing) return;

    model.update((val) {
      val!.position = Duration(seconds: v.toInt());
    });
  }

  changeEnd(double value) async {
    if (playerState.value == ProcessingState.idle) return;

    moving.value = false;
    var x = Duration(seconds: value.toInt());
    model.update((val) {
      val!.position = x;
    });

    await audioPlayer.seek(x);
  }

  changeStart() {
    if (playerState.value == ProcessingState.idle) return;

    moving.value = true;
  }

  forward() async {
    if (playerState.value == ProcessingState.idle) return;

    model.update((val) {
      val!.position = Duration(
          seconds: min(model.value.position!.inSeconds + 10,
              model.value.duration!.inSeconds));
    });
    await audioPlayer.seek(model.value.position);
  }

  replay() async {
    if (playerState.value == ProcessingState.idle) return;

    model.update((val) {
      val!.position =
          Duration(seconds: max(0, model.value.position!.inSeconds - 10));
    });
    await audioPlayer.seek(model.value.position);
  }

  Future<void> getBackgroundColor() async {
    Get.log("get cover bg color");
  }

  delete(int i) async {
    var id = history[i].id ?? "";
    await DataBaseProvider.dbProvider.delById(int.parse(id));
    if (id == model.value.id) {
      model.value = Search(idx: -1);
    }
    history.removeAt(i);
    Get.back();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    saveState();
    Get.log('close');
    audioPlayer.dispose();
    tabController.dispose();
    super.onClose();
  }

  @override
  void onInactive() {
    print('onInactive');
    saveState();
  }

  @override
  void onPaused() {
    print('onPaused');

    saveState();
  }

  @override
  void onResumed() {
    print('onResumed');

    saveState();
  }

  @override
  void onDetached() {
    print("detached");
    saveState();
  }
}

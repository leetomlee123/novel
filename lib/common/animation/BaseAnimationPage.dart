
import 'package:flutter/material.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/pages/read_book/ReaderPageManager.dart';
import 'package:novel/pages/read_book/read_book_controller.dart';

abstract class BaseAnimationPage {
  Offset mTouch = Offset(0, 0);

  AnimationController? mAnimationController;

  Size currentSize = Size(Screen.width, Screen.height);

//  @protected
//  ReaderContentViewModel contentModel=ReaderContentViewModel.instance;

  ReadBookController? readerViewModel;

//  void setData(ReaderChapterPageContentConfig prePageConfig,ReaderChapterPageContentConfig currentPageConfig,ReaderChapterPageContentConfig nextPageConfig){
//    currentPageContentConfig=pageConfig;
//  }

  void setSize(Size size) {
    currentSize = size;
//    mTouch=Offset(currentSize.width, currentSize.height);
  }

  void setContentViewModel(ReadBookController viewModel) {
    readerViewModel = viewModel;
//    mTouch=Offset(currentSize.width, currentSize.height);
  }

  void onDraw(Canvas canvas);
  void onTouchEvent(TouchEvent event);
  void setAnimationController(AnimationController controller) {
    mAnimationController = controller;
  }

  bool isShouldAnimatingInterrupt() {
    return false;
  }

  bool isCanGoNext() {
    return readerViewModel!.isCanGoNext();
  }

  bool isCanGoPre() {
    return readerViewModel!.isCanGoPre();
  }

  bool isCancelArea();
  bool isConfirmArea();

  Animation<Offset>? getCancelAnimation(
      AnimationController controller, GlobalKey canvasKey);
  Animation<Offset>? getConfirmAnimation(
    AnimationController controller,
    GlobalKey canvasKey,
  );
  Simulation? getFlingAnimationSimulation(
      AnimationController controller, DragEndDetails details);
}

enum ANIMATION_TYPE { TYPE_CONFIRM, TYPE_CANCEL, TYPE_FILING }

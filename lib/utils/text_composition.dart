import 'dart:ui' as ui;

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:novel/common/screen.dart';
import 'package:novel/common/values/setting.dart';
import 'package:novel/pages/read_book/read_book_model.dart';

/// * 暂不支持图片
/// * 文本排版
/// * 两端对齐
/// * 底栏对齐
class TextComposition {
  /// 待渲染文本段落
  /// 已经预处理: 不重新计算空行 不重新缩进
  static Color darkFont = Color(0x5FFFFFFF);
  ReadPage? readPage;
  final List<String>? paragraphs;
  bool? justRender;

  /// 字体样式 字号 [size] 行高 [height] 字体 [family] 字色[Color]
  TextStyle? style;

  /// 段间距
  final double? paragraph;

  /// 每一页内容
  List<TextPage>? pages;

  int get pageCount => pages!.length;

  /// 单栏宽度
  final double? columnWidth;

  /// 容器大小
  final Size? boxSize;

  /// 内部边距
  final EdgeInsets? padding;

  /// 是否底栏对齐
  final bool? shouldJustifyHeight;

  /// 前景 页眉页脚 菜单等
  final Widget Function(int pageIndex)? getForeground;

  /// 背景 背景色或者背景图片
  final ui.Image Function(int pageIndex)? getBackground;

  /// 是否显示动画
  bool showAnimation;

  // final Pattern? linkPattern;
  // final TextStyle? linkStyle;
  // final String Function(String s)? linkText;

  // canvas 点击事件不生效
  // final void Function(String s)? onLinkTap;

  /// * 文本排版
  /// * 两端对齐
  /// * 底栏对齐
  /// * 多栏布局
  ///
  ///
  /// * [text] 待渲染文本内容 已经预处理: 不重新计算空行 不重新缩进
  /// * [paragraphs] 待渲染文本内容 已经预处理: 不重新计算空行 不重新缩进
  /// * [paragraphs] 为空时使用[text], 否则忽略[text],
  /// * [style] 字体样式 字号 [size] 行高 [height] 字体 [family] 字色[Color]
  /// * [title] 标题
  /// * [titleStyle] 标题样式
  /// * [boxSize] 容器大小
  /// * [paragraph] 段间距
  /// * [shouldJustifyHeight] 是否底栏对齐
  /// * [columnCount] 分栏个数
  /// * [columnGap] 分栏间距
  /// * onLinkTap canvas 点击事件不生效
  TextComposition({
    String? text,
    List<String>? paragraphs,
    this.style,
    this.readPage,
    this.justRender,
    Size? boxSize,
    this.padding,
    this.shouldJustifyHeight = true,
    this.paragraph = 10.0,
    this.getForeground,
    this.getBackground,
    List<TextPage>? pages,
    this.showAnimation = true,
    // this.linkPattern,
    // this.linkStyle,
    // this.linkText,
    // this.onLinkTap,
  })  : pages = pages ?? <TextPage>[],
        paragraphs = paragraphs ?? text?.split("\n") ?? <String>[],
        boxSize =
            boxSize ?? ui.window.physicalSize / ui.window.devicePixelRatio,
        columnWidth = (boxSize!.width - (padding?.horizontal ?? 0)) {
    // [_width2] [_height2] 用于调整判断
    final tp = TextPainter(textDirection: TextDirection.ltr, maxLines: 1);
    final offset = Offset(columnWidth!, 1);
    final size = style!.fontSize ?? 14;
    final _dx = padding?.left ?? 0;
    final _dy = padding?.top ?? 0;
    final _width = columnWidth;
    final _width2 = _width! - size;
    final _height = this.boxSize!.height - (padding?.vertical ?? 0);
    final _height2 = _height - size * (style!.height ?? 1.0);

    List<Lines> lines = <Lines>[];
    var columnNum = 1;
    var dx = _dx;
    var dy = _dy;
    var startLine = 0;

    /// 下一页 判断分页 依据: `_boxHeight` `_boxHeight2`是否可以容纳下一行
    void newPage([bool shouldJustifyHeight = true, bool lastPage = false]) {
      if (shouldJustifyHeight) {
        final len = lines.length - startLine;
        double justify = (_height - dy) / (len - 1);
        for (var i = 0; i < len; i++) {
          lines[i + startLine].justifyDy(justify * i);
        }
      }
      if (columnNum == 1 || lastPage) {
        this.pages!.add(TextPage(height: dy, lines: lines));
        lines = List.empty();
        columnNum = 1;
        dx = _dx;
      } else {
        columnNum++;
        dx += columnWidth! + 40;
      }
      dy = _dy;
      startLine = lines.length;
    }

    /// 新段落
    void newParagraph() {
      if (dy > _height2) {
        newPage();
      } else {
        dy += paragraph!;
      }
    }

    for (var p in this.paragraphs!) {
      double spacing = 0;
      while (true) {
        tp.text = TextSpan(text: p, style: style);
        tp.layout(maxWidth: columnWidth!);
        final textCount = tp.getPositionForOffset(offset).offset;
        final text = p.substring(0, textCount);
        if (tp.width > _width2) {
          tp.text = TextSpan(text: text, style: style);
          tp.layout();
          spacing = (_width - tp.width) / (textCount + 1);
        }

        lines.add(Lines(text: text, dx: dx, dy: dy, spacing: spacing));
        dy += tp.height;
        if (p.length == textCount) {
          newParagraph();
          break;
        } else {
          p = p.substring(textCount);
          if (dy > _height2) {
            newPage();
          }
        }
      }
    }
    if (lines.isNotEmpty) {
      newPage(false, true);
    }
    if (this.pages!.length == 0) {
      this.pages!.add(TextPage(lines: [], height: 0));
    }
  }

  static List<TextPage> parseContent(ReadPage readPage, ReadSetting setting,
      {justRender = false}) {
    TextComposition textComposition = TextComposition(
      text: readPage.chapterContent,
      readPage: readPage,
      style: TextStyle(
        locale: Locale('zh_CN'),
        fontFamily: setting.fontName,
        fontSize: setting.fontSize,
        letterSpacing: setting.latterSpace,
        // letterSpacing: ReadSetting.getLatterSpace(),
        height: setting.latterHeight,
      ),
      paragraph:
          setting.paragraphHeight! * setting.fontSize! * setting.latterHeight!,
      justRender: justRender,
      // 30 + 15 * 2
      boxSize: Size(
          Screen.width,
          Screen.height -
              Screen.topSafeHeight -
              (60 - Screen.bottomSafeHeight)),
      padding: EdgeInsets.symmetric(horizontal: setting.pageSpace ?? .0),
    );
    return textComposition.pages!;
  }

  static ui.Picture drawContent(ReadPage readPage, int i, bool isDark,
      ReadSetting setting, ui.Image bgImage, double electricQuantity) {
    TextPainter textPainter =
        TextPainter(textDirection: TextDirection.ltr, maxLines: 1);
    ui.PictureRecorder pageRecorder = new ui.PictureRecorder();

    var contentPadding = setting.pageSpace;
    Canvas pageCanvas = new Canvas(
        pageRecorder, Rect.fromLTWH(0, 0, Screen.width, Screen.height));
    Paint selfPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 30.0;
    pageCanvas.drawImage(bgImage, Offset(0, 0), selfPaint);

    //章节
    textPainter.text = TextSpan(
        text: "${readPage.chapterName}",
        style: TextStyle(
          fontSize: 12 / Screen.textScaleFactor,
          color: isDark ? darkFont : Colors.black54,
          fontFamily: setting.fontName,
        ));
    textPainter.layout();
    //章节高30 画在中间
    textPainter.paint(pageCanvas, Offset(contentPadding!, 30));
    //正文
    TextStyle style = TextStyle(
        color: isDark ? darkFont : Colors.black,
        locale: Locale('zh_CN'),
        fontFamily: setting.fontName,
        fontSize: setting.fontSize,
        // letterSpacing: ReadSetting.getLatterSpace(),
        height: setting.latterHeight);

    final TextPage page = readPage.pages![i];
    final lineCount = page.lines!.length;
    for (var i = 0; i < lineCount; i++) {
      final line = page.lines![i];
      if (line.spacing != null &&
          (line.spacing! < -0.1 || line.spacing! > 0.1)) {
        textPainter.text = TextSpan(
          text: line.text!.trimRight(),
          style: style.copyWith(letterSpacing: line.spacing),
        );
      } else {
        textPainter.text = TextSpan(text: line.text!.trimRight(), style: style);
      }
      final offset = Offset(line.dx!, line.dy! + 60);
      textPainter.layout();
      textPainter.paint(pageCanvas, offset);
    }
    //画电池
    double batteryPaddingLeft = contentPadding - 5;
    double mStrokeWidth = 1.0;
    double mPaintStrokeWidth = 1.5;
    Paint mPaint = Paint()..strokeWidth = mPaintStrokeWidth;
    var bottomH = Screen.height - 25 - Screen.bottomSafeHeight;
    var bottomTextH = bottomH - 2;
    //电池头部位置
    Size size = Size(22, 10);
    double batteryHeadLeft = 0;
    double batteryHeadTop = size.height / 4 + bottomH;
    double batteryHeadRight = size.width / 15;
    double batteryHeadBottom = batteryHeadTop + (size.height / 2);

    //电池框位置
    double batteryLeft = batteryHeadRight + mStrokeWidth;
    double batteryTop = bottomH;
    double batteryRight = size.width;
    double batteryBottom = size.height + bottomH;

    //电量位置
    double electricQuantityTotalWidth =
        size.width - batteryHeadRight - 5 * mStrokeWidth; //电池减去边框减去头部剩下的宽度
    double electricQuantityLeft = batteryHeadRight +
        2 * mStrokeWidth +
        electricQuantityTotalWidth * (1 - electricQuantity);
    double electricQuantityTop = mStrokeWidth * 2 + bottomH;
    double electricQuantityRight = size.width - 2 * mStrokeWidth;
    double electricQuantityBottom = size.height - 2 * mStrokeWidth + bottomH;

    mPaint.style = PaintingStyle.fill;
    mPaint.color = isDark ? darkFont : Colors.black54;
    // mPaint.color = Color(0x80ffffff);
    //画电池头部
    pageCanvas.drawRRect(
        RRect.fromLTRBR(
            batteryHeadLeft + batteryPaddingLeft,
            batteryHeadTop,
            batteryHeadRight + batteryPaddingLeft,
            batteryHeadBottom,
            Radius.circular(mStrokeWidth)),
        mPaint);
    mPaint.style = PaintingStyle.stroke;
    //画电池框
    pageCanvas.drawRRect(
        RRect.fromLTRBR(
            batteryLeft + batteryPaddingLeft,
            batteryTop,
            batteryRight + batteryPaddingLeft,
            batteryBottom,
            Radius.circular(mStrokeWidth)),
        mPaint);
    mPaint.style = PaintingStyle.fill;
    mPaint.color = isDark ? darkFont : Colors.black38;
    //画电池电量
    pageCanvas.drawRRect(
        RRect.fromLTRBR(
            electricQuantityLeft + batteryPaddingLeft + .5,
            electricQuantityTop,
            electricQuantityRight + batteryPaddingLeft + .5,
            electricQuantityBottom,
            Radius.circular(mStrokeWidth)),
        mPaint);
    //时间
    textPainter.text = TextSpan(
      text: '${DateUtil.formatDate(DateTime.now(), format: DateFormats.h_m)}',
      style: TextStyle(
        fontFamily: setting.fontName,
        fontSize: 12 / Screen.textScaleFactor,
        color: isDark ? darkFont : Colors.black54,
      ),
    );
    textPainter.layout();
    textPainter.paint(
        pageCanvas, Offset(contentPadding + size.width + 1, bottomTextH));
    //页码
    textPainter.text = TextSpan(
        text: "第${i + 1}/${readPage.pages!.length}页",
        style: TextStyle(
          fontSize: 12 / Screen.textScaleFactor,
          fontFamily: setting.fontName,
          color: isDark ? darkFont : Colors.black54,
        ));
    textPainter.layout();
    textPainter.paint(
        pageCanvas, Offset(Screen.width - contentPadding - 40, bottomTextH));
    return pageRecorder.endRecording();
  }
}

class SelfForePainter extends CustomPainter {
  ui.Image _imageFrame;

  SelfForePainter(this._imageFrame) : super();

  @override
  void paint(Canvas canvas, Size size) {
    Paint selfPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 30.0;
    canvas.drawImage(_imageFrame, Offset(0, 0), selfPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

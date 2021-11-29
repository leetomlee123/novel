import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommonImg extends StatelessWidget {
  String url;
  double width;
  double? aspect;
  BoxFit fit;
  bool roll;

  CommonImg(this.url,
      {this.width = 97,
      this.aspect = .7,
      this.fit = BoxFit.cover,
      this.roll = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExtendedImage.network(url, fit: this.fit,
          loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Image.asset(
              "images/nocover.jpg",
              fit: BoxFit.fill,
            );
            break;
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              width: this.width,
              height: this.width / this.aspect!,
              fit: BoxFit.cover,
            );
            break;
          case LoadState.failed:
            return Image.asset(
              "images/nocover.jpg",
              fit: BoxFit.fill,
            );
            break;
        }
      }),
    );
  }
}

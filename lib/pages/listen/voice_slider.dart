import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/pages/listen/listen_controller.dart';

class VoiceSlider extends GetView<ListenController> {
  const VoiceSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          Column(
        children: [
          SizedBox(
            height: 40,
            width: Get.width,
            child: Slider(
              // cacheValue: controller.cache!.value.inSeconds.toDouble(),
              onChangeStart: (value) => controller.changeStart(),
              onChanged: (double value) => controller.movePosition(value),
              onChangeEnd: (double value) => controller.changeEnd(value),
              value: controller.model.value.position!.inSeconds.toDouble(),
              label: DateUtil.formatDateMs(
                  controller.model.value.position!.inMilliseconds,
                  format: 'mm:ss'),
              min: .0,
              divisions: controller.model.value.duration!.inSeconds,
              max: controller.model.value.duration!.inSeconds.toDouble(),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                DateUtil.formatDateMs(
                    controller.model.value.position!.inMilliseconds,
                    format: 'mm:ss'),
              ),
              Spacer(),
              Text(DateUtil.formatDateMs(
                  controller.model.value.duration!.inMilliseconds,
                  format: 'mm:ss')),
            ],
          ),
        ],
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Text(
      //       DateUtil.formatDateMs(
      //           controller.position!.value.inMilliseconds,
      //           format: 'mm:ss'),
      //     ),
      //     Expanded(
      //       child: Slider(
      //         onChangeStart: (value) => controller.changeStart(),
      //         onChanged: (double value) => controller.movePosition(value),
      //         onChangeEnd: (double value) => controller.changeEnd(value),
      //         value: controller.position!.value.inSeconds.toDouble(),
      //         min: .0,
      //         max: controller.duration!.value.inSeconds.toDouble(),
      //         divisions: (controller.duration!.value.inSeconds <= 0
      //             ? 1
      //             : controller.duration!.value.inSeconds),
      //         label: DateUtil.formatDateMs(
      //             controller.position!.value.inMilliseconds,
      //             format: DateFormats.h_m_s),
      //       ),
      //     ),
      //     Text(DateUtil.formatDateMs(
      //         controller.duration!.value.inMilliseconds,
      //         format: 'mm:ss')),
      //   ],
      // )
    );
  }
}

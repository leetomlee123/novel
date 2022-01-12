import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:novel/pages/listen/listen_controller.dart';

class VoiceSlider extends GetView<ListenController> {
  const VoiceSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double v = controller.position.value.inSeconds.toDouble();
    // double max = controller.duration.value.inSeconds.toDouble();
    return Obx(() => 
    // (controller.duration!.value.inSeconds.toDouble()) >=
    //         (controller.position!.value.inSeconds.toDouble())
    //     ? 
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateUtil.formatDateMs(controller.position!.value.inMilliseconds,
                    format: 'mm:ss'),
              ),
              Expanded(
                child: Slider(
                  onChangeStart: (value) => controller.changeStart(),
                  onChanged: (double value) => controller.movePosition(value),
                  onChangeEnd: (double value) => controller.changeEnd(value),
                  value: controller.position!.value.inSeconds.toDouble(),
                  min: .0,
                  max: controller.duration!.value.inSeconds.toDouble(),
                  divisions: (controller.duration!.value.inSeconds <= 0
                      ? 1
                      : controller.duration!.value.inSeconds),
                  label: DateUtil.formatDateMs(
                      controller.position!.value.inMilliseconds,
                      format: DateFormats.h_m_s),
                ),
              ),
              Text(DateUtil.formatDateMs(
                  controller.duration!.value.inMilliseconds,
                  format: 'mm:ss')),
            ],
          )
        // : Container()
        );
  }
}

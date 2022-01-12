import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  // mix in default seek callback implementations
  MyAudioHandler(this.audioPlayer);
  final AudioPlayer audioPlayer;
  // The most common callbacks:
  Future<void> play() async {
    // All 'play' requests from all origins route to here. Implement this
    // callback to start playing audio appropriate to your app. e.g. music.
  await  audioPlayer.play();
  }

  Future<void> pause() async {
  await  audioPlayer.pause();
  }
  Future<void> stop() async {
      await  audioPlayer.stop();
  }
  Future<void> seek(Duration position) async {
      await  audioPlayer.seek(position);
  }
  Future<void> skipToQueueItem(int i) async {}
}

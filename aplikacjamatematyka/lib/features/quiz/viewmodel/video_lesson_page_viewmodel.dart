import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoLessonViewModel extends ChangeNotifier {
  late VideoPlayerController _controller;
  bool _initialized = false;

  bool showControls = true; // 🔹 kontrola widoczności kontrolek

  VideoPlayerController get controller => _controller;
  bool get isInitialized => _initialized;

  /// Inicjalizacja na sztywno dla 1film.mp4
  Future<void> initialize() async {
    _controller = VideoPlayerController.asset('assets/videos/1film.mp4');

    await _controller.initialize();
    _controller.setVolume(1.0);
    _controller.play();

    // 🔹 Listener do odbudowy UI przy zmianach odtwarzacza
    _controller.addListener(() {
      notifyListeners();
    });

    _initialized = true;
    notifyListeners();
  }

  void playPause() {
    _controller.value.isPlaying ? _controller.pause() : _controller.play();
    notifyListeners();
  }

  void seekTo(Duration position) {
    _controller.seekTo(position);
  }

  void skipForward(int seconds) {
    final newPos = _controller.value.position + Duration(seconds: seconds);
    _controller.seekTo(
      newPos <= _controller.value.duration
          ? newPos
          : _controller.value.duration,
    );
  }

  void skipBackward(int seconds) {
    final newPos = _controller.value.position - Duration(seconds: seconds);
    _controller.seekTo(newPos >= Duration.zero ? newPos : Duration.zero);
  }

  void toggleControls() {
    showControls = !showControls;
    notifyListeners();
  }

  void disposeController() {
    _controller.removeListener(() {});
    _controller.dispose();
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }
}

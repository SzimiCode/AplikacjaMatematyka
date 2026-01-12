import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class VideoLessonViewModel extends ChangeNotifier {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _loading = true;
  String? _error;
  bool showControls = true;
  
  VideoPlayerController get controller => _controller;
  bool get isInitialized => _initialized;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> initialize() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final course = selectedCourseNotifier.value;
      
      if (course == null) {
        throw Exception('Nie wybrano kursu');
      }
      
      final videoUrl = course.fullVideoUrl;
      
      if (videoUrl == null || videoUrl.isEmpty) {
        throw Exception('Brak URL wideo dla kursu: ${course.courseName}');
      }



      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      
      await _controller.initialize();
      _controller.setVolume(1.0);
      _controller.play();

      _controller.addListener(() {
        notifyListeners();
      });

      _initialized = true;
      _loading = false;
      notifyListeners();
      
    } catch (e) {
      _error = 'Błąd ładowania wideo: $e';
      _loading = false;
      _initialized = false;
      notifyListeners();
    }
  }

  void playPause() {
    if (!_initialized) return;
    _controller.value.isPlaying ? _controller.pause() : _controller.play();
    notifyListeners();
  }

  void seekTo(Duration position) {
    if (!_initialized) return;
    _controller.seekTo(position);
  }

  void skipForward(int seconds) {
    if (!_initialized) return;
    final newPos = _controller.value.position + Duration(seconds: seconds);
    _controller.seekTo(
      newPos <= _controller.value.duration ? newPos : _controller.value.duration,
    );
  }

  void skipBackward(int seconds) {
    if (!_initialized) return;
    final newPos = _controller.value.position - Duration(seconds: seconds);
    _controller.seekTo(newPos >= Duration.zero ? newPos : Duration.zero);
  }

  void toggleControls() {
    showControls = !showControls;
    notifyListeners();
  }

  void disposeController() {
    if (_initialized) {
      _controller.removeListener(() {});
      _controller.dispose();
    }
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  void getBackToMenu(){
    selectedPageNotifier.value = 0;
  }
}
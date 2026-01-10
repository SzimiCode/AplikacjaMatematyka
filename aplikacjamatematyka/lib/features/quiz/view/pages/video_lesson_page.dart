import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart' show VideoPlayer;
import 'package:aplikacjamatematyka/features/quiz/viewmodel/video_lesson_page_viewmodel.dart';

class VideoLessonView extends StatefulWidget {
  const VideoLessonView({super.key});

  @override
  State<VideoLessonView> createState() => _VideoLessonViewState();
}

class _VideoLessonViewState extends State<VideoLessonView> {
  late final VideoLessonViewModel _vm;

  @override
  void initState() {
    super.initState();

    _vm = VideoLessonViewModel();
    _vm.initialize();

    // 🔹 landscape full screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _vm.disposeController();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<VideoLessonViewModel>(
          builder: (context, vm, _) {
            if (!vm.isInitialized) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final controller = vm.controller;
            final position = controller.value.position;
            final duration = controller.value.duration;

            return WillPopScope(
              onWillPop: () async => false,
              child: GestureDetector(
                onTap: vm.toggleControls, // 🔹 pokaz/ukryj kontrolki
                child: Stack(
                  children: [
                    // 🎬 VIDEO
                    Center(
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      ),
                    ),

                    // 🎛 KONTROLKI
                    if (vm.showControls)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Slider postępu
                              Slider(
                                min: 0,
                                max: duration.inSeconds.toDouble(),
                                value: position.inSeconds
                                    .clamp(0, duration.inSeconds)
                                    .toDouble(),
                                onChanged: (value) {
                                  vm.seekTo(Duration(seconds: value.toInt()));
                                },
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _format(position),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      _format(duration),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Przyciski cofnięcia 10s, play/pause, przewinięcia 10s
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    iconSize: 48,
                                    color: Colors.white,
                                    icon: const Icon(Icons.replay_10),
                                    onPressed: () => vm.skipBackward(10),
                                  ),
                                  IconButton(
                                    iconSize: 64,
                                    color: Colors.white,
                                    icon: Icon(
                                      controller.value.isPlaying
                                          ? Icons.pause_circle
                                          : Icons.play_circle,
                                    ),
                                    onPressed: vm.playPause,
                                  ),
                                  IconButton(
                                    iconSize: 48,
                                    color: Colors.white,
                                    icon: const Icon(Icons.forward_10),
                                    onPressed: () => vm.skipForward(10),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Przycisk powrotu
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: IconButton(
                                  iconSize: 40,
                                  color: Colors.white,
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

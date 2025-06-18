import 'dart:async';
import 'dart:developer';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SoundPageController extends GetxController {
  String title = "Sound Page";
  late VideoPlayerController videoPlayerController;
  bool isControllerInitializing = false;
  bool hasInitError = false;
  bool isPlaying = false;
  bool isControllerVisible = false;
  Timer? hideControllerTimer;
  late Future<VideoPlayerController> initializeVideoPlayerFuture;
  bool isLoading = false;
  int selected = 0;
  bool pageLoading = true;

  @override
  void onInit() {
    title = Get.arguments['title'] ?? "Sound Page";
    initializeVideoPlayerFuture = initVideoPlayer(
        url:
            "https://firebasestorage.googleapis.com/v0/b/lite-learning-lab.appspot.com/o/Profluent%20English%2FSounds%20Animation%2FVowels%2FShort%20Vowel%2FShort%20Vowel%20%C9%AA%2FVowels%20%20%C9%AA%20Front.mp4?alt=media&token=f061ea50-8f5c-4cad-826d-e61059b2ac31");

    update();
    super.onInit();
  }

  void onClick(int index) async {
    // if (_selected == index) return;
    isLoading = true;
    isPlaying = false;
    selected = index;

    log("index inside the onclick : $index");

    // Pause and dispose the current controller if it exists
    if (videoPlayerController.value.isInitialized) {
      await videoPlayerController.pause();
      await videoPlayerController.dispose();
    }

    // Choose URL based on index
    late String url;
    if (index >= 0 && index <= 4) {
      // url = index == 0
      //     ? widget.links.v1!
      //     : index == 1
      //         ? widget.links.v2!
      //         : index == 2
      //             ? widget.links.v3!
      //             : index == 3
      //                 ? widget.links.v4!
      //                 : widget.links.v5!;
    } else if (index == 5) {
      return;
    }
    final file = await DefaultCacheManager().getSingleFile(
        "https://firebasestorage.googleapis.com/v0/b/lite-learning-lab.appspot.com/o/Profluent%20English%2FSounds%20Animation%2FVowels%2FShort%20Vowel%2FShort%20Vowel%20%C9%AA%2FVowels%20%20%C9%AA%20Front.mp4?alt=media&token=f061ea50-8f5c-4cad-826d-e61059b2ac31");
    videoPlayerController = VideoPlayerController.file(file);

    await videoPlayerController.initialize();
    videoPlayerController.setLooping(false);
    videoPlayerController.setVolume(1.0);
    videoPlayerController.play();
    videoPlayerController.addListener(update);
    // isLoading = false;
    isPlaying = true;
    update();
  }

  refreshScreen(int no) {
    initializeVideoPlayerFuture = initVideoPlayer(
        url:
            "https://firebasestorage.googleapis.com/v0/b/lite-learning-lab.appspot.com/o/Profluent%20English%2FSounds%20Animation%2FVowels%2FShort%20Vowel%2FShort%20Vowel%20%C9%AA%2FVowels%20%20%C9%AA%20Front.mp4?alt=media&token=f061ea50-8f5c-4cad-826d-e61059b2ac31");

    isPlaying = true;
    update();
  }

  Future<VideoPlayerController> initVideoPlayer({required String url}) async {
    log("printing url : ${url}");
    isLoading = true;
    isControllerInitializing = true;
    hasInitError = false;
    isPlaying = false;
    update();
    try {
      final file = await DefaultCacheManager().getSingleFile(url);
      videoPlayerController = VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await videoPlayerController.initialize();
      await videoPlayerController.setVolume(1);
      await videoPlayerController.play();
      isPlaying = true;
      update();
    } catch (e1) {
      try {
        videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(url),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
        await videoPlayerController.initialize();
        await videoPlayerController.setVolume(1);
        await videoPlayerController.play();
        isPlaying = true;
        isLoading = false;
        update();
      } catch (e2) {
        log("Video init failed: $e2");
        hasInitError = true;
        isLoading = false;
        update();
      }
      update();
    }

    isControllerInitializing = false;
    isLoading = false;
    pageLoading = false;
    update();
    return videoPlayerController;
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void toggleControllerVisibility() {
    if (isControllerVisible) {
      hideControllerTimer?.cancel();

      isControllerVisible = false;
      update();
    } else {
      // If currently invisible, show it
      _showController();
    }
  }

  void togglePlayPauseControllerVisibility() {
    // Always show the controller for the play/pause action
    _showController();
  }

  void _showController() {
    // if (_isControllerVisible) {
    // If currently visible, make it immediately invisible
    hideControllerTimer?.cancel(); // Cancel any existing hide timer
    // }

    isControllerVisible = true;
    update();

    // Cancel any existing timer
    // _hideControllerTimer?.cancel();

    // Start a new timer to hide the controller
    hideControllerTimer = Timer(Duration(seconds: 4), () {
      isControllerVisible = false;
    });
    update();
  }
}

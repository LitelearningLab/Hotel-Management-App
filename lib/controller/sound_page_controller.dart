import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:hotelmanagementapp/model/sound_model.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
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
  late SoundSubcategory soundModel;

  @override
  void onInit() {
    log("🔁 onInit called");
    title = Get.arguments['title'] ?? "Sound Page";
    soundModel = Get.arguments['soundModel'];
    super.onInit();
  }

  @override
  void onReady() {
    log("✅ onReady called");
    initializeVideoPlayerFuture = initVideoPlayer(url: soundModel.links.v1);
    super.onReady();
  }

  @override
  void onClose() {
    log("❌ SoundPageController closed");
    videoPlayerController.dispose();
    super.onClose();
  }

  void showPopupAtTap(Offset tapPosition) {
    final overlay = Get.overlayContext!;
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: tapPosition.dx,
        top: tapPosition.dy,
        child: TapPopup(onFinish: () => entry.remove()),
      ),
    );

    Overlay.of(overlay).insert(entry);
  }

  void onClick(int index, Offset tapPosition) async {
    isLoading = true;
    isPlaying = false;
    selected = index;

    if (videoPlayerController.value.isInitialized) {
      await videoPlayerController.pause();
      await videoPlayerController.dispose();
    }

    // Handle based on index
    String? url;
    if (index >= 0 && index <= 4) {
      url = index == 0
          ? soundModel.links.v1
          : index == 1
              ? soundModel.links.v2
              : index == 2
                  ? soundModel.links.v3
                  : index == 3
                      ? soundModel.links.v4
                      : soundModel.links.v5;

      final file = await DefaultCacheManager().getSingleFile(url!);
      videoPlayerController = VideoPlayerController.file(file);

      await videoPlayerController.initialize();
      videoPlayerController.setLooping(false);
      videoPlayerController.setVolume(1.0);
      videoPlayerController.play();
      videoPlayerController.addListener(update);
      isPlaying = true;
    } else if (index == 5) {
      // 👇 This part is important
      await Get.toNamed(
        AppRoutes.soundLab,
        arguments: {'soundSubcategory': soundModel},
      );

      log("🔁 Returned from third page, refreshing...");
      refreshScreen(selected);
      return;
    }

    update();
  }

  void refreshScreen(int index) {
    log("🔄 refreshScreen called with index $index");
    initializeVideoPlayerFuture = initVideoPlayer(url: soundModel.links.v1);
    isPlaying = true;
    update();
  }

  Future<VideoPlayerController> initVideoPlayer({required String url}) async {
    log("🎞️ Initializing video: $url");

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
    } catch (e1) {
      try {
        videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(url.trim()),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
        await videoPlayerController.initialize();
        await videoPlayerController.setVolume(1);
        await videoPlayerController.play();
        isPlaying = true;
      } catch (e2) {
        log("❌ Video init failed: $e2");
        hasInitError = true;
      }
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
    } else {
      _showController();
    }
    update();
  }

  void togglePlayPauseControllerVisibility() {
    _showController();
  }

  void _showController() {
    hideControllerTimer?.cancel();
    isControllerVisible = true;

    hideControllerTimer = Timer(Duration(seconds: 4), () {
      isControllerVisible = false;
      update();
    });

    update();
  }
}

import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  RxInt currentPlayingIndex = (-1).obs; // -1 means nothing is playing
  RxBool isPlay = false.obs;
  RxBool isPlayAllRunning = false.obs;

  @override
  void onInit() {
    log("🔁 onInit called");
    final args = Get.arguments;
    final box = GetStorage();
    if (args != null) {
      title = args['title'] ?? "Sound Page";
      soundModel = args['soundModel'];
    } else {
      final saved = box.read(AppRoutes.soundPage) ?? {};
      title = saved['title'] ?? "Sound Page";

      final storedSound = saved['soundModel'];
      if (storedSound is Map<String, dynamic>) {
        soundModel = SoundSubcategory.fromJson(storedSound);
      } else if (storedSound is SoundSubcategory) {
        soundModel = storedSound;
      }
    }

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

  Future<void> playItem(int index) async {
    isLoading = true;
    update();

    currentPlayingIndex.value = index;
    isPlay.value = true;

    String url = index == 0
        ? soundModel.links.v1
        : index == 1
            ? soundModel.links.v2
            : index == 2
                ? soundModel.links.v3
                : index == 3
                    ? soundModel.links.v4
                    : soundModel.links.v5;

    // Dispose previous controller
    if (videoPlayerController.value.isInitialized) {
      await videoPlayerController.pause();
      await videoPlayerController.dispose();
    }

    // Load new video
    if (kIsWeb) {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    } else {
      final file = await DefaultCacheManager().getSingleFile(url);
      videoPlayerController = VideoPlayerController.file(file);
    }

    await videoPlayerController.initialize();
    await videoPlayerController.setLooping(false);
    await videoPlayerController.setVolume(1.0);
    await videoPlayerController.play();

    // Detect video end
    videoPlayerController.addListener(() {
      if (videoPlayerController.value.position >=
          videoPlayerController.value.duration) {
        isPlay.value = false;
        currentPlayingIndex.value = -1;
        update();
      }
    });

    isLoading = false;
    update();
  }

  Future<void> playAllSequentially() async {
    isPlayAllRunning.value = true;
    update();

    for (int i = 0; i < 5; i++) {
      if (!isPlayAllRunning.value) {
        // User pressed STOP
        stopAll();
        return;
      }

      await playItem(i);

      await _waitUntilVideoEnds();

      if (!isPlayAllRunning.value) {
        // User pressed STOP during playback
        stopAll();
        return;
      }
    }

    // Finished all videos automatically
    stopAll();
  }

  void togglePlayPause(int index) async {
    // If the same item is playing → toggle play/pause
    if (currentPlayingIndex.value == index) {
      if (isPlay.value) {
        await videoPlayerController.pause();
        isPlay.value = false;
      } else {
        await videoPlayerController.play();
        isPlay.value = true;
      }
      update();
      return;
    }

    // If switching to a new item
    isLoading = true;
    update();

    await playItem(index);

    isLoading = false;
    update();
  }

  Future<void> _waitUntilVideoEnds() async {
    Completer completer = Completer();

    void listener() {
      if (!videoPlayerController.value.isPlaying &&
          videoPlayerController.value.position >=
              videoPlayerController.value.duration) {
        completer.complete();
        videoPlayerController.removeListener(listener);
      }
    }

    videoPlayerController.addListener(listener);
    return completer.future;
  }

  void stopAll() async {
    isPlayAllRunning.value = false;
    isPlay.value = false;
    currentPlayingIndex.value = -1;

    if (videoPlayerController.value.isInitialized) {
      await videoPlayerController.pause();
    }

    update();
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

  void onClick(int index) async {
    isLoading = true;
    isPlaying = false;
    selected = index;
    update();
    if (videoPlayerController.value.isInitialized) {
      await videoPlayerController.pause();
      await videoPlayerController.dispose();
    }
    print(
        "index clicked on clikc $index --------------------------------------------------------------- ${index >= 0 && index <= 4}  ");
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
      debugPrint("Selected URL: $url");

      if (kIsWeb) {
        // Web must use network URL (cannot load local file)
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(url));
      } else {
        // Mobile/Desktop can cache for faster replay
        final file = await DefaultCacheManager().getSingleFile(url!);
        videoPlayerController = VideoPlayerController.file(file);
      }

      await videoPlayerController.initialize();
      videoPlayerController.setLooping(false);
      videoPlayerController.setVolume(1.0);
      videoPlayerController.play();
      videoPlayerController.addListener(update);
      isPlaying = true;
    } else if (index == 5) {
      GetStorage().write(AppRoutes.soundLab, {'soundSubcategory': soundModel});
      kIsWeb
          ? Get.rootDelegate.offNamed(
              AppRoutes.soundLab,
              arguments: {'soundSubcategory': soundModel},
            )
          :
          // 👇 This part is important
          await Get.toNamed(
              AppRoutes.soundLab,
              arguments: {'soundSubcategory': soundModel},
            );

      log("🔁 Returned from third page, refreshing...");
      refreshScreen(selected);
      return;
    }
    isPlaying = true;
    isLoading = false;
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
    // isPlaying = false;
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

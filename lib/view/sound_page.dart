import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotelmanagementapp/controller/sound_page_controller.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/public/size_helpers.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:video_player/video_player.dart';

class SoundPage extends StatefulWidget {
  const SoundPage({super.key});

  @override
  State<SoundPage> createState() => _SoundPageState();
}

class _SoundPageState extends State<SoundPage> {
  @override
  void initState() {
    startTimerMainCategory("");
    // timestampIndex = 6;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoundPageController>(builder: (controller) {
      return PopScope(
        onPopInvoked: (didPop) {
          stopTimerMainCategory();
        },
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Align(
            alignment: Alignment.bottomCenter,
            child: CustomeBottomNavigation(),
          ),
          appBar: AppBar(
            forceMaterialTransparency: true,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            titleSpacing: 0,
            title: Text(
              controller.title, maxLines: 2,
              // textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: Keys.lucidaFontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                kIsWeb
                    ? Get.rootDelegate.offNamed(AppRoutes.languageLab)
                    : Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: controller.pageLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: linearColor,
                  ),
                )
              : displayWidth(context) > 1000
                  ? Center(
                      child: SizedBox(
                        // color: Colors.amber,
                        width: displayWidth(context),
                        height: displayHeight(context) * 1.45,
                        child: SingleChildScrollView(
                          // padding: const EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: displayWidth(context) / 1.65,
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 80, vertical: 40),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(0, 4),
                                        blurRadius: 10,
                                      ),
                                    ],
                                    color: Color(0xFF3B465A),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 40,
                                          right: 10,
                                          top: 20,
                                          bottom: 20),
                                      child: SizedBox(
                                        // color: Colors.yellow,
                                        width: kWidth / 4,
                                        height: kWidth / 4,
                                        child: controller.isLoading
                                            ? controller.hasInitError
                                                ? Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.error,
                                                            color: Colors.white,
                                                            size: 48),
                                                        SizedBox(height: 16),
                                                        Text(
                                                            "Video failed to load",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            try {
                                                              // Forcefully dispose current controllers before retrying
                                                              await controller
                                                                  .videoPlayerController
                                                                  .pause();
                                                              await controller
                                                                  .videoPlayerController
                                                                  .dispose();
                                                              // _chewieController.dispose();
                                                            } catch (e) {
                                                              print(
                                                                  "Error disposing controllers before retry: $e");
                                                            }

                                                            controller
                                                                    .initializeVideoPlayerFuture =
                                                                controller
                                                                    .initVideoPlayer(
                                                                        url:
                                                                            " https://firebasestorage.googleapis.com/v0/b/lite-learning-lab.appspot.com/o/Profluent%20English%2FSounds%20Animation%2FVowels%2FShort%20Vowel%2FShort%20Vowel%20%C9%AA%2FVowels%20%20%C9%AA%20Front.mp4?alt=media&token=f061ea50-8f5c-4cad-826d-e61059b2ac31");
                                                          },
                                                          child: Text("Retry"),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        CircularProgressIndicator(
                                                            strokeWidth: 5,
                                                            color:
                                                                Colors.white),
                                                        SizedBox(
                                                          height:
                                                              getWidgetHeight(
                                                                  height: 20),
                                                        ),
                                                        Text(
                                                          'Loading...',
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                            : MouseRegion(
                                                onEnter: (_) {
                                                  controller.hideControllerTimer
                                                      ?.cancel();
                                                  // setState(() {
                                                  controller
                                                          .isControllerVisible =
                                                      true;
                                                  // });
                                                  controller.update();
                                                },
                                                onExit: (_) {
                                                  // setState(() {
                                                  controller
                                                          .isControllerVisible =
                                                      false;
                                                  // });
                                                },
                                                child: Stack(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: controller
                                                          .toggleControllerVisibility,
                                                      child: VideoPlayer(controller
                                                          .videoPlayerController),
                                                    ),

                                                    // Modern Controls Overlay (Fade in/out)
                                                    AnimatedOpacity(
                                                      opacity: controller
                                                              .isControllerVisible
                                                          ? 1.0
                                                          : 0.0,
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      child: Stack(
                                                        children: [
                                                          // --- 2. Bottom Control Bar (Timeline, Duration, and Play/Pause Button) ---
                                                          Positioned(
                                                            bottom: 0,
                                                            left: 0,
                                                            right: 0,
                                                            child: Container(
                                                              // Gradient for a smoother, modern look
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .bottomCenter,
                                                                  end: Alignment
                                                                      .topCenter,
                                                                  colors: [
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0.7),
                                                                    Colors
                                                                        .transparent,
                                                                  ],
                                                                ),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      16,
                                                                      32,
                                                                      16,
                                                                      8),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  // --- A. Play/Pause Button (NEW POSITION) ---
                                                                  ValueListenableBuilder<
                                                                      VideoPlayerValue>(
                                                                    valueListenable:
                                                                        controller
                                                                            .videoPlayerController,
                                                                    builder: (context,
                                                                        value,
                                                                        child) {
                                                                      return IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          value.isPlaying
                                                                              ? Icons.pause_circle_filled_rounded
                                                                              : Icons.play_circle_fill_rounded,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              36, // Adjust size for bottom row
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          if (controller
                                                                              .videoPlayerController
                                                                              .value
                                                                              .isPlaying) {
                                                                            controller.videoPlayerController.pause();
                                                                          } else {
                                                                            controller.videoPlayerController.play();
                                                                          }
                                                                          // Reset hide timer
                                                                          // Assuming togglePlayPauseControllerVisibility is available
                                                                          // togglePlayPauseControllerVisibility();
                                                                          controller
                                                                              .toggleControllerVisibility(); // Assuming this function is available to reset the hide timer
                                                                        },
                                                                      );
                                                                    },
                                                                  ),

                                                                  const SizedBox(
                                                                      width: 8),

                                                                  // --- B. Current Position Time ---
                                                                  ValueListenableBuilder<
                                                                      VideoPlayerValue>(
                                                                    valueListenable:
                                                                        controller
                                                                            .videoPlayerController,
                                                                    builder: (context,
                                                                        value,
                                                                        child) {
                                                                      return Text(
                                                                        controller
                                                                            .formatDuration(value.position),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 14),
                                                                      );
                                                                    },
                                                                  ),

                                                                  const SizedBox(
                                                                      width: 8),

                                                                  // --- C. Timeline Slider ---
                                                                  Expanded(
                                                                    child: ValueListenableBuilder<
                                                                        VideoPlayerValue>(
                                                                      valueListenable:
                                                                          controller
                                                                              .videoPlayerController,
                                                                      builder: (context,
                                                                          value,
                                                                          child) {
                                                                        return SliderTheme(
                                                                          data:
                                                                              SliderTheme.of(context).copyWith(
                                                                            thumbShape:
                                                                                RoundSliderThumbShape(enabledThumbRadius: 6.0),
                                                                            overlayShape:
                                                                                RoundSliderOverlayShape(overlayRadius: 12.0),
                                                                            trackHeight:
                                                                                3.0,
                                                                            activeTrackColor:
                                                                                Colors.white,
                                                                            inactiveTrackColor:
                                                                                Colors.white54,
                                                                            thumbColor:
                                                                                Colors.blue, // Highlight color
                                                                            overlayColor:
                                                                                Colors.blue.withOpacity(0.3),
                                                                          ),
                                                                          child:
                                                                              Slider(
                                                                            value:
                                                                                value.position.inMilliseconds.toDouble().clamp(0.0, value.duration.inMilliseconds.toDouble()),
                                                                            min:
                                                                                0,
                                                                            max:
                                                                                value.duration.inMilliseconds.toDouble(),
                                                                            onChanged:
                                                                                (newValue) {
                                                                              controller.videoPlayerController.seekTo(
                                                                                Duration(milliseconds: newValue.toInt()),
                                                                              );
                                                                              // Keep controls visible while seeking
                                                                              controller.toggleControllerVisibility(); // Assuming this function is available
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                      width: 8),

                                                                  // --- D. Total Duration Time ---
                                                                  ValueListenableBuilder<
                                                                      VideoPlayerValue>(
                                                                    valueListenable:
                                                                        controller
                                                                            .videoPlayerController,
                                                                    builder: (context,
                                                                        value,
                                                                        child) {
                                                                      return Text(
                                                                        controller
                                                                            .formatDuration(value.duration),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 14),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidgetWidth(width: 20),
                                          right: 20,
                                          top: getWidgetHeight(height: 40)),
                                      child: SizedBox(
                                        height: kHeight / 1.2,
                                        width: kWidth / 5,
                                        child: Column(
                                          children: [
                                            GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 1,
                                                mainAxisSpacing: 15,
                                                childAspectRatio: 8.2,
                                              ),
                                              itemCount: 7, // <-- previously 6
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                // ------------ PLAY ALL BUTTON (index == 6) ------------
                                                if (index == 6) {
                                                  return Obx(() {
                                                    bool isRunning = controller
                                                        .isPlayAllRunning.value;

                                                    return GestureDetector(
                                                      onTap: () {
                                                        if (isRunning) {
                                                          controller
                                                              .stopAll(); // Stop sequence if running
                                                        } else {
                                                          controller
                                                              .playAllSequentially(); // Start play-all
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFF3B465A),
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0.5)),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              isRunning
                                                                  ? Icons.stop
                                                                  : Icons
                                                                      .library_music,
                                                              color:
                                                                  Colors.white,
                                                              size: 35,
                                                            ),
                                                            SizedBox(width: 12),
                                                            Expanded(
                                                              child: Text(
                                                                isRunning
                                                                    ? "Stop"
                                                                    : "Play All",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: kText
                                                                      .scale(
                                                                          20),
                                                                ),
                                                              ),
                                                            ),
                                                            Icon(
                                                              isRunning
                                                                  ? Icons
                                                                      .stop_circle
                                                                  : Icons
                                                                      .play_circle_fill,
                                                              color:
                                                                  Colors.white,
                                                              size: 28,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                }

                                                // -----------------------------------------------------
                                                // NORMAL ITEMS 0–5
                                                // -----------------------------------------------------

                                                return Obx(() {
                                                  bool isPlayingNow = (controller
                                                              .currentPlayingIndex
                                                              .value ==
                                                          index) &&
                                                      controller.isPlay.value;

                                                  return GestureDetector(
                                                    onTapDown: (details) async {
                                                      if (index == 5) {
                                                        GetStorage().write(
                                                            AppRoutes.soundLab,
                                                            {
                                                              'soundSubcategory':
                                                                  controller
                                                                      .soundModel
                                                            });
                                                        kIsWeb
                                                            ? Get.rootDelegate
                                                                .offNamed(
                                                                AppRoutes
                                                                    .soundLab,
                                                                arguments: {
                                                                  'soundSubcategory':
                                                                      controller
                                                                          .soundModel
                                                                },
                                                              )
                                                            :
                                                            // 👇 This part is important
                                                            await Get.toNamed(
                                                                AppRoutes
                                                                    .soundLab,
                                                                arguments: {
                                                                  'soundSubcategory':
                                                                      controller
                                                                          .soundModel
                                                                },
                                                              );

                                                        log("🔁 Returned from third page, refreshing...");
                                                        controller
                                                            .refreshScreen(
                                                                controller
                                                                    .selected);
                                                        return;
                                                      } else {
                                                        controller
                                                            .togglePlayPause(
                                                                index);
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 5),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF3B465A),
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.5)),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          // ---------- IMAGE / MIC ----------
                                                          if (index != 5)
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      getWidgetWidth(
                                                                          width:
                                                                              1)),
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/pl${index + 1}.png",
                                                                height:
                                                                    getWidgetHeight(
                                                                        height:
                                                                            50),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )
                                                          else
                                                            Icon(Icons.mic,
                                                                color: Colors
                                                                    .white,
                                                                size: 35),

                                                          SizedBox(width: 12),

                                                          // ---------- TITLE ----------
                                                          Expanded(
                                                            child: Text(
                                                              index == 0
                                                                  ? "Front View"
                                                                  : index == 1
                                                                      ? "Side View"
                                                                      : index ==
                                                                              2
                                                                          ? "Front Closer"
                                                                          : index == 3
                                                                              ? "Side Closer"
                                                                              : index == 4
                                                                                  ? "Animation"
                                                                                  : "Practice",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: kText
                                                                    .scale(20),
                                                              ),
                                                            ),
                                                          ),

                                                          // ---------- PLAY / PAUSE ICON ----------
                                                          if (index != 5)
                                                            IconButton(
                                                              icon: Icon(
                                                                isPlayingNow
                                                                    ? Icons
                                                                        .pause
                                                                    : Icons
                                                                        .play_arrow,
                                                                color: Colors
                                                                    .white,
                                                                size: 28,
                                                              ),
                                                              onPressed: () {
                                                                controller
                                                                    .togglePlayPause(
                                                                        index);
                                                              },
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              height:
                                                  getWidgetHeight(height: 40),
                                            ),
                                            Container(
                                              // width: kWidth / 4/,
                                              // color: Colors.yellow,
                                              alignment: Alignment.center,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Usual Letter Representations",
                                                    style: TextStyle(
                                                        color: pinkishGrey,
                                                        fontFamily:
                                                            Keys.fontFamily,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize:
                                                            kText.scale(15)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      (controller.soundModel
                                                                      ?.ULR ==
                                                                  "" ||
                                                              controller
                                                                      .soundModel
                                                                      ?.ULR ==
                                                                  null)
                                                          ? "Empty"
                                                          : controller
                                                              .soundModel!.ULR,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              Keys.fontFamily,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize:
                                                              kText.scale(15)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 60,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView(
                      children: [
                        SizedBox(
                            width: kWidth,
                            height: controller
                                    .videoPlayerController.value.isInitialized
                                ? displayWidth(context) > 700
                                    ? displayHeight(context) * 0.5
                                    : kWidth /
                                        controller.videoPlayerController.value
                                            .aspectRatio
                                : displayWidth(context),
                            child: controller.isLoading
                                ? controller.hasInitError
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.error,
                                                color: Colors.white, size: 48),
                                            SizedBox(height: 16),
                                            Text("Video failed to load",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  // Forcefully dispose current controllers before retrying
                                                  await controller
                                                      .videoPlayerController
                                                      .pause();
                                                  await controller
                                                      .videoPlayerController
                                                      .dispose();
                                                  // _chewieController.dispose();
                                                } catch (e) {
                                                  log("Error disposing controllers before retry: $e");
                                                }

                                                controller
                                                        .initializeVideoPlayerFuture =
                                                    controller.initVideoPlayer(
                                                        url:
                                                            " https://firebasestorage.googleapis.com/v0/b/lite-learning-lab.appspot.com/o/Profluent%20English%2FSounds%20Animation%2FVowels%2FShort%20Vowel%2FShort%20Vowel%20%C9%AA%2FVowels%20%20%C9%AA%20Front.mp4?alt=media&token=f061ea50-8f5c-4cad-826d-e61059b2ac31");
                                              },
                                              child: Text("Retry"),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Center(
                                        child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: primaryLight,
                                          ),
                                          SizedBox(
                                            height: getWidgetHeight(height: 10),
                                          ),
                                          Text(
                                            'Loading...',
                                            style: TextStyle(
                                              color: primaryLight,
                                            ),
                                          ),
                                        ],
                                      ))
                                : Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: controller
                                            .toggleControllerVisibility,
                                        child: VideoPlayer(
                                            controller.videoPlayerController),
                                      ),

                                      // Modern Controls Overlay (Fade in/out)
                                      AnimatedOpacity(
                                        opacity: controller.isControllerVisible
                                            ? 1.0
                                            : 0.0,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: Stack(
                                          children: [
                                            // --- 2. Bottom Control Bar (Timeline, Duration, and Play/Pause Button) ---
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                // Gradient for a smoother, modern look
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.black
                                                          .withOpacity(0.7),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16, 32, 16, 8),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // --- A. Play/Pause Button (NEW POSITION) ---
                                                    ValueListenableBuilder<
                                                        VideoPlayerValue>(
                                                      valueListenable: controller
                                                          .videoPlayerController,
                                                      builder: (context, value,
                                                          child) {
                                                        return IconButton(
                                                          icon: Icon(
                                                            value.isPlaying
                                                                ? Icons
                                                                    .pause_circle_filled_rounded
                                                                : Icons
                                                                    .play_circle_fill_rounded,
                                                            color: Colors.white,
                                                            size:
                                                                36, // Adjust size for bottom row
                                                          ),
                                                          onPressed: () {
                                                            if (controller
                                                                .videoPlayerController
                                                                .value
                                                                .isPlaying) {
                                                              controller
                                                                  .videoPlayerController
                                                                  .pause();
                                                            } else {
                                                              controller
                                                                  .videoPlayerController
                                                                  .play();
                                                            }
                                                            // Reset hide timer
                                                            // Assuming togglePlayPauseControllerVisibility is available
                                                            // togglePlayPauseControllerVisibility();
                                                            controller
                                                                .toggleControllerVisibility(); // Assuming this function is available to reset the hide timer
                                                          },
                                                        );
                                                      },
                                                    ),

                                                    const SizedBox(width: 8),

                                                    // --- B. Current Position Time ---
                                                    ValueListenableBuilder<
                                                        VideoPlayerValue>(
                                                      valueListenable: controller
                                                          .videoPlayerController,
                                                      builder: (context, value,
                                                          child) {
                                                        return Text(
                                                          controller
                                                              .formatDuration(
                                                                  value
                                                                      .position),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14),
                                                        );
                                                      },
                                                    ),

                                                    const SizedBox(width: 8),

                                                    // --- C. Timeline Slider ---
                                                    Expanded(
                                                      child:
                                                          ValueListenableBuilder<
                                                              VideoPlayerValue>(
                                                        valueListenable: controller
                                                            .videoPlayerController,
                                                        builder: (context,
                                                            value, child) {
                                                          return SliderTheme(
                                                            data:
                                                                SliderTheme.of(
                                                                        context)
                                                                    .copyWith(
                                                              thumbShape:
                                                                  RoundSliderThumbShape(
                                                                      enabledThumbRadius:
                                                                          6.0),
                                                              overlayShape:
                                                                  RoundSliderOverlayShape(
                                                                      overlayRadius:
                                                                          12.0),
                                                              trackHeight: 3.0,
                                                              activeTrackColor:
                                                                  Colors.white,
                                                              inactiveTrackColor:
                                                                  Colors
                                                                      .white54,
                                                              thumbColor: Colors
                                                                  .blue, // Highlight color
                                                              overlayColor: Colors
                                                                  .blue
                                                                  .withOpacity(
                                                                      0.3),
                                                            ),
                                                            child: Slider(
                                                              value: value
                                                                  .position
                                                                  .inMilliseconds
                                                                  .toDouble()
                                                                  .clamp(
                                                                      0.0,
                                                                      value
                                                                          .duration
                                                                          .inMilliseconds
                                                                          .toDouble()),
                                                              min: 0,
                                                              max: value
                                                                  .duration
                                                                  .inMilliseconds
                                                                  .toDouble(),
                                                              onChanged:
                                                                  (newValue) {
                                                                controller
                                                                    .videoPlayerController
                                                                    .seekTo(
                                                                  Duration(
                                                                      milliseconds:
                                                                          newValue
                                                                              .toInt()),
                                                                );
                                                                // Keep controls visible while seeking
                                                                controller
                                                                    .toggleControllerVisibility(); // Assuming this function is available
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),

                                                    const SizedBox(width: 8),

                                                    // --- D. Total Duration Time ---
                                                    ValueListenableBuilder<
                                                        VideoPlayerValue>(
                                                      valueListenable: controller
                                                          .videoPlayerController,
                                                      builder: (context, value,
                                                          child) {
                                                        return Text(
                                                          controller
                                                              .formatDuration(
                                                                  value
                                                                      .duration),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: getWidgetWidth(width: 20),
                              right: getWidgetWidth(width: 20),
                              top: getWidgetHeight(height: 20)),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 19,
                              childAspectRatio: 3,
                            ),
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.onClick(index);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: const Offset(0, 4),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getWidgetWidth(width: 10),
                                        vertical: getWidgetHeight(height: 5)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        if (index != 5)
                                          Image.asset(
                                            "assets/images/pl${index + 1}.png",
                                            width: getWidgetWidth(width: 35),
                                          ),
                                        if (index == 5)
                                          SizedBox(
                                              width: getWidgetWidth(width: 5)),
                                        if (index == 5)
                                          Icon(
                                            Icons.mic,
                                            color: Colors.black,
                                            size: getWidgetHeight(height: 33),
                                          ),
                                        if (index == 5)
                                          SizedBox(
                                            width: getWidgetWidth(width: 0),
                                          ),
                                        SizedBox(
                                            width: getWidgetWidth(width: 10)),
                                        Text(
                                          index == 0
                                              ? "Front View"
                                              : index == 1
                                                  ? "Side View"
                                                  : index == 2
                                                      ? "Front Closer"
                                                      : index == 3
                                                          ? "Side Closer"
                                                          : index == 4
                                                              ? "Animation"
                                                              : "Practice",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: kText.scale(15),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              horizontal: getWidgetWidth(width: 5)),
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidgetWidth(width: 10),
                              vertical: getWidgetHeight(height: 20)),
                          child: Column(
                            children: [
                              Text(
                                "Usual Letter Representations",
                                style: TextStyle(
                                    color: pinkishGrey,
                                    fontFamily: Keys.fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: kText.scale(15)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  (controller.soundModel?.ULR == "" ||
                                          controller.soundModel?.ULR == null)
                                      ? "Empty"
                                      : controller.soundModel!.ULR,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Keys.fontFamily,
                                      fontWeight: FontWeight.w500,
                                      fontSize: kText.scale(15)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getWidgetHeight(height: 60),
                        )
                      ],
                    ),
        ),
      );
    });
  }
}

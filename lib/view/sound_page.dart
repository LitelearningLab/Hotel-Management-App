import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
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
                        height: displayHeight(context) * 1.5,
                        child: SingleChildScrollView(
                          // padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 80, vertical: 40),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            offset: const Offset(0, 4),
                                            blurRadius: 10,
                                          ),
                                        ],
                                        color: Color(0xFF3B465A),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 40,
                                              right: 10,
                                              top: 20,
                                              bottom: 20),
                                          child: SizedBox(
                                            // color: Colors.yellow,
                                            width: kWidth / 3,
                                            height: kWidth / 3.5,
                                            child: controller.isPlaying == false
                                                ? controller.hasInitError
                                                    ? Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(Icons.error,
                                                                color: Colors
                                                                    .white,
                                                                size: 48),
                                                            SizedBox(
                                                                height: 16),
                                                            Text(
                                                                "Video failed to load",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
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
                                                              child:
                                                                  Text("Retry"),
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
                                                                  linearColor),
                                                          SizedBox(
                                                            height:
                                                                getWidgetHeight(
                                                                    height: 20),
                                                          ),
                                                          Text(
                                                            'Loading...',
                                                            style: TextStyle(
                                                                fontSize: 24,
                                                                color:
                                                                    linearColor),
                                                          ),
                                                        ],
                                                      ))
                                                : Stack(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          controller
                                                              .toggleControllerVisibility();
                                                        },
                                                        child: VideoPlayer(
                                                            controller
                                                                .videoPlayerController),
                                                      ),
                                                      if (controller
                                                          .isControllerVisible)
                                                        Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          right: 0,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              controller
                                                                  .togglePlayPauseControllerVisibility();
                                                            },
                                                            child: Container(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.4),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ValueListenableBuilder(
                                                                      valueListenable:
                                                                          controller
                                                                              .videoPlayerController,
                                                                      builder: (context,
                                                                          VideoPlayerValue
                                                                              value,
                                                                          child) {
                                                                        return IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            if (controller.videoPlayerController.value.isPlaying) {
                                                                              controller.videoPlayerController.pause();
                                                                            } else {
                                                                              controller.videoPlayerController.play();
                                                                            }
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            controller.videoPlayerController.value.isPlaying
                                                                                ? Icons.pause
                                                                                : Icons.play_arrow,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                30,
                                                                          ),
                                                                        );
                                                                      }),
                                                                  ValueListenableBuilder(
                                                                    valueListenable:
                                                                        controller
                                                                            .videoPlayerController,
                                                                    builder: (context,
                                                                        VideoPlayerValue
                                                                            value,
                                                                        child) {
                                                                      return Text(
                                                                        controller
                                                                            .formatDuration(value.position),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      );
                                                                    },
                                                                  ),
                                                                  Text(
                                                                    " / ",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  ValueListenableBuilder(
                                                                    valueListenable:
                                                                        controller
                                                                            .videoPlayerController,
                                                                    builder: (context,
                                                                        VideoPlayerValue
                                                                            value,
                                                                        child) {
                                                                      return Text(
                                                                        controller
                                                                            .formatDuration(value.duration),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      );
                                                                    },
                                                                  ),
                                                                  ValueListenableBuilder(
                                                                    valueListenable:
                                                                        controller
                                                                            .videoPlayerController,
                                                                    builder: (context,
                                                                        VideoPlayerValue
                                                                            value,
                                                                        child) {
                                                                      return Expanded(
                                                                        child:
                                                                            Slider(
                                                                          value: value
                                                                              .position
                                                                              .inMilliseconds
                                                                              .toDouble(),
                                                                          min:
                                                                              0,
                                                                          max: value
                                                                              .duration
                                                                              .inMilliseconds
                                                                              .toDouble(),
                                                                          onChanged:
                                                                              (newValue) {
                                                                            controller.videoPlayerController.seekTo(
                                                                              Duration(milliseconds: newValue.toInt()),
                                                                            );
                                                                          },
                                                                          activeColor:
                                                                              Colors.white,
                                                                          inactiveColor:
                                                                              Colors.grey,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                  // **Current Time**
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 20, top: 20),
                                          child: SizedBox(
                                            height: kWidth / 3.6,
                                            width: kWidth / 5,
                                            child: GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 1,
                                                mainAxisSpacing: 15,
                                                crossAxisSpacing: 15,
                                                childAspectRatio: 8.2,
                                              ),
                                              itemCount: 6,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return GestureDetector(
                                                  onTapDown: (TapDownDetails
                                                      onTapDetails) {
                                                    controller.onClick(
                                                        index,
                                                        onTapDetails
                                                            .globalPosition);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF3B465A),
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          color: Colors.white,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      child: Row(
                                                        children: [
                                                          if (index != 5)
                                                            Image.asset(
                                                                "assets/images/pl${index + 1}.png",
                                                                width: displayWidth(
                                                                        context) *
                                                                    0.05),
                                                          if (index == 5)
                                                            SizedBox(
                                                                width:
                                                                    getWidgetWidth(
                                                                        width:
                                                                            5)),
                                                          if (index == 5)
                                                            Icon(
                                                              Icons.mic,
                                                              color:
                                                                  Colors.white,
                                                              size:
                                                                  getWidgetHeight(
                                                                      height:
                                                                          33),
                                                            ),
                                                          if (index == 5)
                                                            SizedBox(
                                                              width:
                                                                  getWidgetWidth(
                                                                      width: 7),
                                                            ),
                                                          SizedBox(
                                                              width:
                                                                  getWidgetWidth(
                                                                      width:
                                                                          8)),
                                                          Text(
                                                            index == 0
                                                                ? "Front View"
                                                                : index == 1
                                                                    ? "Side View"
                                                                    : index == 2
                                                                        ? "Front Closer"
                                                                        : index ==
                                                                                3
                                                                            ? "Side Closer"
                                                                            : index == 4
                                                                                ? "Animation"
                                                                                : "Practice",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: kText
                                                                    .scale(20),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
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
                                                    controller
                                                            .soundModel?.ULR ==
                                                        null)
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
                                    height: 60,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: getWidgetHeight(height: 80),
                              )
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
                            child: controller.isPlaying == false
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
                                              color: Colors.white),
                                          SizedBox(
                                            height: getWidgetHeight(height: 10),
                                          ),
                                          Text(
                                            'Loading...',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ))
                                : Stack(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            controller
                                                .toggleControllerVisibility();
                                          },
                                          child: VideoPlayer(controller
                                              .videoPlayerController)),
                                      if (controller.isControllerVisible)
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              controller
                                                  .togglePlayPauseControllerVisibility();
                                            },
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ValueListenableBuilder(
                                                      valueListenable: controller
                                                          .videoPlayerController,
                                                      builder: (context,
                                                          VideoPlayerValue
                                                              value,
                                                          child) {
                                                        return IconButton(
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
                                                          },
                                                          icon: Icon(
                                                            controller
                                                                    .videoPlayerController
                                                                    .value
                                                                    .isPlaying
                                                                ? Icons.pause
                                                                : Icons
                                                                    .play_arrow,
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                        );
                                                      }),
                                                  ValueListenableBuilder(
                                                    valueListenable: controller
                                                        .videoPlayerController,
                                                    builder: (context,
                                                        VideoPlayerValue value,
                                                        child) {
                                                      return Text(
                                                        controller
                                                            .formatDuration(
                                                                value.position),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      );
                                                    },
                                                  ),
                                                  Text(
                                                    " / ",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  ValueListenableBuilder(
                                                    valueListenable: controller
                                                        .videoPlayerController,
                                                    builder: (context,
                                                        VideoPlayerValue value,
                                                        child) {
                                                      return Text(
                                                        controller
                                                            .formatDuration(
                                                                value.duration),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      );
                                                    },
                                                  ),
                                                  ValueListenableBuilder(
                                                    valueListenable: controller
                                                        .videoPlayerController,
                                                    builder: (context,
                                                        VideoPlayerValue value,
                                                        child) {
                                                      return Expanded(
                                                        child: Slider(
                                                          value: value.position
                                                              .inMilliseconds
                                                              .toDouble(),
                                                          min: 0,
                                                          max: value.duration
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
                                                          },
                                                          activeColor:
                                                              Colors.white,
                                                          inactiveColor:
                                                              Colors.grey,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  // **Current Time**
                                                ],
                                              ),
                                            ),
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
                                onTapDown: (TapDownDetails onTapDetails) {
                                  controller.onClick(
                                      index, onTapDetails.globalPosition);
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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hotelmanagementapp/controller/sound_page_controller.dart';
import 'package:hotelmanagementapp/public/common_function.dart';
import 'package:hotelmanagementapp/public/constant.dart';
import 'package:hotelmanagementapp/public/keys.dart';
import 'package:hotelmanagementapp/route/route_name.dart';
import 'package:hotelmanagementapp/utility/custome_bottom_navigation.dart';
import 'package:hotelmanagementapp/utility/web_top_nav.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoundPageController>(builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFF2F4F7),
        floatingActionButton: !kIsWeb ? const CustomeBottomNavigation() : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          children: [
            /// ───────── WEB HEADER ─────────
            if (kIsWeb)
              WebHeaderWithNav(
                title: controller.title,
                onBack: () {
                  mainCategoryTitle = "Sounds";
                  timestampIndex = 6;
                  subCategoryTitle = controller.title;
                  sessionName = "";
                  stopTimerMainCategory();
                  Get.rootDelegate.offNamed(AppRoutes.languageLab);
                },
              ),

            /// ───────── MAIN CONTENT ─────────
            Expanded(
              child: controller.pageLoading
                  ? Center(
                      child: CircularProgressIndicator(color: linearColor),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// ───── VIDEO COLUMN ─────
                        Expanded(
                          flex: 7,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E3A48),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: controller.isPlaying
                                      ? MouseRegion(
                                          cursor: controller.isMouseIdle
                                              ? SystemMouseCursors.none
                                              : SystemMouseCursors.basic,
                                          onHover: (_) {
                                            if (kIsWeb) {
                                              controller.onMouseMove();
                                            }
                                          },
                                          onExit: (_) {
                                            if (kIsWeb) {
                                              controller.isControllerVisible =
                                                  false;
                                              controller.update();
                                            }
                                          },
                                          child: Stack(
                                            children: [
                                              /// VIDEO
                                              GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .toggleControllerVisibility();
                                                },
                                                child: VideoPlayer(controller
                                                    .videoPlayerController),
                                              ),

                                              /// CONTROLS (BOTTOM)
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: AnimatedOpacity(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  opacity: controller
                                                          .isControllerVisible
                                                      ? 1
                                                      : 0,
                                                  child: IgnorePointer(
                                                    ignoring: !controller
                                                        .isControllerVisible,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 8),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Colors.transparent,
                                                            Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                          ],
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          /// PLAY / PAUSE
                                                          ValueListenableBuilder(
                                                            valueListenable:
                                                                controller
                                                                    .videoPlayerController,
                                                            builder: (_,
                                                                VideoPlayerValue
                                                                    value,
                                                                __) {
                                                              return IconButton(
                                                                icon: Icon(
                                                                  value.isPlaying
                                                                      ? Icons
                                                                          .pause
                                                                      : Icons
                                                                          .play_arrow,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                onPressed: () {
                                                                  value.isPlaying
                                                                      ? controller
                                                                          .videoPlayerController
                                                                          .pause()
                                                                      : controller
                                                                          .videoPlayerController
                                                                          .play();
                                                                },
                                                              );
                                                            },
                                                          ),

                                                          /// TIME
                                                          ValueListenableBuilder(
                                                            valueListenable:
                                                                controller
                                                                    .videoPlayerController,
                                                            builder: (_,
                                                                VideoPlayerValue
                                                                    value,
                                                                __) {
                                                              return Text(
                                                                "${controller.formatDuration(value.position)} / ${controller.formatDuration(value.duration)}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              );
                                                            },
                                                          ),

                                                          const SizedBox(
                                                              width: 12),

                                                          /// SEEK BAR
                                                          Expanded(
                                                            child:
                                                                ValueListenableBuilder(
                                                              valueListenable:
                                                                  controller
                                                                      .videoPlayerController,
                                                              builder: (_,
                                                                  VideoPlayerValue
                                                                      value,
                                                                  __) {
                                                                return Slider(
                                                                  value: value
                                                                      .position
                                                                      .inMilliseconds
                                                                      .toDouble(),
                                                                  max: value
                                                                      .duration
                                                                      .inMilliseconds
                                                                      .toDouble(),
                                                                  onChanged:
                                                                      (v) {
                                                                    controller
                                                                        .videoPlayerController
                                                                        .seekTo(
                                                                      Duration(
                                                                          milliseconds:
                                                                              v.toInt()),
                                                                    );
                                                                  },
                                                                  activeColor:
                                                                      Colors
                                                                          .white,
                                                                  inactiveColor:
                                                                      Colors
                                                                          .white30,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        ),
                                ),
                              ),

                              /// ───── ULR (ATTACHED, NO GAP) ─────
                              Container(
                                height: 48,
                                margin:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Usual Letter Representations:",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                          (controller.soundModel?.ULR == "" ||
                                                  controller.soundModel?.ULR ==
                                                      null)
                                              ? "Empty"
                                              : controller.soundModel!.ULR,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ───── ACTION SIDEBAR ─────
                        Container(
                          width: 320,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              left: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: _ActionList(controller),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}

/// ───────────────── VIDEO CONTROLS (RESTORED) ─────────────────
class _VideoControls extends StatelessWidget {
  final SoundPageController controller;
  const _VideoControls(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.black.withOpacity(0.65),
      child: Row(
        children: [
          /// PLAY / PAUSE
          ValueListenableBuilder(
            valueListenable: controller.videoPlayerController,
            builder: (_, VideoPlayerValue value, __) {
              return IconButton(
                icon: Icon(
                  value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  value.isPlaying
                      ? controller.videoPlayerController.pause()
                      : controller.videoPlayerController.play();
                },
              );
            },
          ),

          /// CURRENT TIME
          ValueListenableBuilder(
            valueListenable: controller.videoPlayerController,
            builder: (_, VideoPlayerValue value, __) {
              return Text(
                controller.formatDuration(value.position),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              );
            },
          ),

          const Text(" / ",
              style: TextStyle(color: Colors.white, fontSize: 12)),

          /// TOTAL DURATION
          ValueListenableBuilder(
            valueListenable: controller.videoPlayerController,
            builder: (_, VideoPlayerValue value, __) {
              return Text(
                controller.formatDuration(value.duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              );
            },
          ),

          /// SEEK BAR
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: controller.videoPlayerController,
              builder: (_, VideoPlayerValue value, __) {
                return Slider(
                  value: value.position.inMilliseconds.toDouble(),
                  min: 0,
                  max: value.duration.inMilliseconds.toDouble(),
                  onChanged: (v) {
                    controller.videoPlayerController
                        .seekTo(Duration(milliseconds: v.toInt()));
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey.shade500,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ───────────────── ACTION LIST ─────────────────
class _ActionList extends StatelessWidget {
  final SoundPageController controller;
  const _ActionList(this.controller);

  @override
  Widget build(BuildContext context) {
    final labels = [
      "Front View",
      "Side View",
      "Front Closer",
      "Side Closer",
      "Animation",
      "Practice",
    ];

    return Column(
      children: List.generate(labels.length, (i) {
        return _ActionTile(
          label: labels[i],
          index: i,
          controller: controller,
        );
      }),
    );
  }
}

class _ActionTile extends StatefulWidget {
  final String label;
  final int index;
  final SoundPageController controller;

  const _ActionTile({
    required this.label,
    required this.index,
    required this.controller,
  });

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTapDown: (d) =>
            widget.controller.onClick(widget.index, d.globalPosition),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: hover ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              widget.index != 5
                  ? Image.asset(
                      "assets/images/pl${widget.index + 1}.png",
                      width: 22,
                    )
                  : const Icon(Icons.mic, size: 20),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

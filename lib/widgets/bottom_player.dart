import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:musicplayer/constrants/app_colors.dart';
import 'package:musicplayer/controller/audio_controller.dart';
import 'package:musicplayer/screen/player_screen.dart';
import 'package:musicplayer/widgets/m_button.dart';

class BottomPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioController = AudioController();
    return ValueListenableBuilder(
      valueListenable: audioController.currentIndex,
      builder: (context, currentIndexx, _) {
        final currentSong = audioController.currentSong;
        if (currentSong == null) return SizedBox.shrink();
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PlayerScreen(song: currentSong, index: currentIndexx),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(100),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(21),
                topRight: Radius.circular(21),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(8, 8),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-8, -8),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: SizedBox(
                    height: 20,
                    child: Marquee(
                      text: currentSong.title.split('/').last,
                      blankSpace: 50,
                      startPadding: 30,
                      velocity: 10,
                    ),
                  ),
                ),
                StreamBuilder<Duration>(
                  stream: audioController.audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    final possition = snapshot.data ?? Duration.zero;
                    final duration =
                        audioController.audioPlayer.duration ?? Duration.zero;
                    return Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: ProgressBar(
                        progress: possition,
                        total: duration,
                        progressBarColor: Color(0xFF4A5668),
                        baseBarColor: Colors.black,
                        bufferedBarColor: Colors.black12,
                        thumbColor: Color(0xFF4A5668),
                        barHeight: 5,
                        thumbRadius: 6,
                        timeLabelLocation: TimeLabelLocation.none,
                        onSeek: (duration) {
                          audioController.audioPlayer.seek(duration);
                        },
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    SizedBox(
                      child: Lottie.asset(
                        "assets/animation/Music fly.json",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(child: SizedBox()),
                    Row(
                      children: [
                        MButton(
                          blurFirstColor: Colors.white54,
                          blurSecondColor: Colors.white54,
                          btnBackGround: Colors.greenAccent.shade200,
                          child: Icon(Icons.skip_previous_rounded),
                          onpress: () {
                            audioController.previousSong();
                          },
                        ),
                        SizedBox(width: 16),
                        StreamBuilder(
                          stream: audioController.audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            final playerstate = snapshot.data;
                            final processingstate =
                                playerstate?.processingState;
                            final playing = playerstate?.playing;
                            if (processingstate == ProcessingState.loading ||
                                processingstate == ProcessingState.buffering) {
                              return Container(
                                margin: EdgeInsets.all(8),
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              );
                            }
                            return MButton(
                              child: Icon(
                                playing == true
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: playing == true
                                    ? AppColors.primary
                                    : Colors.black,
                              ),
                              onpress: audioController.togglePlayPause,
                            );
                          },
                        ),
                        SizedBox(width: 16),
                        MButton(
                          blurFirstColor: Colors.white54,
                          blurSecondColor: Colors.white54,
                          btnBackGround: Colors.greenAccent.shade200,
                          child: Icon(Icons.skip_next_rounded),
                          onpress: () {
                            audioController.nextSong();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

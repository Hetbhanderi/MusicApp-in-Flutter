import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:musicplayer/constrants/app_colors.dart';
import 'package:musicplayer/controller/audio_controller.dart';
import 'package:musicplayer/model/local_song_model.dart';
import 'package:musicplayer/utils/custom_text_style.dart';
import 'package:musicplayer/widgets/m_button.dart';

class PlayerScreen extends StatefulWidget {
  final LocalSongModel song;
  final int index;

  const PlayerScreen({super.key, required this.song, required this.index});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final audioController = AudioController();
  bool isplaying = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          "Now Playing",
          style: myTextStyle24(fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: MButton(
            child: Icon(Icons.arrow_back_ios_new_rounded),
            onpress: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          MButton(child: Icon(Icons.more_vert_rounded), onpress: () {}),
          SizedBox(width: 12),
        ],
        backgroundColor: AppColors.secondary,
      ),
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    "assets/animation/Music fly.json",
                    fit: BoxFit.cover,
                    height: 300,
                    width: 300,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 30,
                    child: Marquee(
                      startPadding: 30,
                      velocity: 30,
                      style: myTextStyle18(fontColor: Colors.black45),
                      text: widget.song.title.toString().split("/").last,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(widget.song.artist, style: myTextStyle15()),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsetsGeometry.all(12),
                    child: StreamBuilder<Duration>(
                      stream: audioController.audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration =
                            audioController.audioPlayer.duration ??
                            Duration.zero;
                        return ProgressBar(
                          progress: position,
                          total: duration,
                          progressBarColor: AppColors.primary,
                          baseBarColor: Colors.black12,
                          thumbColor: AppColors.primary,
                          onSeek: (duration) {
                            audioController.audioPlayer.seek(duration);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MButton(
                        child: Icon(Icons.skip_previous_rounded, size: 30),
                        onpress: audioController.previousSong,
                      ),
                      StreamBuilder<PlayerState>(
                        stream: audioController.audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final playing = playerState?.playing ?? false;
                          final processingState = playerState?.processingState;

                          IconData icon;

                          if (processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering) {
                            icon = Icons.hourglass_empty_rounded; // ⏳ loading
                          } else if (!playing) {
                            icon = Icons.play_arrow_rounded; // ▶️ play
                          } else {
                            icon = Icons.pause_rounded; // ⏸ pause
                          }

                          return MButton(
                            btnBackGround: AppColors.primary,
                            child: Icon(icon, size: 40),
                            onpress: () => audioController.togglePlayPause(),
                          );
                        },
                      ),

                      // MButton(
                      //   btnBackGround: AppColors.primary,
                      //   child: Icon(
                      //     isplaying
                      //         ? Icons.play_arrow_rounded
                      //         : Icons.pause_rounded,
                      //     size: 40,
                      //   ),
                      //   onpress: () {
                      //     setState(() {
                      //       isplaying = !isplaying;
                      //     });
                      //     audioController.togglePlayPause();
                      //   },
                      // ),
                      MButton(
                        child: Icon(Icons.skip_next_rounded, size: 30),
                        onpress: audioController.nextSong,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

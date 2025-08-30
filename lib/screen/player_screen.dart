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
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreen extends StatefulWidget {
  final LocalSongModel song;
  final int index;

  const PlayerScreen({super.key, required this.song, required this.index});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final audioController = AudioController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        title: Text(
          "Now Playing",
          style: myTextStyle24(fontWeight: FontWeight.bold),
        ),
        leading: MButton(
          child: Icon(Icons.arrow_back_ios_new_rounded),
          onpress: () => Navigator.pop(context),
          btnBackGround: AppColors.secondary,
          blurFirstColor: const Color.fromARGB(255, 196, 202, 211),
          blurSecondColor: AppColors.secondary,
        ),
        actions: [
          MButton(child: Icon(Icons.more_vert_rounded), onpress: () {}),
        ],
        backgroundColor: AppColors.secondary,
      ),
      body: SafeArea(
        child: Center(
          child: ValueListenableBuilder<int>(
            valueListenable: audioController.currentIndex,
            builder: (context, currentIndex, _) {
              if (currentIndex == -1 || audioController.songs.value.isEmpty) {
                return CircularProgressIndicator(color: AppColors.primary);
              }

              final song = audioController.songs.value[currentIndex];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        artworkFit: BoxFit.cover,
                        artworkBorder: BorderRadius.circular(12),
                        nullArtworkWidget: Lottie.asset(
                          "assets/animation/Music fly.json",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 30,
                    child: Marquee(
                      startPadding: 30,
                      velocity: 30,
                      text: song.title.split("/").last,
                      style: myTextStyle18(fontColor: Colors.black45),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(song.artist, style: myTextStyle15()),
                  SizedBox(height: 20),
                  StreamBuilder<Duration>(
                    stream: audioController.audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration =
                          audioController.audioPlayer.duration ?? Duration.zero;
                      return ProgressBar(
                        progress: position,
                        total: duration,
                        progressBarColor: AppColors.primary,
                        baseBarColor: Colors.black12,
                        thumbColor: AppColors.primary,
                        onSeek: (duration) =>
                            audioController.audioPlayer.seek(duration),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MButton(
                        child: Icon(Icons.skip_previous_rounded, size: 30),
                        onpress: () => audioController.previousSong(),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: audioController.isPlaying,
                        builder: (context, playing, _) => MButton(
                          btnBackGround: AppColors.primary,
                          child: Icon(
                            playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 40,
                          ),
                          onpress: () => audioController.togglePlayPause(),
                        ),
                      ),
                      MButton(
                        child: Icon(Icons.skip_next_rounded, size: 30),
                        onpress: () => audioController.nextSong(),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

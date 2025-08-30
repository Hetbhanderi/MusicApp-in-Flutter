import 'package:flutter/material.dart';
import 'package:musicplayer/constrants/app_colors.dart';
import 'package:musicplayer/controller/audio_controller.dart';
import 'package:musicplayer/model/local_song_model.dart';
import 'package:musicplayer/screen/player_screen.dart';
import 'package:musicplayer/utils/custom_text_style.dart';
import 'package:musicplayer/widgets/m_button.dart';
import 'package:musicplayer/widgets/m_container.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListItem extends StatefulWidget {
  final LocalSongModel song;
  final index;

  const SongListItem({super.key, required this.song, this.index});

  @override
  State<SongListItem> createState() => _SongListItemState();
}

class _SongListItemState extends State<SongListItem> {
  String _formatSongDuretion(int milliseonds) {
    final minutes = (milliseonds / 60000).floor();
    final seconds = ((milliseonds % 60000) / 1000).floor();
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final audioController = AudioController();
    return ValueListenableBuilder(
      valueListenable: audioController.currentIndex,
      builder: (context, currentIndex, child) {
        return ValueListenableBuilder(
          valueListenable: audioController.isPlaying,
          builder: (context, isPlaying, child) {
            final isCurrentSong = currentIndex == widget.index;
            return Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: MContainer(
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: QueryArtworkWidget(
                      id: widget.song.id,
                      type: ArtworkType.AUDIO,
                      artworkFit: BoxFit.cover,
                      artworkBorder: BorderRadius.circular(
                        8,
                      ), // ✅ rounded corners
                      nullArtworkWidget: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // match rounded corners
                        ),
                        child: Icon(Icons.music_note, color: Colors.white54),
                      ),
                    ),
                  ),

                  title: Text(
                    widget.song.title,
                    style: myTextStyle15(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    widget.song.artist,
                    style: myTextStyle12(fontColor: Colors.black26),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatSongDuretion(widget.song.duration),
                        style: myTextStyle12(fontColor: Colors.black26),
                      ),
                      SizedBox(width: 8),
                      MButton(
                        child: Icon(
                          isCurrentSong && isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: isCurrentSong && isPlaying
                              ? AppColors.primary
                              : Colors.black54,
                          size: 27,
                        ),
                        onpress: () {
                          if (isCurrentSong) {
                            audioController.togglePlayPause();
                          } else {
                            audioController.playsong(widget.index);
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // audioController.playsong(widget.index);
                    if (isCurrentSong) {
                    } else {
                      audioController.playsong(widget.index);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          song: widget.song,
                          index: widget.index,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:musicplayer/constrants/app_colors.dart';
import 'package:musicplayer/controller/audio_controller.dart';
import 'package:musicplayer/model/local_song_model.dart';
import 'package:musicplayer/utils/custom_text_style.dart';
import 'package:musicplayer/widgets/bottom_player.dart';
import 'package:musicplayer/widgets/m_button.dart';
import 'package:musicplayer/widgets/song_list_item.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart'; // 👈 needed for permission request

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({super.key});

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  final AudioController _audioController = AudioController();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    // Check if permission already granted
    bool alreadyGranted = await _audioQuery.permissionsStatus();
    if (alreadyGranted) {
      // ✅ Permission already granted
      setState(() => _hasPermission = true);
      await _loadSongs();
    } else {
      // ❌ Permission not granted → request it
      bool grantedNow = await _audioQuery.permissionsRequest();

      if (grantedNow) {
        // ✅ User granted permission now
        setState(() => _hasPermission = true);
        await _loadSongs();
      } else {
        // 🚫 User denied permission
        setState(() => _hasPermission = false);

        // Optional: show a snackbar or dialog
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Permission is required to show songs")),
        // );
      }
    }
  }

  Future<void> _loadSongs() async {
    await _audioController.loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.secondary,
        title: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Text(
                  "🎵 All ",
                  style: myTextStyle36(fontWeight: FontWeight.bold),
                ),
              ),
              WidgetSpan(
                child: Text(
                  "Songs",
                  style: myTextStyle36(
                    fontWeight: FontWeight.bold,
                    fontColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: 80,
        leading: Padding(
          padding: EdgeInsets.all(4),
          child: MButton(child: Icon(Icons.person), onpress: () {}),
        ),
        actions: [
          MButton(child: Icon(Icons.favorite_border_rounded), onpress: () {}),
          SizedBox(width: 16),
          MButton(child: Icon(Icons.settings), onpress: () {}),
          SizedBox(width: 12),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: _audioController.songs,
          builder: (context, songs, child) {
            if (songs.isEmpty) {
              return CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 8,
              );
            } else {
              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return SongListItem(song: songs[index], index: index);
                },
              );
            }
          },
        ),
      ),
      bottomSheet: BottomPlayer(),
    );
  }
}

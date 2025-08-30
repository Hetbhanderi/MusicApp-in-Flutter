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
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    bool granted = false;

    // ✅ First check Android version specific permissions
    if (await Permission.storage.isGranted ||
        await Permission.audio.isGranted) {
      granted = true;
    } else {
      // ⚡ Request the proper permission
      if (await Permission.audio.request().isGranted ||
          await Permission.storage.request().isGranted) {
        granted = true;
      }
    }

    setState(() => _hasPermission = granted);

    if (granted) {
      // now use on_audio_query's internal check (must still call it)
      bool audioQueryGranted = await _audioQuery.permissionsStatus();

      if (!audioQueryGranted) {
        audioQueryGranted = await _audioQuery.permissionsRequest();
      }

      if (audioQueryGranted) {
        await _loadSongs();
      } else {
        debugPrint("❌ on_audio_query permission denied");
      }
    } else {
      debugPrint("❌ permission_handler denied");
    }
  }

  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Permission Needed",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To enjoy music, please grant the required app permissions.",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Tap 'Ok' to open app settings, enable permissions,",
                  style: TextStyle(fontSize: 14),
                ),
                Text("Then Restart the app.", style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          actions: [
            // NO Button
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.shade300,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade200.withOpacity(0.5),
                      offset: Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  "No",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12),

            // OK Button
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();

                bool opened = await openAppSettings();

                if (!opened) {
                  debugPrint("❌ Could not open app settings");
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.green.shade600, Colors.green.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade300.withOpacity(0.5),
                      offset: Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  "Ok",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Example button to call the dialog
  Widget permissionButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          showPermissionDialog(context);
        },
        icon: Icon(Icons.lock_open),
        label: Text("Give Permission"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
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
                  // "🎵 M ",
                  "M",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              WidgetSpan(
                child: Text(
                  "Player",
                  style: myTextStyle24(
                    fontWeight: FontWeight.bold,
                    fontColor: AppColors.dark,
                  ),
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: 80,
        // leading: Padding(
        //   padding: EdgeInsets.all(4),
        //   child: MButton(child: Icon(Icons.person), onpress: () {}),
        // ),
        actions: [
          // MButton(child: Icon(Icons.favorite_border_rounded), onpress: () {}),
          // SizedBox(width: 16),
          MButton(child: Icon(Icons.settings), onpress: () {}),
          SizedBox(width: 12),
        ],
      ),
      // body: Center(
      //   child: ValueListenableBuilder(
      //     valueListenable: _audioController.songs,
      //     builder: (context, songs, child) {
      //       if (songs.isEmpty) {
      //         return CircularProgressIndicator(
      //           color: AppColors.primary,
      //           strokeWidth: 8,
      //         );
      //       } else {
      //         return ListView.builder(
      //           itemCount: songs.length,
      //           itemBuilder: (context, index) {
      //             return SongListItem(song: songs[index], index: index);
      //           },
      //         );
      //       }
      //     },
      //   ),
      // ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: _audioController.songs,
          builder: (context, songs, child) {
            if (!_hasPermission) {
              // Permission denied → show button
              return permissionButton(context);
            } else if (songs.isEmpty) {
              // Permission granted → still loading songs
              return CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 8,
              );
            } else {
              // Songs loaded → show list
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

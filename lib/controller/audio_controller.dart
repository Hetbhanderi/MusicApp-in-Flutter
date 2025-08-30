import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:musicplayer/model/local_song_model.dart';

class AudioController {
  static final AudioController instance = AudioController._instance();
  factory AudioController() => instance;
  AudioController._instance() {
    _setupAudioPlayer();
  }

  final AudioPlayer audioPlayer = AudioPlayer();
  final OnAudioQuery audioQuery = OnAudioQuery();
  final ValueNotifier<List<LocalSongModel>> songs =
      ValueNotifier<List<LocalSongModel>>([]);
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(-1);
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);

  LocalSongModel? get currentSong =>
      currentIndex.value != -1 && currentIndex.value < songs.value.length
      ? songs.value[currentIndex.value]
      : null;
  void _setupAudioPlayer() {
    audioPlayer.playerStateStream.listen((PlayerState) {
      isPlaying.value = PlayerState.playing;

      if (PlayerState.processingState == ProcessingState.completed) {
        if (currentIndex.value < songs.value.length - 1) {
          playsong(currentIndex.value + 1);
        } else {
          currentIndex.value = -1;
          isPlaying.value = false;
        }
      }
    });
    audioPlayer.positionStream.listen((event) {
      isPlaying.notifyListeners();
    });
  }

  Future<void> loadSongs() async {
    final fetchSongs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    // songs.value = fetchSongs
    //     .map(
    //       (songs) => LocalSongModel(
    //         id: songs.id,
    //         title: songs.title,
    //         artist: songs.artist ?? "Unknown",
    //         uri: songs.uri ?? "",
    //         albumArt: songs.album ?? "",
    //         duration: songs.duration ?? 0,
    //       ),
    //     )
    //     .toList();

    songs.value = await Future.wait(
      fetchSongs.map((song) async {
        // try to get artwork for each song
        final artwork = await audioQuery.queryArtwork(
          song.id,
          ArtworkType.AUDIO,
        );

        return LocalSongModel(
          id: song.id,
          title: song.title,
          artist: song.artist ?? "Unknown",
          uri: song.uri ?? "",
          albumArt: (artwork != null && artwork.isNotEmpty)
              ? "data:image/png;base64,${base64Encode(artwork)}"
              : "asset://assets/images/360_F_1574389014_vVKXWEWhq2ffeFdtYqUiwvZf1WZtqfV7.jpg", // fallback
          duration: song.duration ?? 0,
        );
      }),
    );
  }

  Future<void> playsong(int index) async {
    if (index < 0 || index >= songs.value.length) return;
    try {
      if (currentIndex.value == index && isPlaying.value) {
        await pauseSong();
        return;
      }
      currentIndex.value = index;
      final song = songs.value[index];
      await audioPlayer.stop();
      final artwork = await audioQuery.queryArtwork(song.id, ArtworkType.AUDIO);
      await audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(song.uri),
          tag: MediaItem(
            id: song.id.toString(),
            album: song.albumArt.isNotEmpty ? song.albumArt : "Unknown Album",
            title: song.title,
            artist: song.artist,
            duration: Duration(milliseconds: song.duration),
            artUri: song.albumArt.isNotEmpty
                ? Uri.parse(song.albumArt) // If real artwork path exists
                : Uri.parse(
                    "asset://assets/images/360_F_1574389014_vVKXWEWhq2ffeFdtYqUiwvZf1WZtqfV7.jpg",
                  ), // 👈 fallback image
          ),
        ),

        preload: true,
      );
      await audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      print("Error Playing Song : $e");
    }
  }

  Future<void> pauseSong() async {
    await audioPlayer.pause();
    isPlaying.value = false;
  }

  Future<void> resumeSong() async {
    await audioPlayer.play();
    isPlaying.value = true;
  }

  void togglePlayPause() async {
    if (currentIndex.value == -1) return;
    try {
      if (isPlaying.value) {
        await pauseSong();
      } else {
        await resumeSong();
      }
    } catch (e) {
      print("Error Toggle Play/Pause : $e");
    }
  }

  Future<void> nextSong() async {
    if (currentIndex.value < songs.value.length - 1) {
      await playsong(currentIndex.value + 1);
    }
  }

  Future<void> previousSong() async {
    if (currentIndex.value > 0) {
      await playsong(currentIndex.value - 1);
    }
  }

  void dispose() {
    audioPlayer.dispose();
  }
}

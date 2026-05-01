import 'dart:async';

import 'package:fatej/CORE/File_Directory/MUSIC/file_picker.dart';
import 'package:fatej/MODEL/audioplayer_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final rAudioProvider = StreamNotifierProvider<AudioStreamer, AudioplayerModel>(
  AudioStreamer.new,
);

class AudioStreamer extends StreamNotifier<AudioplayerModel> {
  //Create a player and control player
  final _audioPlayer = AudioPlayer();

  //track model state internally
  AudioplayerModel _currentState = AudioplayerModel();

  //track File State

  //stream controller
  final _streamController = StreamController<AudioplayerModel>.broadcast();

  //Loading Time
  Timer? _timer;

  @override
  Stream<AudioplayerModel> build() {
    //
    //clean cache automatically when done
    ref.onDispose(() async {
      await _audioPlayer.dispose();
      await _streamController.close();
    });

    //track position
    _audioPlayer.positionStream.listen((position) {
      _currentState = _currentState.copyWith(position: position);
      _streamController.add(_currentState);
    });

    //track duration
    _audioPlayer.durationStream.listen((duration) {
      _currentState = _currentState.copyWith(
        duration: duration ?? Duration.zero,
      );
      _streamController.add(_currentState);
    });

    //track Play/Pause
    _audioPlayer.playingStream.listen((isPlaying) {
      _currentState = _currentState.copyWith(isPlaying: isPlaying);
      _streamController.add(_currentState);
    });

    return _streamController.stream;
  }

  //Load a song
  Future<void> zLoadingSong(int index) async {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 300), () async {
      final song = ref.read(rFileProvider).value;
      if (song == null || song.isEmpty) return;

      try {
        if (song[index].songSource!.startsWith('assets/')) {
          await _audioPlayer.setAsset(song[index].songSource!);
        } else {
          await _audioPlayer.setFilePath(song[index].songSource!);
        }

        _currentState = _currentState.copyWith(currentSongIndex: index);
        _streamController.add(_currentState);
      } catch (e) {
        if (e.toString().contains('Loading interrupted')) return;
      }
    });
  }

  //Play a song
  Future<void> zPlaySong(int index) async {
    await zLoadingSong(index);
    await _audioPlayer.play();

    _currentState = _currentState.copyWith(currentSongIndex: index);
    _streamController.add(_currentState);
  }

  //Play/Pause
  Future<void> zPlayPause() async {
    _audioPlayer.playing
        ? await _audioPlayer.pause()
        : await _audioPlayer.play();
  }

  //seek
  Future<void> zSeeker(Duration seeker) async {
    await _audioPlayer.seek(seeker);
  }

  Future<void> zStop() async {
    await _audioPlayer.stop();
  }
}

class AudioplayerModel {
  AudioplayerModel({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.currentSongIndex = 0,
  });
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final int currentSongIndex;

  AudioplayerModel copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    int? currentSongIndex,
  }) => AudioplayerModel(
    isPlaying: isPlaying ?? this.isPlaying,
    position: position ?? this.position,
    duration: duration ?? this.duration,
    currentSongIndex: currentSongIndex ?? this.currentSongIndex,
  );
}

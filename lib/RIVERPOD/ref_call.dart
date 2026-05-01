import 'package:fatej/MODEL/song_model.dart';
import 'package:riverpod/legacy.dart';

final rSongProvider = StateProvider<List<SongModel>>((_) => systemSong);
final rScreenIndexProvider = StateProvider<int>((_) => 0);
final rCheckSwitchScreenButton = StateProvider<bool>((_) => false);
final rCheckSwitchScreenColor = StateProvider<bool>((_) => false);
final rScreenColorIndexProvider = StateProvider<int>((_) => 0);

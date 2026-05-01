import 'dart:io';

import 'package:fatej/CORE/Database/SQFLITE/sqflite.dart';
import 'package:fatej/CORE/Permission/permission_handler.dart';
import 'package:fatej/MODEL/song_model.dart';
import 'package:fatej/RIVERPOD/just_audio_function.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final rFileProvider = AsyncNotifierProvider<FileNotifier, List<SongModel>>(
  FileNotifier.new,
);

class FileNotifier extends AsyncNotifier<List<SongModel>> {
  @override
  Future<List<SongModel>> build() async {
    final songDatabase = await DatabaseHome.instance.obtainSong();
    return [...systemSong, ...songDatabase];
  }

  Future<void> pickAudioFile() async {
    try {
      //Request Permission
      await PermissionHandler.instance.requestAndroidPermission();

      //Pick MP3 File
      final result = await FilePicker.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['mp3', 'aac', 'm3u'],
      );

      // If MP3 File is Empty, Return Nothing
      if (result == null) return;

      //Get MP3 File
      final file = result.files.first;

      //New Directory
      final dir = await getApplicationDocumentsDirectory();

      //Fixed Path Name
      final sameDir = join(dir.path, file.name);

      await File(file.path!).copy(sameDir); // Change Directory Path Name

      // if Data Match == True
      final existedSong = state.value!.any(
        (element) => element.songSource == sameDir,
      );

      // If True Return Nothing
      if (existedSong) return;

      //------ Pick Image File
      XFile? imagePicker = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      // If Image Null Update Only Title and Song Source
      if (imagePicker == null || imagePicker.path.isEmpty) {
        final newSong = SongModel(
          title: file.name,
          songSource: sameDir,
          image: null,
        );
        final inID = await DatabaseHome.instance.insert(newSong);

        final outID = newSong.copySong(id: inID);

        state = AsyncData([...?state.value, outID]);
      }
      // If Everything Fine. Update Everything
      else {
        final newSong = SongModel(
          title: file.name,
          songSource: sameDir,
          image: imagePicker.path,
        );
        final inID = await DatabaseHome.instance.insert(newSong);
        final outID = newSong.copySong(id: inID);

        state = AsyncData([...?state.value, outID]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Pick Image
  Future<void> pickImageFile(SongModel song) async {
    if (song.id == null) return;

    XFile? result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result == null) return;

    final newImage = song.copySong(image: result.path);

    await DatabaseHome.instance.updateImage(song.id!, result.path);

    state = AsyncData([
      ...state.value!.map(
        (oldState) => oldState.id == song.id ? newImage : oldState,
      ),
    ]);
  }

  //Delete
  Future<void> delete(SongModel song) async {
    if (song.id == null) return;

    await ref.read(rAudioProvider.notifier).zStop();

    await DatabaseHome.instance.delete(song.id!);

    state = AsyncData(
      state.value!.where((element) => element.id != song.id).toList(),
    );
  }

  //Reset
  Future<void> reset() async {
    await ref.read(rAudioProvider.notifier).zStop();

    await DatabaseHome.instance.reset();

    state = AsyncData(systemSong);
  }
}

import 'package:fatej/CORE/File_Directory/MUSIC/file_picker.dart';
import 'package:fatej/CUSTOM_WIDGET/Customization/customized_widget.dart';
import 'package:fatej/RIVERPOD/just_audio_function.dart';
import 'package:fatej/RIVERPOD/ref_call.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageViewSliderWidget extends ConsumerStatefulWidget {
  const PageViewSliderWidget({super.key, this.trackColorIndex});
  final int? trackColorIndex;

  @override
  ConsumerState<PageViewSliderWidget> createState() => _PageViewSlideWidget();
}

class _PageViewSlideWidget extends ConsumerState<PageViewSliderWidget> {
  PageController controller = PageController();
  bool goesByOne = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(rFileProvider);
    ref.listen(rAudioProvider, (previous, next) {
      next.whenData((state) {
        final songs = data.value;
        if (songs == null || songs.isEmpty) return null;

        final currentPage = controller.page?.round() ?? 0;
        final nextPage = currentPage + 1;

        //duration && position
        final duration = state.duration.inSeconds;
        final position = state.position.inSeconds;

        // prevent multiple playnext, just play one
        if (position <= 1) return goesByOne = false;

        // Check the song near end duration
        bool isNearEnd = duration > 0 && position >= duration - 1;

        if (isNearEnd && !goesByOne) {
          goesByOne = true;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            if (!mounted) return;
            if (!controller.hasClients) return;

            if (nextPage >= data.value!.length) {
              controller.jumpToPage(0);
            } else {
              await controller.nextPage(
                duration: Duration(milliseconds: 400),
                curve: Curves.bounceInOut,
              );
            }
          });
        }
      });
    });
    return data.when(
      error: (error, stackTrace) => Center(child: Text('Error$error')),
      loading: () => Center(child: CircularProgressIndicator()),
      data: (dataX) {
        return PageView.builder(
          clipBehavior: Clip.none,
          controller: controller,
          itemCount: dataX.length,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) async {
            await ref.read(rAudioProvider.notifier).zPlaySong(index);
            ref.read(rScreenIndexProvider.notifier).state = index;
          },
          itemBuilder: (context, index) {
            return GestureDetector(
              //delete Data
              onDoubleTap: () async {
                await ref.read(rFileProvider.notifier).delete(dataX[index]);

                if (!mounted) return;

                final newLength = ref.read(rFileProvider).value?.length ?? 0;
                if (newLength == 0) return;

                final safeIndex = (index - 1).clamp(0, newLength - 1);
                controller.jumpToPage(safeIndex);

                ref.read(rScreenIndexProvider.notifier).state = safeIndex;
                ref.read(rAudioProvider.notifier).zPlaySong(safeIndex);
              },
              //--add/update image
              onLongPress: () async {
                await ref
                    .read(rFileProvider.notifier)
                    .pickImageFile(dataX[ref.read(rScreenIndexProvider)]);
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: NeumorphismWidget(
                  padding: const EdgeInsets.all(15),
                  shape: BoxShape.circle,
                  color: customizedColors[widget.trackColorIndex ?? 0],
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageSolutionFirst(dataX[index].image ?? ''),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

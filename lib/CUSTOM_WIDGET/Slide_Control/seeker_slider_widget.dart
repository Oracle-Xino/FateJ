import 'package:fatej/CUSTOM_WIDGET/COLOR/constant_color.dart';
import 'package:fatej/CUSTOM_WIDGET/Customization/customized_widget.dart';
import 'package:fatej/RIVERPOD/just_audio_function.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:fatej/RIVERPOD/ref_call.dart';

class SeekerSliderWidget extends ConsumerStatefulWidget {
  const SeekerSliderWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeekerSliderWidget();
}

class _SeekerSliderWidget extends ConsumerState<SeekerSliderWidget> {
  @override
  Widget build(BuildContext context) {
    // final song = ref.watch(rSongProvider);
    final data = ref.watch(rAudioProvider);
    return data.when(
      error: (error, stackTrace) => Text('Error $error'),
      loading: () => Center(child: CircularProgressIndicator()),
      data: (state) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              mySizedBox(width: 15),
              IconButton(
                iconSize: 35,
                color: ConstantColor.vWhiteColor1,
                onPressed: () {
                  ref.read(rAudioProvider.notifier).zPlayPause();
                },

                icon: state.isPlaying
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow),
              ),

              Slider(
                min: 0,
                max: state.duration.inSeconds.toDouble() == 0
                    ? 1.0
                    : state.duration.inSeconds.toDouble(),
                value: state.position.inSeconds.toDouble(),
                onChanged: (position) => ref
                    .read(rAudioProvider.notifier)
                    .zSeeker(Duration(seconds: position.toInt())),
                activeColor: ConstantColor.vOrangeColor12,
                inactiveColor: ConstantColor.vBlueColor2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

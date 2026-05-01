import 'package:fatej/CORE/File_Directory/MUSIC/file_picker.dart';
import 'package:fatej/CUSTOM_WIDGET/Slide_Control/carousel_slider.dart';
import 'package:fatej/CUSTOM_WIDGET/COLOR/constant_color.dart';
import 'package:fatej/CUSTOM_WIDGET/Customization/customized_widget.dart';
import 'package:fatej/CUSTOM_WIDGET/Slide_Control/pageview_slider.dart';
import 'package:fatej/CUSTOM_WIDGET/Slide_Control/seeker_slider_widget.dart';
import 'package:fatej/RIVERPOD/just_audio_function.dart';
import 'package:fatej/RIVERPOD/ref_call.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//Glass Screen UI
Widget glassScreen(WidgetRef ref) {
  final data = ref.watch(rFileProvider);
  final currentScreen = ref.watch(rScreenIndexProvider);

  return data.when(
    error: (error, stackTrace) => Center(child: Text('Error: $error')),
    loading: () => Center(child: CircularProgressIndicator()),
    data: (dataX) {
      return Stack(
        children: [
          //background screen image
          Center(
            child: imageSolutionSecond(
              dataX[currentScreen].image,
              customImage: 'assets/songs/images/cute_big.png',
              height: 700,
              width: 600,
              cacheHeight: 700,
              cacheWidth: 600,
            ),
          ),
          Column(
            children: [
              mySizedBox(height: 50),
              CarouselSliderWidget(
                onPageChanged: (index, reason) {
                  ref.read(rScreenIndexProvider.notifier).state = index;
                  ref.read(rAudioProvider.notifier).zPlaySong(index);
                },
              ),
              mySizedBox(height: 60),
              Container(
                height: 100,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: ConstantColor.vBrownColor3.withAlpha(50),
                ),
                child: SeekerSliderWidget(),
              ),
            ],
          ),
        ],
      );
    },
  );
}

//Neumorphism Screen UI
Widget neumorphismScreen(WidgetRef ref, BuildContext context) {
  final data = ref.watch(rFileProvider);
  final currentScreenIndex = ref.watch(rScreenIndexProvider);
  final trackColorIndex = ref.watch(rScreenColorIndexProvider);
  final checkColor = ref.watch(rCheckSwitchScreenColor);

  return data.when(
    error: (error, stackTrace) => Text('Error $error'),
    loading: () => Center(child: CircularProgressIndicator()),
    data: (dataX) {
      if (dataX.isEmpty || currentScreenIndex >= dataX.length) {
        return Center(
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Add a Song..!', style: TextStyle(fontSize: 15)),
              NeumorphismWidget(
                height: 40,
                width: 40,

                borderRadius: BorderRadius.circular(12),
                color: customizedColors[trackColorIndex],
                shape: BoxShape.rectangle,
                child: Center(
                  child: IconButton(
                    onPressed: () async {
                      await ref.read(rFileProvider.notifier).pickAudioFile();
                    },
                    icon: Icon(Icons.add_to_drive, size: 25),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Column(
        spacing: 8,
        children: [
          // Song Title
          mySizedBox(
            height: 60,
            width: 300,
            child: Text(
              dataX[currentScreenIndex].title!.replaceAll(
                RegExp(r'\.(mp3|aac|m3u|wav)$'),
                '',
              ),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),

          //PageView Slider
          Center(
            child: NeumorphismWidget(
              height: 350,
              width: 350,
              offset: Offset(0, 0),
              blurRadius: 0,
              color: customizedColors[trackColorIndex],
              shape: BoxShape.circle,
              child: PageViewSliderWidget(trackColorIndex: trackColorIndex),
            ),
          ),

          // Color Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (checkColor)
                ...List.generate(
                  customizedColors.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        final current =
                            ref.read(rScreenColorIndexProvider.notifier).state =
                                index;
                        customizedColors[current]; // display each color by index when selected
                      },
                      child: NeumorphismWidget(
                        color: customizedColors[index],
                        width: 25,
                        height: 25,
                        offset: Offset(0, 0),
                        blurRadius: 1,
                      ),
                    ),
                  ),
                )
              else
                Row(
                  spacing: 40,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Pick Audio and Image File
                    NeumorphismWidget(
                      height: 40,
                      width: 40,
                      offset: Offset(8, 8),
                      blurRadius: 8,
                      borderRadius: BorderRadius.circular(12),
                      color: customizedColors[trackColorIndex],
                      shape: BoxShape.rectangle,
                      child: Center(
                        child: IconButton(
                          onPressed: () async {
                            await ref
                                .read(rFileProvider.notifier)
                                .pickAudioFile();
                          },
                          icon: Icon(Icons.add_to_drive, size: 25),
                        ),
                      ),
                    ),

                    //Reset File
                    NeumorphismWidget(
                      height: 40,
                      width: 40,
                      offset: Offset(8, 8),
                      blurRadius: 8,
                      borderRadius: BorderRadius.circular(12),
                      color: customizedColors[trackColorIndex],
                      shape: BoxShape.rectangle,
                      child: Center(
                        child: IconButton(
                          onPressed: () async {
                            await ref.read(rFileProvider.notifier).reset();
                          },
                          icon: Icon(Icons.restore_rounded, size: 25),
                        ),
                      ),
                    ),
                  ],
                ),

              //Check to show between Color and Pick File --Button
              mySizedBox(
                width: checkColor ? 40 : 170,
                child: Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Container(
                    height: 30,
                    width: 25,
                    decoration: BoxDecoration(
                      border: Border.all(color: ConstantColor.vBlueGreyColor7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        final currentCheck = ref
                            .read(rCheckSwitchScreenColor.notifier)
                            .state;
                        ref.read(rCheckSwitchScreenColor.notifier).state =
                            !currentCheck;
                      },
                      padding: EdgeInsets.zero,
                      icon: checkColor
                          ? Icon(
                              Icons.more_horiz,
                              size: 17,
                              fontWeight: FontWeight(100 * 7),
                            )
                          : Icon(
                              Icons.more_vert,
                              size: 17,
                              fontWeight: FontWeight(100 * 7),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          mySizedBox(height: 30),

          //Seeker Slider
          NeumorphismWidget(
            height: 100,
            width: 305,
            shape: BoxShape.rectangle,
            color: customizedColors[trackColorIndex],
            borderRadius: BorderRadius.circular(12),
            child: SeekerSliderWidget(),
          ),
        ],
      );
    },
  );
}

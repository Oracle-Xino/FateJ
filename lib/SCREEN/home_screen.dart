import 'package:fatej/CORE/File_Directory/MUSIC/file_picker.dart';
import 'package:fatej/CUSTOM_WIDGET/COLOR/constant_color.dart';
import 'package:fatej/CUSTOM_WIDGET/Customization/customized_widget.dart';
import 'package:fatej/RIVERPOD/just_audio_function.dart';
import 'package:fatej/RIVERPOD/ref_call.dart';
import 'package:fatej/SCREEN/customized_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    final current = ref.read(rScreenIndexProvider);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(rAudioProvider.notifier).zPlaySong(current);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(rFileProvider);
    final switchButton = ref.watch(rCheckSwitchScreenButton);
    final currentSwitchColor = ref.watch(rScreenColorIndexProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          switchButton
              ?
                //For GlassScreen
                NeumorphismWidget(
                  height: 40,
                  width: 50,
                  color: ConstantColor.vBlackColor1,
                  offset: Offset(0, 0),
                  blurRadius: 1.5,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                  child: IconButton(
                    onPressed: () {
                      final current = ref
                          .read(rCheckSwitchScreenButton.notifier)
                          .state;
                      ref.read(rCheckSwitchScreenButton.notifier).state =
                          !current;
                    },
                    icon: Icon(
                      Icons.swap_horiz_outlined,
                      size: 27,
                      color: ConstantColor.vWhiteColor1,
                    ),
                  ),
                )
              :
                //For NeumorphismScreen
                NeumorphismWidget(
                  height: 40,
                  width: 50,
                  blurRadius: 1.5,
                  offset: Offset(0, 0),
                  color: customizedColors[currentSwitchColor],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                  child: IconButton(
                    onPressed: () {
                      final current = ref
                          .read(rCheckSwitchScreenButton.notifier)
                          .state;
                      ref.read(rCheckSwitchScreenButton.notifier).state =
                          !current;
                    },
                    icon: Icon(
                      Icons.swap_horiz_outlined,
                      size: 27,
                      color: ConstantColor.vBlackColor1,
                    ),
                  ),
                ),
          mySizedBox(width: 5),
        ],
      ),
      backgroundColor: switchButton
          ?
            //For GlassScreen
            Colors.transparent
          //For NeumorphismScreen
          : customizedColors[currentSwitchColor],
      body: data.when(
        error: (error, stackTrace) => Text('Error$error'),
        loading: () => Center(child: CircularProgressIndicator()),
        data: (dataX) {
          if (dataX.isEmpty) {
            return switchButton
                ?
                  //For GlassScreen --Add a Song
                  Center(
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Add a Song..!',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: ConstantColor.vWhiteColor1,
                          ),
                        ),
                        NeumorphismWidget(
                          height: 50,
                          width: 50,
                          blurRadius: 1.5,
                          offset: Offset(0, 0),
                          borderRadius: BorderRadius.circular(12),
                          color: ConstantColor.vWhiteColor1,
                          shape: BoxShape.rectangle,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                ref
                                    .read(rFileProvider.notifier)
                                    .pickAudioFile();
                              },
                              icon: const Icon(Icons.add_to_drive, size: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                :
                  //For NeumorphismScreen --Add a Song
                  Center(
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Add a Song..!',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        NeumorphismWidget(
                          height: 50,
                          width: 50,

                          borderRadius: BorderRadius.circular(12),
                          color: customizedColors[currentSwitchColor],
                          shape: BoxShape.rectangle,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                ref
                                    .read(rFileProvider.notifier)
                                    .pickAudioFile();
                              },
                              icon: const Icon(Icons.add_to_drive, size: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          }
          return switchButton
              ? glassScreen(ref)
              : neumorphismScreen(ref, context);
        },
      ),
    );
  }
}

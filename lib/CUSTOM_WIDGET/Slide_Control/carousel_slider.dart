import 'package:carousel_slider/carousel_slider.dart';
import 'package:fatej/CORE/File_Directory/MUSIC/file_picker.dart';
import 'package:fatej/CUSTOM_WIDGET/COLOR/constant_color.dart';
import 'package:fatej/CUSTOM_WIDGET/Customization/customized_widget.dart';
import 'package:fatej/RIVERPOD/just_audio_function.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarouselSliderWidget extends ConsumerStatefulWidget {
  const CarouselSliderWidget({super.key, required this.onPageChanged});

  final dynamic Function(int, CarouselPageChangedReason)? onPageChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CarouselSliderWidget();
}

class _CarouselSliderWidget extends ConsumerState<CarouselSliderWidget> {
  final CarouselSliderController controller = CarouselSliderController();
  bool goesByOne = false;

  @override
  Widget build(BuildContext context) {
    // Change slider to next page --Control by CarouselSliderController
    ref.listen(rAudioProvider, (previous, next) {
      next.whenData((state) {
        final duration = state.duration.inSeconds;
        final position = state.position.inSeconds;

        //0 or 1 duration --prevent multiple fires
        if (position <= 1) return goesByOne = false;

        final isNearEnd = duration > 0 && position >= duration - 1;

        //check for condition to next page
        if (isNearEnd && !goesByOne) {
          goesByOne = true;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              controller.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.bounceInOut,
              );
            }
          });
        }
      });
    }); //

    final data = ref.watch(rFileProvider);
    return data.when(
      error: (error, stackTrace) => Text('Error $error'),
      loading: () => Center(child: CircularProgressIndicator()),
      //Display Slider Screen
      data: (dataX) => CarouselSlider.builder(
        itemCount: dataX.length <= 1 ? 1 : dataX.length,
        itemBuilder: (context, index, realIndex) {
          final items = dataX[index];
          return Container(
            padding: EdgeInsets.all(10),
            width: 300,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: ConstantColor.vWhiteColor1),
              ),
              color: ConstantColor.vGreyColor5.withAlpha(90),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              spacing: 35,
              children: [
                //Image Display
                items.image == null
                    ? Center(
                        child: Text(
                          'Add an Image',
                          style: TextStyle(
                            color: ConstantColor.vWhiteColor1,
                            shadows: [
                              Shadow(
                                color: ConstantColor.vTealColor2,
                                offset: Offset(2, 3),
                              ),
                            ],
                            fontSize: 17,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(15),
                        child: imageSolutionSecond(
                          items.image,
                          height: 300,
                          width: 300,
                        ),
                      ),
                //Song Title
                Text(
                  textAlign: TextAlign.center,
                  items.title!.replaceAll('.mp3', ''),
                  style: TextStyle(
                    color: ConstantColor.vWhiteColor1,

                    fontSize: 16.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
        carouselController: controller,
        options: CarouselOptions(
          autoPlay: false,
          viewportFraction: 1,
          enlargeFactor: 0.25,
          height: 450,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          onPageChanged: widget.onPageChanged,
        ),
      ),
    );
  }
}

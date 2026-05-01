import 'dart:io';

import 'package:fatej/CUSTOM_WIDGET/COLOR/constant_color.dart';
import 'package:fatej/RIVERPOD/ref_call.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NeumorphismWidget extends ConsumerWidget {
  const NeumorphismWidget({
    super.key,
    this.width,
    this.height,
    this.shape,
    this.padding,
    this.borderRadius,
    this.blurRadius,
    this.offset,
    this.color,
    this.child,
  });

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BoxShape? shape;
  final BorderRadiusGeometry? borderRadius;
  final double? blurRadius;
  final Offset? offset;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentColor = ref.watch(rScreenColorIndexProvider);
    return Container(
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        shape: shape ?? BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            offset: offset ?? Offset(-20, -20),
            color: customizedColors[currentColor],
            blurStyle: BlurStyle.normal,
            blurRadius: blurRadius ?? 30,
          ),

          BoxShadow(
            offset: offset ?? Offset(15, 15),
            color: ConstantColor.vBlackColor1,
            blurStyle: BlurStyle.normal,
            blurRadius: blurRadius ?? 18,
          ),
        ],
      ),

      child: Center(child: child),
    );
  }
}

List<Color> customizedColors = [
  ConstantColor.vindigoColor9,
  ConstantColor.vPurpleColor1,
  ConstantColor.vBlueColor1,
  ConstantColor.vPinkColor2,
  ConstantColor.vTealColor2,
  ConstantColor.vBrownColor2,
];

Widget mySizedBox({double? height, double? width, Widget? child}) {
  return SizedBox(height: height, width: width, child: child);
}

ImageProvider imageSolutionFirst(String image, {String? customImage}) {
  if (image.isEmpty) {
    return AssetImage(customImage ?? 'assets/songs/images/cute_little.png');
  }

  if (image.startsWith('http')) return NetworkImage(image);
  return FileImage(File(image));
}

Widget imageSolutionSecond(
  String? image, {
  String? customImage,
  double? height,
  double? width,
  int? cacheHeight,
  int? cacheWidth,
}) {
  if (image == null || image.isEmpty) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(12),
      child: Image.asset(
        customImage ?? 'assets/songs/images/cute_little.png',
        fit: BoxFit.cover,
        height: 500,
        width: 600,
        cacheHeight: 500,
        cacheWidth: 600,
      ),
    );
  }

  if (image.startsWith('http')) {
    return Image.network(
      image,
      fit: BoxFit.cover,
      height: height,
      width: width,
      cacheHeight: height?.toInt() ?? cacheHeight,
      cacheWidth: width?.toInt() ?? cacheWidth,
    );
  }
  return Image.file(
    File(image),
    height: height,
    width: width,
    cacheHeight: height?.toInt(),
    cacheWidth: width?.toInt(),
    fit: BoxFit.cover,
  );
}

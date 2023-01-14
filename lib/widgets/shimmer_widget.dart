import 'package:flutter/material.dart';
import 'package:news/constants/color_constants.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({this.width = double.infinity,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });


  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(child: Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: AppColors.thidasaBlue,
        shape: shapeBorder,
      ),
    ),
        baseColor: AppColors.thidasaBlue!,
        highlightColor: AppColors.thidasaBlueLight!,);
  }
}

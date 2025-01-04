import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String image;
  final Color? color;
  const ImageWidget({super.key, required this.image, this.color, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 20,
      width: width ?? 20,
      child: Image.asset(
        image,
        fit: BoxFit.cover,
        color: color,
      ),
    );
  }
}
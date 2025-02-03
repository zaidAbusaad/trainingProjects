import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    super.key,
    this.width=400,
    this.height=400,
    this.radius=400,
    this.child,
    this.bgColor=Colors.white,
  });

  final double? width;
  final double? height;
  final double radius;
  final Widget? child;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(400),
        color: bgColor.withOpacity(0.1),
      ),
      child: child,
    );
  }
}
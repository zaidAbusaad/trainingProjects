import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 904;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width > 903;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

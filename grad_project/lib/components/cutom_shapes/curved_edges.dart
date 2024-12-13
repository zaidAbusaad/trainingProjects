import 'package:flutter/material.dart';

class CurvedEdges extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
   
    var path = Path();
    path.lineTo(0, size.height);
    
    final firstC = Offset(0, size.height-20);
    final secondC = Offset(30, size.height-20);
    path.quadraticBezierTo(firstC.dx, firstC.dy, secondC.dx, secondC.dy);

    final firstC2 = Offset(0, size.height-20);
    final secondC2 = Offset(size.width-30, size.height-20);
    path.quadraticBezierTo(firstC2.dx, firstC2.dy, secondC2.dx, secondC2.dy);

    final firstC3 = Offset( size.width,size.height-20);
    final secondC3 = Offset(size.width,size.height);
    path.quadraticBezierTo(firstC3.dx, firstC3.dy, secondC3.dx, secondC3.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
  
}
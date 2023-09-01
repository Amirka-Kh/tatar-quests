import 'package:flutter/material.dart';

abstract class AppTheme {
  TextStyle display1();
  TextStyle display2();
  TextStyle heading();
  TextStyle subHeading();
}

class AppThemeDefault extends AppTheme {
  @override
  TextStyle display1() => const TextStyle(
        color: Colors.black,
        fontSize: 38,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      );

  @override
  TextStyle display2() => const TextStyle(
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.1,
      );

  @override
  TextStyle heading() => const TextStyle(
        color: Colors.black,
        fontSize: 34,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      );

  @override
  TextStyle subHeading() => const TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        inherit: true,
      );
}

class AppThemeDark extends AppTheme {
  @override
  TextStyle display1() => const TextStyle(
        color: Colors.white,
        fontSize: 38,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      );

  @override
  TextStyle display2() => const TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.1,
      );

  @override
  TextStyle heading() => const TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      );

  @override
  TextStyle subHeading() => const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        inherit: true,
      );
}

class QuestCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();
    double curveDistance = 40;

    clippedPath.moveTo(0, size.height * 0.4);
    clippedPath.lineTo(0, size.height - curveDistance);
    clippedPath.quadraticBezierTo(
        1, size.height - 1, 0 + curveDistance, size.height);
    clippedPath.lineTo(size.width - curveDistance, size.height);
    clippedPath.quadraticBezierTo(size.width + 1, size.height - 1, size.width,
        size.height - curveDistance);
    clippedPath.lineTo(size.width, 0 + curveDistance);
    clippedPath.quadraticBezierTo(size.width - 1, 0,
        size.width - curveDistance - 5, 0 + curveDistance / 3);
    clippedPath.lineTo(curveDistance, size.height * 0.29);
    clippedPath.quadraticBezierTo(
        1, (size.height * 0.30) + 10, 0, size.height * 0.4);
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

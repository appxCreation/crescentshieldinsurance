import 'package:flutter/material.dart';

const white = Colors.white;
const black = Colors.black;
const mainColor = Color(0xff0f6b57);
const bgColor = Color(0xfff6f8f7);
const o = Color(0xffff695b);
const goldButtonText = Color(0xff0b3d36);

class SitePalette {
  const SitePalette({
    required this.background,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.brand,
    required this.brandDeep,
    required this.line,
    required this.gold,
    required this.heroStart,
    required this.heroEnd,
  });

  final Color background;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color brand;
  final Color brandDeep;
  final Color line;
  final Color gold;
  final Color heroStart;
  final Color heroEnd;

  static const light = SitePalette(
    background: Color(0xfff6f8f7),
    surface: Color(0xffffffff),
    ink: Color(0xff0b2a26),
    muted: Color(0xff4d6661),
    brand: Color(0xff0f6b57),
    brandDeep: Color(0xff0b3d36),
    line: Color(0xffdbe5e1),
    gold: Color(0xffe0a82e),
    heroStart: Color(0xff0b3d36),
    heroEnd: Color(0xff0f6b57),
  );

  static const dark = SitePalette(
    background: Color(0xff0a1513),
    surface: Color(0xff112320),
    ink: Color(0xffe8f2ef),
    muted: Color(0xff9bb5af),
    brand: Color(0xff34b898),
    brandDeep: Color(0xff7fd9c1),
    line: Color(0xff1f3a35),
    gold: Color(0xffe0a82e),
    heroStart: Color(0xff06201c),
    heroEnd: Color(0xff0c4a3e),
  );

  static SitePalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

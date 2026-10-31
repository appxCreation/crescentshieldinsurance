import 'package:flutter/material.dart';

const white = Colors.white;
const black = Colors.black;
const mainColor = Color(0xff0b5d3b);
const bgColor = Color(0xfff4faf6);
const o = Color(0xffff695b);
const goldButtonText = Color(0xff052217);

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
    background: Color(0xfff4faf6),
    surface: Color(0xffffffff),
    ink: Color(0xff12281e),
    muted: Color(0xff587264),
    brand: Color(0xff16a06a),
    brandDeep: Color(0xff0b5d3b),
    line: Color(0xffd3e3d9),
    gold: Color(0xfff2b632),
    heroStart: Color(0xffe7f7f3),
    heroEnd: Color(0xfff4faf6),
  );

  static const dark = SitePalette(
    background: Color(0xff07201a),
    surface: Color(0xff0c2d24),
    ink: Color(0xffe4f1ea),
    muted: Color(0xff9dbbab),
    brand: Color(0xff16a06a),
    brandDeep: Color(0xffc4e3d4),
    line: Color(0xff1e4a3b),
    gold: Color(0xfff2b632),
    heroStart: Color(0xff0c2d24),
    heroEnd: Color(0xff07201a),
  );

  static SitePalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

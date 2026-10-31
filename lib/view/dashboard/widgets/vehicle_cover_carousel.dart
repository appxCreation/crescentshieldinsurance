import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'site_components.dart';

class VehicleCoverCarousel extends StatefulWidget {
  const VehicleCoverCarousel({
    super.key,
    required this.sectionKey,
    required this.onQuote,
  });

  final Key sectionKey;
  final ValueChanged<String> onQuote;

  @override
  State<VehicleCoverCarousel> createState() => _VehicleCoverCarouselState();
}

class _VehicleCoverCarouselState extends State<VehicleCoverCarousel> {
  static const _plans = [
    _VehicleCoverPlan(
      name: 'Truck',
      vehicleType: 'Truck',
      price: 'PKR 12,500',
      color: Color(0xff0b5d3b),
      art: _VehicleArtType.truck,
      badge: 'Fleet ready',
    ),
    _VehicleCoverPlan(
      name: 'Trailer',
      vehicleType: 'Trailer',
      price: 'PKR 12,500',
      color: Color(0xff0a2a1c),
      art: _VehicleArtType.trailer,
    ),
    _VehicleCoverPlan(
      name: 'Dumper',
      vehicleType: 'Dumper',
      price: 'PKR 12,500',
      color: Color(0xff6b8f3a),
      art: _VehicleArtType.dumper,
      badge: 'New',
    ),
  ];

  var _selectedIndex = 1;

  void _select(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  void _move(int amount) =>
      _select((_selectedIndex + amount + _plans.length) % _plans.length);

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      key: widget.sectionKey,
      width: double.infinity,
      color: const Color(0xff06251c),
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).width <= 700 ? 38 : 58,
      ),
      child: SiteContainer(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [palette.gold, palette.brand],
                ),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose your cover',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xffe4f1ea),
                fontSize: (screenWidth * .042).clamp(32.0, 52.0).toDouble(),
                fontWeight: FontWeight.w600,
                height: 1.05,
                letterSpacing: -1.7,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap a card or use the arrows to see every vehicle type. Prices are indicative.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff9dbbab),
                fontSize: screenWidth <= 700 ? 16 : 18,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth <= 700;
                final tablet = !compact && constraints.maxWidth <= 1000;
                final cardWidth = compact
                    ? math.min(constraints.maxWidth * .78, 260.0).toDouble()
                    : tablet
                    ? math.min(constraints.maxWidth * .34, 280.0).toDouble()
                    : math.min(constraints.maxWidth * .24, 280.0).toDouble();
                final horizontalStep = compact
                    ? math.min(cardWidth * .58, constraints.maxWidth * .4)
                        .toDouble()
                    : math.min(cardWidth * .72, constraints.maxWidth * .25)
                        .toDouble();
                final cardHeight = compact ? 400.0 : 455.0;
                final carouselHeight = compact ? 430.0 : 490.0;

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragEnd: (details) {
                    final velocity = details.primaryVelocity ?? 0;
                    if (velocity.abs() > 100) _move(velocity < 0 ? 1 : -1);
                  },
                  child: SizedBox(
                    height: carouselHeight,
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        for (final offset in const [-1, 1, 0])
                          _positionedCard(
                            offset: offset,
                            width: constraints.maxWidth,
                            cardWidth: cardWidth,
                            cardHeight: cardHeight,
                            horizontalStep: horizontalStep,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CarouselArrow(
                  icon: Icons.chevron_left_rounded,
                  label: 'Previous cover',
                  onPressed: () => _move(-1),
                ),
                const SizedBox(width: 20),
                for (var index = 0; index < _plans.length; index++)
                  InkWell(
                    onTap: () => _select(index),
                    borderRadius: BorderRadius.circular(99),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 240),
                      width: index == _selectedIndex ? 30 : 9,
                      height: 9,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index == _selectedIndex
                            ? palette.brand
                            : const Color(0xff285242),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                const SizedBox(width: 20),
                _CarouselArrow(
                  icon: Icons.chevron_right_rounded,
                  label: 'Next cover',
                  onPressed: () => _move(1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _positionedCard({
    required int offset,
    required double width,
    required double cardWidth,
    required double cardHeight,
    required double horizontalStep,
  }) {
    final index = (_selectedIndex + offset + _plans.length) % _plans.length;
    final plan = _plans[index];
    final active = offset == 0;
    return AnimatedPositioned(
      key: ValueKey(plan.vehicleType),
      duration: const Duration(milliseconds: 680),
      curve: Curves.easeOutCubic,
      left: width / 2 - cardWidth / 2 + offset * horizontalStep,
      top: active ? 0 : 30,
      width: cardWidth,
      height: cardHeight,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 680),
        curve: Curves.easeOutCubic,
        scale: active ? 1 : .92,
        child: _VehicleCoverCard(
          plan: plan,
          compact: cardWidth < 270,
          onCenter: () => _select(index),
          onRequest: () {
            _select(index);
            widget.onQuote(plan.vehicleType);
          },
        ),
      ),
    );
  }
}

class _VehicleCoverCard extends StatelessWidget {
  const _VehicleCoverCard({
    required this.plan,
    required this.compact,
    required this.onCenter,
    required this.onRequest,
  });

  final _VehicleCoverPlan plan;
  final bool compact;
  final VoidCallback onCenter;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final textTheme = Theme.of(context).textTheme;
    final imageHeight = compact ? 200.0 : 240.0;
    final artSize = compact ? 150.0 : 175.0;

    return Material(
      color: plan.color,
      borderRadius: BorderRadius.circular(compact ? 26 : 30),
      elevation: 10,
      shadowColor: Colors.black.withValues(alpha: .42),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onCenter,
        borderRadius: BorderRadius.circular(compact ? 26 : 30),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.all(compact ? 16 : 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(compact ? 26 : 30),
                  border: Border.all(color: Colors.white.withValues(alpha: .09)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: imageHeight,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  compact ? 20 : 22,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: artSize,
                            height: artSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: plan.color.withValues(alpha: .16),
                            ),
                            alignment: Alignment.center,
                            child: _AnimatedVehicleArtwork(
                              type: plan.art,
                              color: plan.color,
                              width: artSize * .94,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: compact ? 11 : 13),
                    Text(
                      plan.name,
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: compact ? 21 : 23,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Third party · Starting from',
                      style: textTheme.labelMedium?.copyWith(
                        color: Colors.white.withValues(alpha: .84),
                        fontSize: compact ? 12 : 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${plan.price} / year',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: palette.gold,
                        fontSize: compact ? 18 : 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.3,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: onRequest,
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: const Text('Request policy'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: goldButtonText,
                          overlayColor: palette.gold.withValues(alpha: .2),
                          minimumSize: const Size(0, 44),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          textStyle: textTheme.labelLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (plan.badge != null)
              Positioned(
                top: 14,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: palette.gold,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    plan.badge!,
                    style: textTheme.labelMedium?.copyWith(
                      color: goldButtonText,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedVehicleArtwork extends StatefulWidget {
  const _AnimatedVehicleArtwork({
    required this.type,
    required this.color,
    required this.width,
  });

  final _VehicleArtType type;
  final Color color;
  final double width;

  @override
  State<_AnimatedVehicleArtwork> createState() =>
      _AnimatedVehicleArtworkState();
}

class _AnimatedVehicleArtworkState extends State<_AnimatedVehicleArtwork>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _lift;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _lift = Tween<double>(begin: 2, end: -7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _lift,
    child: CustomPaint(
      size: Size(widget.width, widget.width * .6),
      painter: _VehicleIllustrationPainter(type: widget.type, color: widget.color),
    ),
    builder: (context, child) => Transform.translate(
      offset: Offset(0, _lift.value),
      child: child,
    ),
  );
}

enum _VehicleArtType { truck, trailer, dumper }

class _VehicleIllustrationPainter extends CustomPainter {
  const _VehicleIllustrationPainter({required this.type, required this.color});

  final _VehicleArtType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 200, size.height / 120);

    final tirePaint = Paint()..color = const Color(0xff12281e);
    final hubPaint = Paint()..color = const Color(0xfff4faf6);
    final windowPaint = Paint()..color = const Color(0xfff4faf6);
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: .28)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    switch (type) {
      case _VehicleArtType.truck:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(16, 25, 108, 53),
            const Radius.circular(7),
          ),
          Paint()..color = color,
        );
        canvas.drawLine(const Offset(26, 37), const Offset(109, 37), highlightPaint);
        final truckCab = Path()
          ..moveTo(124, 47)
          ..lineTo(154, 47)
          ..lineTo(179, 68)
          ..lineTo(179, 83)
          ..lineTo(122, 83)
          ..close();
        canvas.drawPath(truckCab, Paint()..color = color);
        canvas.drawPath(
          Path()
            ..moveTo(136, 53)
            ..lineTo(151, 53)
            ..lineTo(165, 66)
            ..lineTo(136, 66)
            ..close(),
          windowPaint,
        );
        _drawWheel(canvas, const Offset(45, 84), tirePaint, hubPaint);
        _drawWheel(canvas, const Offset(94, 84), tirePaint, hubPaint);
        _drawWheel(canvas, const Offset(155, 84), tirePaint, hubPaint);
        break;
      case _VehicleArtType.trailer:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(9, 29, 117, 48),
            const Radius.circular(5),
          ),
          Paint()..color = color,
        );
        canvas.drawLine(const Offset(20, 41), const Offset(113, 41), highlightPaint);
        final trailerCab = Path()
          ..moveTo(130, 51)
          ..lineTo(158, 51)
          ..lineTo(180, 70)
          ..lineTo(180, 83)
          ..lineTo(128, 83)
          ..close();
        canvas.drawPath(trailerCab, Paint()..color = color);
        canvas.drawPath(
          Path()
            ..moveTo(140, 56)
            ..lineTo(155, 56)
            ..lineTo(168, 69)
            ..lineTo(140, 69)
            ..close(),
          windowPaint,
        );
        _drawWheel(canvas, const Offset(35, 84), tirePaint, hubPaint);
        _drawWheel(canvas, const Offset(72, 84), tirePaint, hubPaint);
        _drawWheel(canvas, const Offset(108, 84), tirePaint, hubPaint);
        _drawWheel(canvas, const Offset(157, 84), tirePaint, hubPaint);
        break;
      case _VehicleArtType.dumper:
        final dumpBody = Path()
          ..moveTo(17, 32)
          ..lineTo(106, 20)
          ..lineTo(119, 70)
          ..lineTo(27, 76)
          ..close();
        canvas.drawPath(dumpBody, Paint()..color = color);
        canvas.drawLine(const Offset(31, 41), const Offset(98, 33), highlightPaint);
        final dumperCab = Path()
          ..moveTo(126, 49)
          ..lineTo(157, 49)
          ..lineTo(181, 69)
          ..lineTo(181, 83)
          ..lineTo(123, 83)
          ..close();
        canvas.drawPath(dumperCab, Paint()..color = color);
        canvas.drawPath(
          Path()
            ..moveTo(137, 55)
            ..lineTo(153, 55)
            ..lineTo(167, 68)
            ..lineTo(137, 68)
            ..close(),
          windowPaint,
        );
        _drawWheel(canvas, const Offset(45, 84), tirePaint, hubPaint);
        _drawWheel(canvas, const Offset(87, 84), tirePaint, hubPaint);
        _drawWheel(canvas, const Offset(157, 84), tirePaint, hubPaint);
        break;
    }

    canvas.restore();
  }

  void _drawWheel(Canvas canvas, Offset center, Paint tirePaint, Paint hubPaint) {
    canvas.drawCircle(center, 13, tirePaint);
    canvas.drawCircle(center, 5.5, hubPaint);
  }

  @override
  bool shouldRepaint(covariant _VehicleIllustrationPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.color != color;
}

class _CarouselArrow extends StatelessWidget {
  const _CarouselArrow({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xff0a2d23),
    shape: CircleBorder(side: BorderSide(color: const Color(0xff285242))),
    child: IconButton(
      onPressed: onPressed,
      tooltip: label,
      icon: Icon(icon, color: const Color(0xffe4f1ea), size: 26),
    ),
  );
}

class _VehicleCoverPlan {
  const _VehicleCoverPlan({
    required this.name,
    required this.vehicleType,
    required this.price,
    required this.color,
    required this.art,
    this.badge,
  });

  final String name;
  final String vehicleType;
  final String price;
  final Color color;
  final _VehicleArtType art;
  final String? badge;
}

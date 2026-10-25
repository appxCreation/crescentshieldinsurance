import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'site_components.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onQuote, required this.onClaims});

  final VoidCallback onQuote;
  final VoidCallback onClaims;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width <= 800;
    final palette = SitePalette.of(context);

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: .38)),
            borderRadius: BorderRadius.circular(99),
          ),
          child: const Text(
            'Third Party Motor Insurance',
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            text: 'Drive legal. Drive\n',
            children: [
              TextSpan(
                text: 'protected.',
                style: TextStyle(
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        palette.gold,
                        const Color(0xfffff0b0),
                        palette.gold,
                      ],
                    ).createShader(const Rect.fromLTWH(0, 0, 230, 55)),
                ),
              ),
            ],
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: mobile ? 42 : 56,
            fontWeight: FontWeight.w900,
            height: 1.06,
            letterSpacing: -1.8,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Text(
            'Third party insurance for trucks and trailers. Simple paperwork, fast policy issuance and claims support at +92 308 6902148 by phone or WhatsApp.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .9),
              fontSize: mobile ? 16 : 18,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            GoldButton(label: 'Get Your Policy', onPressed: onQuote),
            OutlineHeroButton(label: 'Report a Claim', onPressed: onClaims),
          ],
        ),
        const SizedBox(height: 26),
        const Wrap(
          spacing: 9,
          runSpacing: 9,
          children: [
            SoftPill(label: '✓  Legally compliant'),
            SoftPill(label: '⚡  Fast digital policy'),
            SoftPill(label: '☎  Claims helpline'),
          ],
        ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [palette.heroStart, palette.heroEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _HeroGlow()),
          SiteContainer(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: mobile ? 46 : 78,
            ),
            child: mobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      copy,
                      const SizedBox(height: 22),
                      const Center(child: ShieldArtwork(size: 250)),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(flex: 11, child: copy),
                      const SizedBox(width: 30),
                      const Expanded(flex: 9, child: ShieldArtwork(size: 390)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _HeroGlow extends StatelessWidget {
  const _HeroGlow();

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Stack(
      children: [
        Positioned(
          left: -130,
          top: -160,
          child: Container(
            width: 490,
            height: 490,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x5534b898), Color(0x000b3d36)],
              ),
            ),
          ),
        ),
        Positioned(
          right: -120,
          bottom: -200,
          child: Container(
            width: 470,
            height: 470,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x44e0a82e), Color(0x000b3d36)],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class ShieldArtwork extends StatelessWidget {
  const ShieldArtwork({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _ShieldPainter(SitePalette.of(context))),
  );
}

class _ShieldPainter extends CustomPainter {
  const _ShieldPainter(this.palette);

  final SitePalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 400;
    canvas.save();
    canvas.scale(scale);

    final ringPaint = Paint()..color = palette.gold.withValues(alpha: .75);
    for (var i = 0; i < 48; i++) {
      final angle = (math.pi * 2 * i) / 48;
      canvas.drawCircle(
        Offset(200 + math.cos(angle) * 180, 195 + math.sin(angle) * 180),
        i % 4 == 0 ? 2.5 : 1.5,
        ringPaint,
      );
    }
    canvas.drawCircle(
      const Offset(200, 195),
      150,
      Paint()..color = Colors.white.withValues(alpha: .08),
    );

    final outerShield = Path()
      ..moveTo(200, 48)
      ..lineTo(322, 94)
      ..lineTo(322, 190)
      ..cubicTo(322, 276, 265, 323, 200, 352)
      ..cubicTo(135, 323, 78, 276, 78, 190)
      ..lineTo(78, 94)
      ..close();
    canvas.drawPath(outerShield, Paint()..color = Colors.white);

    final innerShield = Path()
      ..moveTo(200, 63)
      ..lineTo(307, 103)
      ..lineTo(307, 190)
      ..cubicTo(307, 266, 257, 307, 200, 333)
      ..cubicTo(143, 307, 93, 266, 93, 190)
      ..lineTo(93, 103)
      ..close();
    canvas.drawPath(innerShield, Paint()..color = palette.brand);

    canvas.drawCircle(
      const Offset(198, 169),
      54,
      Paint()..color = palette.gold,
    );
    canvas.drawCircle(
      const Offset(219, 151),
      45,
      Paint()..color = palette.brand,
    );
    final star = Path()
      ..moveTo(248, 145)
      ..lineTo(254, 161)
      ..lineTo(271, 161)
      ..lineTo(257, 171)
      ..lineTo(262, 188)
      ..lineTo(248, 178)
      ..lineTo(234, 188)
      ..lineTo(239, 171)
      ..lineTo(225, 161)
      ..lineTo(242, 161)
      ..close();
    canvas.drawPath(star, Paint()..color = Colors.white);

    final roadPaint = Paint()
      ..color = palette.gold.withValues(alpha: .78)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    for (var x = -12.0; x < 420; x += 58) {
      canvas.drawLine(Offset(x, 370), Offset(x + 27, 370), roadPaint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShieldPainter oldDelegate) =>
      oldDelegate.palette != palette;
}

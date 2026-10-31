import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'site_components.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key, required this.sectionKey});

  final Key sectionKey;

  static const _steps = [
    (
      'Pick your vehicle',
      'Choose your vehicle type above.',
    ),
    (
      'Send your documents',
      'Share your registration book and CNIC with our team.',
    ),
    (
      'Receive your policy',
      'We issue it and send it to you, ready to carry.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final palette = SitePalette.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: const Color(0xff0a2a1c),
      padding: EdgeInsets.symmetric(vertical: width <= 760 ? 54 : 82),
      child: SiteContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [palette.gold, palette.brand],
                ),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'Three steps to your policy',
              style: textTheme.headlineMedium?.copyWith(
                color: const Color(0xffe4f1ea),
                fontSize: width <= 760 ? 34 : 48,
                fontWeight: FontWeight.w800,
                height: 1.12,
                letterSpacing: -1.2,
              ),
            ),
            SizedBox(height: width <= 760 ? 36 : 60),
            if (width > 760)
              _DesktopPolicySteps(steps: _steps)
            else
              _MobilePolicySteps(steps: _steps),
          ],
        ),
      ),
    );
  }
}

class _DesktopPolicySteps extends StatelessWidget {
  const _DesktopPolicySteps({required this.steps});

  final List<(String, String)> steps;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnWidth = constraints.maxWidth / steps.length;
        return Stack(
          children: [
            Positioned(
              left: 32,
              top: 31,
              width: columnWidth * 2,
              height: 2,
              child: CustomPaint(
                painter: _DashedRulePainter(color: palette.gold),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < steps.length; index++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: index < 2 ? 24 : 0),
                      child: _PolicyStepContent(
                        number: index + 1,
                        title: steps[index].$1,
                        description: steps[index].$2,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _MobilePolicySteps extends StatelessWidget {
  const _MobilePolicySteps({required this.steps});

  final List<(String, String)> steps;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return Column(
      children: [
        for (var index = 0; index < steps.length; index++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _StepNumber(number: index + 1),
                  if (index < steps.length - 1)
                    CustomPaint(
                      size: const Size(2, 52),
                      painter: _DashedVerticalPainter(color: palette.gold),
                    ),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 22),
                  child: _PolicyStepText(
                    title: steps[index].$1,
                    description: steps[index].$2,
                    compact: true,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _PolicyStepContent extends StatelessWidget {
  const _PolicyStepContent({
    required this.number,
    required this.title,
    required this.description,
  });

  final int number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _StepNumber(number: number),
      const SizedBox(height: 14),
      _PolicyStepText(title: title, description: description),
    ],
  );
}

class _PolicyStepText extends StatelessWidget {
  const _PolicyStepText({
    required this.title,
    required this.description,
    this.compact = false,
  });

  final String title;
  final String description;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            color: const Color(0xffe4f1ea),
            fontSize: compact ? 21 : 23,
            fontWeight: FontWeight.w800,
            letterSpacing: -.6,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          description,
          style: textTheme.bodyLarge?.copyWith(
            color: const Color(0xff9dbbab),
            fontSize: compact ? 16 : 18,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _StepNumber extends StatelessWidget {
  const _StepNumber({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xff06251c), const Color(0xff0b5d3b)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.brand.withValues(alpha: .22)),
      ),
      child: Text(
        '$number',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: palette.gold,
          fontSize: 27,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DashedRulePainter extends CustomPainter {
  const _DashedRulePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.square;
    const dashWidth = 8.0;
    const stride = 16.0;
    for (var x = 0.0; x < size.width; x += stride) {
      final end = (x + dashWidth).clamp(0.0, size.width).toDouble();
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(end, size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRulePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _DashedVerticalPainter extends CustomPainter {
  const _DashedVerticalPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width
      ..strokeCap = StrokeCap.square;
    const dashHeight = 5.0;
    const stride = 10.0;
    for (var y = 0.0; y < size.height; y += stride) {
      final end = (y + dashHeight).clamp(0.0, size.height).toDouble();
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, end),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedVerticalPainter oldDelegate) =>
      oldDelegate.color != color;
}

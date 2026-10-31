import 'dart:async';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'site_components.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.onQuote,
    required this.onHowItWorks,
  });

  final VoidCallback onQuote;
  final VoidCallback onHowItWorks;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  final _controller = PageController();
  Timer? _autoAdvance;
  var _page = 0;

  static const _slides = [
    _HeroSlideData(
      title: 'Trucks, buses and fleets covered.',
      description:
          'Insure one vehicle or a whole fleet. We handle the paperwork for every registration.',
      emoji: '🚚',
      cardTitle: 'Truck · Fleet ready',
      cardDescription: 'One policy, every vehicle',
      cardValue: 'PKR 12,500',
      cardValueSuffix: '/ year',
      topTag: '✓ Fleet policies',
      bottomTag: '📄 We do the paperwork',
      accent: Color(0xffcfeedd),
    ),
    _HeroSlideData(
      title: 'Drive your car with confidence.',
      description:
          'Covers injury and property damage you cause to others, so one accident does not become a financial crisis.',
      emoji: '🔏',
      cardTitle: 'Injury & property cover',
      cardDescription: 'Protects you from claims',
      cardValue: 'PKR 2,500',
      cardValueSuffix: '/ year',
      topTag: '✓ Legal on the road',
      bottomTag: '🤝 Others covered',
      accent: Color(0xffd7edf0),
    ),
    _HeroSlideData(
      title: 'Documents in, policy out.',
      description:
          'Send your registration book and CNIC. We prepare your policy and send it to you.',
      emoji: '🗎',
      cardTitle: 'Documents in, policy out',
      cardDescription: 'Registration book + CNIC',
      cardValue: '3 steps',
      cardValueSuffix: '/ year',
      topTag: '📄 Send on WhatsApp',
      bottomTag: '✓ Policy sent to you',
      accent: Color(0xffe4f0d8),
    ),
    _HeroSlideData(
      title: 'Third party insurance, sorted in minutes.',
      description:
          'Stay legal on the road and protected against claims from others. Pick your vehicle, see your premium, and our team issues your policy.',
      emoji: '🚗',
      cardTitle: 'Car · Third party',
      cardDescription: 'Valid for 1 year',
      cardValue: 'PKR 2,500',
      cardValueSuffix: '/ year',
      topTag: '✓ Policy on WhatsApp',
      bottomTag: '⚡ Ready in minutes',
      accent: Color(0xffffefc9),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scheduleAutoAdvance();
  }

  @override
  void dispose() {
    _autoAdvance?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    final next = (index + _slides.length) % _slides.length;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scheduleAutoAdvance() {
    _autoAdvance?.cancel();
    _autoAdvance = Timer(const Duration(seconds: 18), () {
      if (mounted) _goTo(_page + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width <= 820;
    final palette = SitePalette.of(context);
    final height = mobile ? 650.0 : 600.0;

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
          Positioned(
            top: -180,
            right: -150,
            child: _GlowOrb(color: palette.brand.withValues(alpha: .12)),
          ),
          Positioned(
            bottom: -220,
            left: -150,
            child: _GlowOrb(color: palette.gold.withValues(alpha: .14)),
          ),
          SiteContainer(
            padding: EdgeInsets.symmetric(
              horizontal: mobile ? 18 : 28,
              vertical: mobile ? 8 : 10,
            ),
            child: SizedBox(
              height: height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      setState(() => _page = index);
                      _scheduleAutoAdvance();
                    },
                    itemBuilder: (context, index) => _HeroPanel(
                      slide: _slides[index],
                      mobile: mobile,
                      onQuote: widget.onQuote,
                      onHowItWorks: widget.onHowItWorks,
                    ),
                  ),
                  if (!mobile) ...[
                    Positioned(
                      left: 0,
                      child: _HeroArrow(
                        icon: Icons.chevron_left_rounded,
                        label: 'Previous feature',
                        onPressed: () => _goTo(_page - 1),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: _HeroArrow(
                        icon: Icons.chevron_right_rounded,
                        label: 'Next feature',
                        onPressed: () => _goTo(_page + 1),
                      ),
                    ),
                  ],
                  Positioned(
                    bottom: mobile ? 0 : 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var index = 0; index < _slides.length; index++)
                          InkWell(
                            onTap: () => _goTo(index),
                            borderRadius: BorderRadius.circular(99),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: _page == index ? 30 : 9,
                              height: 9,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: _page == index
                                    ? palette.brand
                                    : palette.brandDeep.withValues(alpha: .2),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.slide,
    required this.mobile,
    required this.onQuote,
    required this.onHowItWorks,
  });

  final _HeroSlideData slide;
  final bool mobile;
  final VoidCallback onQuote;
  final VoidCallback onHowItWorks;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final mobileTitleSize = (width * .085).clamp(29.0, 35.0).toDouble();
    final actions = mobile
        ? Row(
            children: [
              Expanded(
                child: _HeroPrimaryButton(
                  label: 'Get your premium',
                  onPressed: onQuote,
                  compact: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroSecondaryButton(
                  label: 'How it works',
                  onPressed: onHowItWorks,
                ),
              ),
            ],
          )
        : Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _HeroPrimaryButton(
                label: 'Get your premium',
                onPressed: onQuote,
              ),
              _HeroSecondaryButton(
                label: 'How it works',
                onPressed: onHowItWorks,
              ),
            ],
          );
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
          decoration: BoxDecoration(
            color: palette.surface,
            border: Border.all(color: palette.line),
            borderRadius: BorderRadius.circular(99),
            boxShadow: [
              BoxShadow(
                color: palette.brandDeep.withValues(alpha: .08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome_rounded, size: 16, color: palette.brand),
              const SizedBox(width: 7),
              const Text(
                'Third-party motor insurance',
                style: TextStyle(
                  color: Color(0xff0b5d3b),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: mobile ? 12 : 18),
        Text(
          slide.title,
          style: TextStyle(
            color: palette.ink,
            fontSize: mobile ? mobileTitleSize : 64,
            fontWeight: FontWeight.w800,
            height: 1.03,
            letterSpacing: mobile ? -1 : -2.8,
          ),
        ),
        SizedBox(height: mobile ? 10 : 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Text(
            slide.description,
            style: TextStyle(
              color: const Color(0xff3f5a4e),
              fontSize: mobile ? 14 : 18,
              height: mobile ? 1.45 : 1.6,
            ),
          ),
        ),
        SizedBox(height: mobile ? 14 : 20),
        actions,
      ],
    );

    final visual = _HeroCoverCard(slide: slide, mobile: mobile);
    return Padding(
      padding: EdgeInsets.fromLTRB(mobile ? 4 : 70, 0, mobile ? 4 : 70, 30),
      child: mobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                copy,
                const SizedBox(height: 12),
                visual,
              ],
            )
          : Row(
              children: [
                Expanded(flex: 11, child: copy),
                const SizedBox(width: 48),
                Expanded(flex: 9, child: visual),
              ],
            ),
    );
  }
}

class _HeroPrimaryButton extends StatelessWidget {
  const _HeroPrimaryButton({
    required this.label,
    required this.onPressed,
    this.compact = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: palette.gold,
        foregroundColor: goldButtonText,
        elevation: 1,
        overlayColor: Colors.white.withValues(alpha: .2),
        shadowColor: palette.brandDeep.withValues(alpha: .22),
        animationDuration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 22,
          vertical: compact ? 11 : 14,
        ),
        minimumSize: Size(0, compact ? 44 : 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(
          fontFamily: Theme.of(context).textTheme.labelLarge?.fontFamily,
          fontSize: compact ? 13 : 15,
          fontWeight: FontWeight.w800,
        ),
      ).copyWith(
        elevation: WidgetStateProperty.resolveWith<double?>((states) {
          if (states.contains(WidgetState.hovered)) return 7;
          if (states.contains(WidgetState.pressed)) return 3;
          return 1;
        }),
      ),
      child: Text(label),
    );
  }
}

class _HeroSecondaryButton extends StatelessWidget {
  const _HeroSecondaryButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.ink,
        backgroundColor: palette.surface,
        side: BorderSide(color: palette.line, width: 1.5),
        overlayColor: palette.brand.withValues(alpha: .09),
        animationDuration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ).copyWith(
        elevation: WidgetStateProperty.resolveWith<double?>((states) {
          if (states.contains(WidgetState.hovered)) return 4;
          if (states.contains(WidgetState.pressed)) return 2;
          return 0;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
          if (states.contains(WidgetState.hovered)) {
            return BorderSide(color: palette.brand, width: 1.8);
          }
          return BorderSide(color: palette.line, width: 1.5);
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.hovered)) {
            return palette.brand.withValues(alpha: .06);
          }
          return palette.surface;
        }),
      ),
      child: Text(label, maxLines: 1, softWrap: false),
    );
  }
}

class _HeroCoverCard extends StatelessWidget {
  const _HeroCoverCard({required this.slide, required this.mobile});

  final _HeroSlideData slide;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final iconTile = Container(
      width: mobile ? 50 : 76,
      height: mobile ? 50 : 76,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: slide.accent,
        borderRadius: BorderRadius.circular(mobile ? 17 : 22),
      ),
      child: Text(
        slide.emoji,
        style: TextStyle(fontSize: mobile ? 29 : 47, height: 1),
      ),
    );

    Widget valueLine({required bool compact}) => SizedBox(
      width: double.infinity,
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: slide.cardValue,
                style: TextStyle(
                  color: palette.brandDeep,
                  fontSize: compact ? 24 : 56,
                  fontWeight: FontWeight.w800,
                  letterSpacing: compact ? -.7 : -2.2,
                  height: 1.05,
                ),
              ),
              TextSpan(
                text: ' ${slide.cardValueSuffix}',
                style: TextStyle(
                  color: palette.muted,
                  fontSize: compact ? 13 : 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          maxLines: 1,
        ),
      ),
    );

    Widget textDetails({required bool compact}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          slide.cardTitle,
          style: TextStyle(
            color: palette.ink,
            fontSize: compact ? 18 : 27,
            fontWeight: FontWeight.w800,
            letterSpacing: compact ? -.3 : -.7,
            height: 1.15,
          ),
        ),
        SizedBox(height: compact ? 3 : 5),
        Text(
          slide.cardDescription,
          style: TextStyle(
            color: palette.muted,
            fontSize: compact ? 13 : 15,
            height: 1.3,
          ),
        ),
        SizedBox(height: compact ? 8 : 21),
        SizedBox(
          width: double.infinity,
          height: 2,
          child: CustomPaint(
            painter: _DashedLinePainter(color: palette.line),
          ),
        ),
        SizedBox(height: compact ? 7 : 18),
        valueLine(compact: compact),
      ],
    );

    final card = Container(
      width: double.infinity,
      height: mobile ? 150 : 410,
      padding: EdgeInsets.all(mobile ? 12 : 34),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(color: palette.line.withValues(alpha: .8)),
        borderRadius: BorderRadius.circular(mobile ? 22 : 38),
        boxShadow: [
          BoxShadow(
            color: palette.brandDeep.withValues(alpha: .16),
            blurRadius: 42,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: mobile
          ? Row(
              children: [
                iconTile,
                const SizedBox(width: 9),
                Expanded(child: textDetails(compact: true)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconTile,
                const SizedBox(height: 22),
                Text(
                  slide.cardTitle,
                  style: TextStyle(
                    color: palette.ink,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.7,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  slide.cardDescription,
                  style: TextStyle(color: palette.muted, fontSize: 15),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 2,
                  child: CustomPaint(
                    painter: _DashedLinePainter(color: palette.line),
                  ),
                ),
                const SizedBox(height: 18),
                valueLine(compact: false),
              ],
            ),
    );

    if (mobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          card,
          const SizedBox(height: 9),
          Wrap(
            spacing: 8,
            runSpacing: 7,
            children: [
              _FloatingTag(
                label: slide.topTag,
                compact: true,
                duration: const Duration(milliseconds: 2200),
              ),
              _FloatingTag(
                label: slide.bottomTag,
                compact: true,
                duration: const Duration(milliseconds: 2700),
              ),
            ],
          ),
        ],
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          top: -24,
          right: -12,
          child: _FloatingTag(
            label: slide.topTag,
            duration: const Duration(milliseconds: 2200),
          ),
        ),
        Positioned(
          bottom: -23,
          left: -24,
          child: _FloatingTag(
            label: slide.bottomTag,
            duration: const Duration(milliseconds: 2700),
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.round;
    for (var x = 0.0; x + 4 <= size.width; x += 8) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(x + 4, size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _FloatingTag extends StatefulWidget {
  const _FloatingTag({
    required this.label,
    this.compact = false,
    this.duration = const Duration(milliseconds: 2300),
  });

  final String label;
  final bool compact;
  final Duration duration;

  @override
  State<_FloatingTag> createState() => _FloatingTagState();
}

class _FloatingTagState extends State<_FloatingTag>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _offset = Tween<double>(begin: 0, end: -5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return AnimatedBuilder(
      animation: _offset,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.compact ? 11 : 16,
          vertical: widget.compact ? 7 : 11,
        ),
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border.all(color: palette.line),
          borderRadius: BorderRadius.circular(99),
          boxShadow: [
            BoxShadow(
              color: palette.brandDeep.withValues(alpha: .12),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: palette.brandDeep,
            fontSize: widget.compact ? 11 : 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _offset.value),
        child: child,
      ),
    );
  }
}

class _HeroArrow extends StatelessWidget {
  const _HeroArrow({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return Material(
      color: palette.surface,
      elevation: 5,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        tooltip: label,
        icon: Icon(icon, color: palette.brandDeep, size: 28),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: 520,
      height: 520,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    ),
  );
}

class _HeroSlideData {
  const _HeroSlideData({
    required this.title,
    required this.description,
    required this.emoji,
    required this.cardTitle,
    required this.cardDescription,
    required this.cardValue,
    required this.cardValueSuffix,
    required this.topTag,
    required this.bottomTag,
    required this.accent,
  });

  final String title;
  final String description;
  final String emoji;
  final String cardTitle;
  final String cardDescription;
  final String cardValue;
  final String cardValueSuffix;
  final String topTag;
  final String bottomTag;
  final Color accent;
}

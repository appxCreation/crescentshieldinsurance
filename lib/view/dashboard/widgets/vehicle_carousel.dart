import 'dart:async';

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'site_components.dart';

class VehicleCarousel extends StatefulWidget {
  const VehicleCarousel({super.key, required this.onQuote});

  final VoidCallback onQuote;

  @override
  State<VehicleCarousel> createState() => _VehicleCarouselState();
}

class _VehicleCarouselState extends State<VehicleCarousel> {
  final _controller = PageController();
  var _page = 0;
  Timer? _autoAdvance;

  static const _slides = [
    _VehicleSlide(
      label: 'Trucks',
      title: 'Third party protection for your truck',
      description:
          'Get the cover you need for your commercial truck, with quick paperwork and a digital policy.',
      button: 'Get a Truck Quote',
      icon: Icons.local_shipping_rounded,
      colors: [Color(0xff0b3d36), Color(0xff0f6b57)],
    ),
    _VehicleSlide(
      label: 'Trailers',
      title: 'Trailer cover with support when you need it',
      description:
          'Arrange third party insurance for your trailer with a digital policy and claims support at +92 308 6902148.',
      button: 'Get a Trailer Quote',
      icon: Icons.rv_hookup_rounded,
      colors: [Color(0xff102f2a), Color(0xff167b68)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _autoAdvance = Timer.periodic(const Duration(milliseconds: 5500), (_) {
      if (mounted) _goTo(_page + 1);
    });
  }

  @override
  void dispose() {
    _autoAdvance?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    final next = (page + _slides.length) % _slides.length;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width <= 800;
    return SiteContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(
          height: mobile ? 548 : 370,
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (value) => setState(() => _page = value),
                itemBuilder: (context, index) => _SlideCard(
                  slide: _slides[index],
                  index: index,
                  mobile: mobile,
                  onQuote: widget.onQuote,
                ),
              ),
              if (!mobile) ...[
                Positioned(
                  left: 14,
                  top: 0,
                  bottom: 0,
                  child: _ArrowButton(
                    icon: Icons.chevron_left_rounded,
                    label: 'Previous slide',
                    onPressed: () => _goTo(_page - 1),
                  ),
                ),
                Positioned(
                  right: 14,
                  top: 0,
                  bottom: 0,
                  child: _ArrowButton(
                    icon: Icons.chevron_right_rounded,
                    label: 'Next slide',
                    onPressed: () => _goTo(_page + 1),
                  ),
                ),
              ],
              Positioned(
                left: 0,
                right: 0,
                bottom: 18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _slides.length; i++)
                      InkWell(
                        onTap: () => _goTo(i),
                        borderRadius: BorderRadius.circular(99),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: i == _page ? 30 : 9,
                          height: 9,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: i == _page
                                ? SitePalette.of(context).gold
                                : Colors.white.withValues(alpha: .5),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: (_page + 1) / _slides.length,
                  minHeight: 3,
                  backgroundColor: Colors.white.withValues(alpha: .14),
                  valueColor: AlwaysStoppedAnimation(
                    SitePalette.of(context).gold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideCard extends StatelessWidget {
  const _SlideCard({
    required this.slide,
    required this.index,
    required this.mobile,
    required this.onQuote,
  });

  final _VehicleSlide slide;
  final int index;
  final bool mobile;
  final VoidCallback onQuote;

  @override
  Widget build(BuildContext context) {
    final copy = Column(
      crossAxisAlignment: mobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: .42)),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            slide.label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
        const SizedBox(height: 13),
        Text(
          slide.title,
          textAlign: mobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontSize: mobile ? 27 : 36,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
            slide.description,
            textAlign: mobile ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .9),
              height: 1.55,
            ),
          ),
        ),
        const SizedBox(height: 18),
        GoldButton(label: slide.button, onPressed: onQuote),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: slide.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: mobile ? -28 : 22,
            top: mobile ? -28 : 4,
            child: Text(
              '0${index + 1}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: .08),
                fontSize: mobile ? 94 : 140,
                height: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              mobile ? 24 : 56,
              mobile ? 34 : 36,
              mobile ? 24 : 56,
              50,
            ),
            child: mobile
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      copy,
                      const SizedBox(height: 16),
                      _VehicleIllustration(icon: slide.icon, size: 116),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(flex: 11, child: copy),
                      const SizedBox(width: 26),
                      Expanded(
                        flex: 9,
                        child: Center(
                          child: _VehicleIllustration(
                            icon: slide.icon,
                            size: 235,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _VehicleIllustration extends StatelessWidget {
  const _VehicleIllustration({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: .13),
      border: Border.all(color: Colors.white.withValues(alpha: .22)),
    ),
    child: Icon(icon, color: Colors.white, size: size * .55),
  );
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Center(
    child: IconButton.filledTonal(
      onPressed: onPressed,
      tooltip: label,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: .2),
        foregroundColor: Colors.white,
        fixedSize: const Size(44, 44),
      ),
      icon: Icon(icon),
    ),
  );
}

class _VehicleSlide {
  const _VehicleSlide({
    required this.label,
    required this.title,
    required this.description,
    required this.button,
    required this.icon,
    required this.colors,
  });

  final String label;
  final String title;
  final String description;
  final String button;
  final IconData icon;
  final List<Color> colors;
}

class StatsStrip extends StatelessWidget {
  const StatsStrip({super.key});

  static const _items = [
    ('24', 'Hour claim helpline'),
    ('5', 'Minutes to request a quote'),
    ('2', 'Vehicle types: truck & trailer'),
    ('100%', 'Digital paperwork'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final columns = MediaQuery.sizeOf(context).width <= 800 ? 2 : 4;
    return Container(
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: .86),
        border: Border(bottom: BorderSide(color: palette.line)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SiteContainer(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: columns == 2 ? 2.25 : 3.4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _items.length,
          itemBuilder: (context, index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [palette.brand, palette.gold],
                ).createShader(bounds),
                child: Text(
                  _items[index].$1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _items[index].$2,
                textAlign: TextAlign.center,
                style: TextStyle(color: palette.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

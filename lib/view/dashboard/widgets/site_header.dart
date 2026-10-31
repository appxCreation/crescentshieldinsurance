import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'site_components.dart';

class SiteHeader extends StatelessWidget {
  const SiteHeader({
    super.key,
    required this.isMobile,
    required this.onMenu,
    required this.onNavigate,
  });

  final bool isMobile;
  final VoidCallback onMenu;
  final ValueChanged<String> onNavigate;

  static const links = <(String, String)>[
    ('Plans', 'coverCards'),
    ('Services', 'services'),
    ('How it works', 'how'),
    ('FAQ', 'faq'),
    ('Contact', 'contact'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final tickerHeight = isMobile ? 40.0 : 44.0;
    final navHeight = isMobile ? 68.0 : 82.0;

    return SizedBox(
      height: tickerHeight + navHeight,
      child: Column(
        children: [
          Container(
            height: tickerHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [palette.brandDeep, palette.brand],
              ),
            ),
            child: _BrandTicker(compact: isMobile),
          ),
          Container(
            height: navHeight,
            color: palette.surface,
            child: SiteContainer(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onNavigate('top'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/logo/logoN.png',
                          width: isMobile ? 46 : 58,
                          height: isMobile ? 46 : 58,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 11),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Crescent Shield',
                              style: TextStyle(
                                color: palette.brandDeep,
                                fontWeight: FontWeight.w900,
                                fontSize: isMobile ? 19 : 27,
                                height: 1,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'MOTOR INSURANCE',
                              style: TextStyle(
                                color: palette.brand,
                                fontWeight: FontWeight.w900,
                                fontSize: isMobile ? 9 : 12,
                                letterSpacing: isMobile ? 1.7 : 2.4,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (isMobile)
                    IconButton(
                      onPressed: onMenu,
                      tooltip: 'Open menu',
                      icon: Icon(Icons.menu_rounded, color: palette.brandDeep),
                    )
                  else ...[
                    for (final link in links)
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: TextButton(
                          onPressed: () => onNavigate(link.$2),
                          style: TextButton.styleFrom(
                            foregroundColor: palette.ink,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            link.$1,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 10),
                    GoldButton(
                      label: 'Contact us',
                      compact: true,
                      onPressed: () => onNavigate('contact'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandTicker extends StatefulWidget {
  const _BrandTicker({required this.compact});

  final bool compact;

  @override
  State<_BrandTicker> createState() => _BrandTickerState();
}

class _BrandTickerState extends State<_BrandTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final labels = widget.compact
        ? const [
            'Crescent Shield',
            'Truck & Trailer',
            'Fleet Policies',
            'WhatsApp Support',
          ]
        : const [
            'Crescent Shield Insurance',
            'Truck & Trailer Cover',
            'Fleet Policies Available',
            'WhatsApp Support  +92 308 6902148',
          ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final groupWidth = constraints.maxWidth < 900
            ? 900.0
            : constraints.maxWidth;
        final separatorWidth = widget.compact ? 24.0 : 32.0;

        Widget tickerGroup() => SizedBox(
          width: groupWidth,
          child: Row(
            children: [
              for (var index = 0; index < labels.length; index++) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        labels[index],
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.compact ? 12 : 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: widget.compact ? 0 : .15,
                        ),
                      ),
                    ),
                  ),
                ),
                if (index != labels.length - 1)
                  SizedBox(
                    width: separatorWidth,
                    child: Icon(
                      Icons.diamond_rounded,
                      size: widget.compact ? 9 : 12,
                      color: palette.gold,
                    ),
                  ),
              ],
            ],
          ),
        );

        return ClipRect(
          child: OverflowBox(
            alignment: Alignment.centerLeft,
            minWidth: 0,
            maxWidth: double.infinity,
            child: AnimatedBuilder(
              animation: _controller,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [tickerGroup(), tickerGroup()],
              ),
              builder: (context, child) => Transform.translate(
                offset: Offset(-groupWidth * _controller.value, 0),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

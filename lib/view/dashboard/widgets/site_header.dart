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
    ('Services', 'services'),
    ('How It Works', 'how'),
    ('Claims', 'claims'),
    ('FAQ', 'faq'),
    ('Contact', 'contact'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return SiteContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 70,
        child: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onNavigate('top'),
              child: Row(
                children: [
                  const _BrandMark(size: 39),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crescent Shield',
                        style: TextStyle(
                          color: palette.brandDeep,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          height: 1.05,
                        ),
                      ),
                      Text(
                        'I N S U R A N C E',
                        style: TextStyle(
                          color: palette.gold,
                          fontWeight: FontWeight.w800,
                          fontSize: 9,
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
                  padding: const EdgeInsets.only(left: 18),
                  child: TextButton(
                    onPressed: () => onNavigate(link.$2),
                    style: TextButton.styleFrom(
                      foregroundColor: palette.ink,
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                    child: Text(
                      link.$1,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 17),
              GoldButton(
                label: 'Get a Quote',
                compact: true,
                onPressed: () => onNavigate('quote'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.shield_rounded,
          color: SitePalette.of(context).brand,
          size: size,
        ),
        Positioned(
          right: size * .22,
          top: size * .26,
          child: Icon(
            Icons.nightlight_round,
            color: SitePalette.of(context).gold,
            size: size * .42,
          ),
        ),
      ],
    ),
  );
}

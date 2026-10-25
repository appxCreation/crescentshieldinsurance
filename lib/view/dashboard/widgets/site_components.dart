import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class SiteContainer extends StatelessWidget {
  const SiteContainer({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1080),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
        child: child,
      ),
    ),
  );
}

class SiteSection extends StatelessWidget {
  const SiteSection({
    super.key,
    required this.child,
    this.alternate = false,
    this.verticalPadding = 70,
  });

  final Widget child;
  final bool alternate;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return Container(
      color: alternate ? palette.surface.withValues(alpha: .78) : null,
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: SiteContainer(child: child),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.bottomSpacing = 32,
  });

  final String title;
  final String? subtitle;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: palette.brandDeep,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              height: 1.15,
              letterSpacing: -.6,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 9),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Text(
                subtitle!,
                style: TextStyle(
                  color: palette.muted,
                  fontSize: 16,
                  height: 1.65,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SiteCard extends StatelessWidget {
  const SiteCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(color: palette.line),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: palette.ink.withValues(alpha: .055),
            blurRadius: 24,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: child,
    );
  }
}

class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.compact = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: palette.gold,
        foregroundColor: goldButtonText,
        textStyle: TextStyle(
          fontFamily: Theme.of(context).textTheme.labelLarge?.fontFamily,
          fontSize: compact ? 14 : 15,
          fontWeight: FontWeight.w900,
          letterSpacing: .1,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 17 : 22,
          vertical: compact ? 10 : 13,
        ),
        minimumSize: Size(0, compact ? 40 : 46),
        shape: const StadiumBorder(),
      ),
    );
  }
}

class OutlineHeroButton extends StatelessWidget {
  const OutlineHeroButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: BorderSide(color: Colors.white.withValues(alpha: .85), width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
      minimumSize: const Size(0, 46),
      shape: const StadiumBorder(),
    ),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
  );
}

class BulletList extends StatelessWidget {
  const BulletList({super.key, required this.items, this.negative = false});

  final List<String> items;
  final bool negative;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return Column(
      children: [
        for (final item in items)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: palette.line)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  negative ? Icons.close_rounded : Icons.check_rounded,
                  size: 19,
                  color: negative ? const Color(0xffc75a50) : palette.brand,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(color: palette.ink, height: 1.45),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class SoftPill extends StatelessWidget {
  const SoftPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .1),
      border: Border.all(color: Colors.white.withValues(alpha: .2)),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

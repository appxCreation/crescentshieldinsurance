import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'site_components.dart';

class VehicleCarousel extends StatefulWidget {
  const VehicleCarousel({
    super.key,
    required this.sectionKey,
    required this.onQuote,
  });

  final Key sectionKey;
  final ValueChanged<String> onQuote;

  @override
  State<VehicleCarousel> createState() => _VehicleCarouselState();
}

class _VehicleCarouselState extends State<VehicleCarousel> {
  var _selectedIndex = 0;

  static const _plans = [
    _VehiclePlan(
      vehicleType: 'Truck',
      title: 'Third party · Truck',
      amount: 'PKR 12,500',
      description: 'Per year. Final amount confirmed by our team.',
    ),
    _VehiclePlan(
      vehicleType: 'Trailer',
      title: 'Third party · Trailer',
      amount: 'PKR 12,500',
      description: 'Per year. Final amount confirmed by our team.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width <= 760;
    final selectedPlan = _plans[_selectedIndex];

    return Container(
      key: widget.sectionKey,
      width: double.infinity,
      color: const Color(0xff06251c),
      padding: EdgeInsets.symmetric(vertical: mobile ? 28 : 44),
      child: SiteContainer(
        padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 28),
        child: Container(
          padding: EdgeInsets.all(mobile ? 20 : 42),
          decoration: BoxDecoration(
            color: const Color(0xff0a2d23),
            border: Border.all(color: const Color(0xff1c4939)),
            borderRadius: BorderRadius.circular(mobile ? 28 : 38),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 32,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 720;
              final selector = _VehicleSelector(
                selectedIndex: _selectedIndex,
                labels: [for (final plan in _plans) plan.vehicleType],
                onSelected: (index) => setState(() => _selectedIndex = index),
              );
              final quoteCard = _PolicyPreviewCard(
                plan: selectedPlan,
                compact: compact,
                onQuote: () => widget.onQuote(selectedPlan.vehicleType),
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    selector,
                    const SizedBox(height: 25),
                    quoteCard,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: selector),
                  const SizedBox(width: 44),
                  Expanded(child: quoteCard),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _VehicleSelector extends StatelessWidget {
  const _VehicleSelector({
    required this.selectedIndex,
    required this.labels,
    required this.onSelected,
  });

  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'What are you insuring?',
          style: TextStyle(
            color: const Color(0xffe4f1ea),
            fontSize: 30,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var index = 0; index < labels.length; index++)
              _VehicleChoiceButton(
                label: labels[index],
                selected: selectedIndex == index,
                onTap: () => onSelected(index),
              ),
          ],
        ),
      ],
    );
  }
}

class _VehicleChoiceButton extends StatelessWidget {
  const _VehicleChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: label,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            color: selected ? const Color(0xff0b6746) : Colors.transparent,
            border: Border.all(
              color: selected
                  ? const Color(0xff0b6746)
                  : const Color(0xff24503f),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(17),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ]
                : const [],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xffe4f1ea),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );
}

class _PolicyPreviewCard extends StatelessWidget {
  const _PolicyPreviewCard({
    required this.plan,
    required this.compact,
    required this.onQuote,
  });

  final _VehiclePlan plan;
  final bool compact;
  final VoidCallback onQuote;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return Container(
      constraints: BoxConstraints(minHeight: compact ? 300 : 360),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 22 : 34,
        vertical: compact ? 28 : 38,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff075c3e), Color(0xff173e2e)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(compact ? 28 : 34),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                width: 420,
                height: 220,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.1,
                    colors: [
                      palette.gold.withValues(alpha: .2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Text(
                  plan.title,
                  key: ValueKey(plan.title),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xffe4f1ea),
                    fontSize: compact ? 20 : 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -.3,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: FittedBox(
                  key: ValueKey('${plan.title}-amount'),
                  fit: BoxFit.scaleDown,
                  child: Text(
                    plan.amount,
                    style: TextStyle(
                      color: palette.gold,
                      fontSize: compact ? 36 : 52,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1.8,
                      height: 1.05,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Text(
                  plan.description,
                  key: ValueKey('${plan.title}-description'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xffbdd4c8),
                    fontSize: compact ? 14 : 16,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _RequestPolicyButton(onPressed: onQuote, compact: compact),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequestPolicyButton extends StatelessWidget {
  const _RequestPolicyButton({required this.onPressed, required this.compact});

  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffffcb57), Color(0xfff2b632)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: palette.gold.withValues(alpha: .35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: goldButtonText,
          elevation: 0,
          overlayColor: Colors.white.withValues(alpha: .22),
          surfaceTintColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 17 : 28,
            vertical: compact ? 14 : 17,
          ),
          minimumSize: Size(0, compact ? 52 : 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: TextStyle(
            fontFamily: Theme.of(context).textTheme.labelLarge?.fontFamily,
            fontSize: compact ? 14 : 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -.1,
          ),
        ),
        child: const Text('Request this policy'),
      ),
    );
  }
}

class _VehiclePlan {
  const _VehiclePlan({
    required this.vehicleType,
    required this.title,
    required this.amount,
    required this.description,
  });

  final String vehicleType;
  final String title;
  final String amount;
  final String description;
}

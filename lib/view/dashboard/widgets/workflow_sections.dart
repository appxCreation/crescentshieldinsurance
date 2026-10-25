import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'site_components.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key, required this.sectionKey});

  final Key sectionKey;

  static const _steps = [
    (
      'Send details',
      'Fill the quote form with your vehicle type, registration number and contact.',
      Icons.assignment_outlined,
    ),
    (
      'Confirm & pay',
      'Receive your quote, confirm the cover and pay through your preferred channel.',
      Icons.payments_outlined,
    ),
    (
      'Get your policy',
      'Your policy document is issued digitally. Keep a copy in your phone and in the vehicle.',
      Icons.verified_user_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 700 ? 3 : 1;
    return SiteSection(
      key: sectionKey,
      alternate: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Get insured in 3 steps',
            subtitle:
                'No branch queues. Share your vehicle details and we handle the rest.',
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _steps.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              mainAxisExtent: columns == 1 ? 168 : 230,
            ),
            itemBuilder: (context, index) => _StepCard(
              number: index + 1,
              title: _steps[index].$1,
              description: _steps[index].$2,
              icon: _steps[index].$3,
            ),
          ),
          const SizedBox(height: 38),
          Text(
            'Keep these ready',
            style: TextStyle(
              color: SitePalette.of(context).brandDeep,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const BulletList(
            items: [
              'Vehicle registration book or smart card',
              'Owner’s CNIC copy',
              'Engine and chassis number',
              'Valid fitness certificate (for commercial vehicles)',
            ],
          ),
        ],
      ),
    );
  }
}

class ClaimsSection extends StatelessWidget {
  const ClaimsSection({super.key, required this.sectionKey});

  final Key sectionKey;

  static const _steps = [
    (
      'Call 15',
      'Report the accident to the police straight away and get a copy of the report.',
      Icons.local_police_outlined,
    ),
    (
      'Inform us',
      'Notify Crescent Shield Insurance immediately at +92 308 6902148 by phone or WhatsApp with your policy number.',
      Icons.support_agent_rounded,
    ),
    (
      'Collect documents',
      'Photos, police report, driving licence and the third party’s details.',
      Icons.folder_copy_outlined,
    ),
    (
      'We assist',
      'Our claims team guides you through the process until settlement.',
      Icons.handshake_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 900
        ? 4
        : width > 600
        ? 2
        : 1;
    return SiteSection(
      key: sectionKey,
      alternate: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'If an accident happens',
            subtitle: 'Stay calm and follow these steps.',
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _steps.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              mainAxisExtent: columns == 1 ? 160 : 216,
            ),
            itemBuilder: (context, index) => _StepCard(
              number: index + 1,
              title: _steps[index].$1,
              description: _steps[index].$2,
              icon: _steps[index].$3,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  final int number;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return SiteCard(
      padding: const EdgeInsets.fromLTRB(21, 20, 21, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.gold,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              '$number',
              style: TextStyle(
                color: goldButtonText,
                fontFamily: Theme.of(context).textTheme.labelLarge?.fontFamily,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: palette.brandDeep,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(icon, color: palette.brand.withValues(alpha: .8)),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(color: palette.muted, fontSize: 14, height: 1.45),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'site_components.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({
    super.key,
    required this.sectionKey,
    required this.onRequestService,
  });

  final Key sectionKey;
  final ValueChanged<String> onRequestService;

  static const _services = [
    _Service(
      name: 'Truck Third-Party Insurance',
      description:
          'Request third-party motor cover for your commercial truck, with straightforward paperwork and digital policy support.',
      icon: Icons.local_shipping_rounded,
    ),
    _Service(
      name: 'Trailer Third-Party Insurance',
      description:
          'Get help arranging third-party cover for your trailer and keep your policy details ready on the road.',
      icon: Icons.rv_hookup_rounded,
    ),
    _Service(
      name: 'Truck & Trailer Fleet Insurance',
      description:
          'Request a fleet quotation for multiple trucks and trailers under one coordinated service.',
      icon: Icons.route_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 900
        ? 3
        : width > 620
        ? 2
        : 1;
    return SiteSection(
      key: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Services for trucks & trailers',
            subtitle:
                'Tell us what you need. Our team will follow up to discuss cover and next steps.',
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _services.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              mainAxisExtent: columns == 1 ? 300 : 330,
            ),
            itemBuilder: (context, index) => _ServiceCard(
              service: _services[index],
              onRequest: () => onRequestService(_services[index].name),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.onRequest});

  final _Service service;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return SiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: palette.brand.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(service.icon, color: palette.brand, size: 30),
          ),
          const SizedBox(height: 18),
          Text(
            service.name,
            style: TextStyle(
              color: palette.brandDeep,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              service.description,
              style: TextStyle(color: palette.muted, height: 1.5),
            ),
          ),
          GoldButton(
            label: 'Request this service',
            icon: Icons.arrow_forward_rounded,
            compact: true,
            onPressed: onRequest,
          ),
        ],
      ),
    );
  }
}

class _Service {
  const _Service({
    required this.name,
    required this.description,
    required this.icon,
  });

  final String name;
  final String description;
  final IconData icon;
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/colors.dart';
import 'site_components.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key, required this.sectionKey});

  final Key sectionKey;

  static const _questions = [
    (
      'Is third-party insurance compulsory for trucks and trailers?',
      'Third-party motor insurance is required for vehicles using public roads in Pakistan. Contact us to discuss the cover required for your truck or trailer.',
    ),
    (
      'What does third-party cover protect?',
      'It covers your legal liability for injury or death of other people and damage to their property. It does not cover your own vehicle.',
    ),
    (
      'Can I transfer the policy when I sell my vehicle?',
      'Generally no. A motor policy is not transferable, so the new owner needs their own cover.',
    ),
    (
      'Do you insure truck and trailer fleets?',
      'Yes. Contact us with the number and type of trucks and trailers and we will prepare a fleet quotation.',
    ),
    (
      'How do I report a claim?',
      'Call 15 to report the accident, then call or WhatsApp us immediately at +92 308 6902148 with your policy number.',
    ),
  ];

  @override
  Widget build(BuildContext context) => SiteSection(
    key: sectionKey,
    alternate: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(title: 'Frequently asked questions'),
        for (final qa in _questions)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: SitePalette.of(context).surface,
              border: Border.all(color: SitePalette.of(context).line),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 19,
                  vertical: 2,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(19, 0, 19, 16),
                iconColor: SitePalette.of(context).brand,
                collapsedIconColor: SitePalette.of(context).brand,
                title: Text(
                  qa.$1,
                  style: TextStyle(
                    color: SitePalette.of(context).brandDeep,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      qa.$2,
                      style: TextStyle(
                        color: SitePalette.of(context).muted,
                        height: 1.55,
                      ),
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

class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.sectionKey});

  final Key sectionKey;

  static const _contact = [
    ('Phone / WhatsApp', '+92 308 6902148', Icons.call_outlined),
    ('Email', 'info@crescentshield.com', Icons.email_outlined),
    ('Office', 'Macdonald Bypass Sahiwal', Icons.location_on_outlined),
  ];

  Future<void> _openContact(int index) async {
    final Uri? uri = switch (index) {
      0 => Uri.parse('tel:+923086902148'),
      1 => Uri.parse('mailto:info@crescentshield.com'),
      _ => null,
    };
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final columns = MediaQuery.sizeOf(context).width > 700 ? 3 : 1;
    return SiteSection(
      key: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Contact us',
            subtitle: 'We are here to help.',
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _contact.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              mainAxisExtent: columns == 1 ? 115 : 145,
            ),
            itemBuilder: (context, index) => SiteCard(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () => _openContact(index),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: SitePalette.of(
                          context,
                        ).brand.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _contact[index].$3,
                        color: SitePalette.of(context).brand,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _contact[index].$1,
                            style: TextStyle(
                              color: SitePalette.of(context).brandDeep,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            _contact[index].$2,
                            style: TextStyle(
                              color: SitePalette.of(context).muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final brand = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Crescent Shield Insurance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Truck and trailer insurance with clear support.',
          style: TextStyle(color: Color(0xffcfe3de)),
        ),
      ],
    );
    final quickLinks = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick links',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        for (final item in const [
          ('Services', 'services'),
          ('Claims', 'claims'),
          ('FAQ', 'faq'),
        ])
          TextButton(
            onPressed: () => onNavigate(item.$2),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 4),
              foregroundColor: const Color(0xffcfe3de),
              alignment: Alignment.centerLeft,
            ),
            child: Text(item.$1),
          ),
      ],
    );
    const contact = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 9),
        Text('+92 308 6902148', style: TextStyle(color: Color(0xffcfe3de))),
        Text(
          'info@crescentshield.com',
          style: TextStyle(color: Color(0xffcfe3de)),
        ),
        Text(
          'Macdonald Bypass Sahiwal',
          style: TextStyle(color: Color(0xffcfe3de)),
        ),
      ],
    );
    const licence = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Licence',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 9),
        Text(
          'Insurer / SECP licence details: add here',
          style: TextStyle(color: Color(0xffcfe3de)),
        ),
      ],
    );
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [palette.heroStart, const Color(0xff06201c)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 43),
      child: SiteContainer(
        child: Column(
          children: [
            if (width > 850)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: brand),
                  Expanded(child: quickLinks),
                  Expanded(flex: 2, child: contact),
                  Expanded(child: licence),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  brand,
                  const SizedBox(height: 22),
                  quickLinks,
                  const SizedBox(height: 12),
                  contact,
                  const SizedBox(height: 18),
                  licence,
                ],
              ),
            const SizedBox(height: 26),
            Divider(color: Colors.white.withValues(alpha: .18)),
            const SizedBox(height: 12),
            Text(
              '© 2026 Crescent Shield Insurance. Insurance products may only be offered by entities licensed by the SECP.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: .75),
                fontSize: 12,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

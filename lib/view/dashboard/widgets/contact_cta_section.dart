import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'site_components.dart';

class ContactCtaSection extends StatelessWidget {
  const ContactCtaSection({
    super.key,
    required this.sectionKey,
    required this.onWhatsApp,
  });

  final Key sectionKey;
  final VoidCallback onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      key: sectionKey,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff06251c), Color(0xff061f17), Color(0xff172b18)],
          stops: [0, .66, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: width <= 760 ? 78 : 106),
      child: Stack(
        children: [
          Positioned(
            right: -150,
            bottom: -230,
            child: Container(
              width: 480,
              height: 480,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff384018).withValues(alpha: .5),
                    const Color(0xff384018).withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          SiteContainer(
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Text(
                    'Ready to insure your vehicle?',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      color: const Color(0xfff4faf6),
                      fontSize: width <= 760 ? 36 : 50,
                      fontWeight: FontWeight.w800,
                      height: 1.12,
                      letterSpacing: -1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    'Message us your vehicle details and we will reply with your policy steps.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: const Color(0xffb5cfc2),
                      fontSize: width <= 760 ? 16 : 18,
                      height: 1.55,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: onWhatsApp,
                  style: FilledButton.styleFrom(
                    backgroundColor: SitePalette.of(context).gold,
                    foregroundColor: goldButtonText,
                    minimumSize: const Size(0, 54),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                    textStyle: textTheme.labelLarge?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: const Text('Chat on WhatsApp'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

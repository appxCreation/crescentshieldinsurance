import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final palette = SitePalette.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: const Color(0xff06251c),
      padding: EdgeInsets.symmetric(vertical: width <= 760 ? 56 : 82),
      child: SiteContainer(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [palette.gold, palette.brand],
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Common questions',
                  style: textTheme.headlineMedium?.copyWith(
                    color: const Color(0xffe4f1ea),
                    fontSize: width <= 760 ? 36 : 50,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -1.3,
                  ),
                ),
                SizedBox(height: width <= 760 ? 34 : 52),
                for (final question in _questions)
                  SizedBox(
                    width: double.infinity,
                    child: _FaqAccordionItem(
                      question: question.$1,
                      answer: question.$2,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FaqAccordionItem extends StatefulWidget {
  const _FaqAccordionItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  State<_FaqAccordionItem> createState() => _FaqAccordionItemState();
}

class _FaqAccordionItemState extends State<_FaqAccordionItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xff0c2d24),
        border: Border.all(
          color: _expanded ? palette.brand : const Color(0xff1e4a3b),
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(26),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 18, 20, _expanded ? 10 : 18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: textTheme.titleMedium?.copyWith(
                        color: const Color(0xffe4f1ea),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _expanded
                          ? palette.gold
                          : const Color(0xff06251c),
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 160),
                      child: Icon(
                        _expanded ? Icons.close_rounded : Icons.add_rounded,
                        key: ValueKey(_expanded),
                        color: _expanded ? goldButtonText : palette.brand,
                        size: 21,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 72, 22),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.answer,
                        style: textTheme.bodyLarge?.copyWith(
                          color: const Color(0xff9dbbab),
                          fontSize: 17,
                          height: 1.55,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xff061b15),
        border: Border(top: BorderSide(color: Color(0xff164a36))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: SiteContainer(
        child: Row(
          mainAxisAlignment: width <= 500
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo/logoN.png',
              width: width <= 500 ? 38 : 44,
              height: width <= 500 ? 38 : 44,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                '© 2026 Crescent Shield Insurance. All rights reserved.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xff9dbbab),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

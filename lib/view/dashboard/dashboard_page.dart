import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import 'widgets/hero_section.dart';
import 'widgets/info_sections.dart';
import 'widgets/quote_section.dart';
import 'widgets/site_header.dart';
import 'widgets/services_section.dart';
import 'widgets/vehicle_carousel.dart';
import 'widgets/workflow_sections.dart';
import 'service_request_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sectionKeys = <String, GlobalKey>{
    for (final id in const [
      'top',
      'services',
      'how',
      'quote',
      'claims',
      'faq',
      'contact',
    ])
      id: GlobalKey(debugLabel: id),
  };

  void _navigateTo(String id) {
    final target = _sectionKeys[id]?.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
      alignment: .03,
    );
  }

  void _openServiceRequest(String serviceName) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ServiceRequestPage(serviceName: serviceName),
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/923086902148');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open WhatsApp. Please call +92 308 6902148.',
          ),
        ),
      );
    }
  }

  Widget _buildDrawer(BuildContext context) {
    final palette = SitePalette.of(context);
    return Drawer(
      backgroundColor: palette.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
              child: Text(
                'Crescent Shield',
                style: TextStyle(
                  color: palette.brandDeep,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Divider(color: palette.line, height: 1),
            for (final link in SiteHeader.links)
              ListTile(
                title: Text(link.$1),
                textColor: palette.ink,
                onTap: () {
                  Navigator.of(context).pop();
                  _navigateTo(link.$2);
                },
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(18),
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateTo('quote');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: palette.gold,
                  foregroundColor: goldButtonText,
                  minimumSize: const Size.fromHeight(48),
                  textStyle: TextStyle(
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.labelLarge?.fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .1,
                  ),
                ),
                child: const Text(
                  'Get a Quote',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final compactHeader = width <= 1050;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: palette.background,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  toolbarHeight: 70,
                  backgroundColor: palette.surface.withValues(alpha: .96),
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  title: SiteHeader(
                    isMobile: compactHeader,
                    onMenu: () => _scaffoldKey.currentState?.openDrawer(),
                    onNavigate: _navigateTo,
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(2),
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            palette.brand,
                            palette.brandDeep,
                            palette.gold,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: HeroSection(
                    key: _sectionKeys['top'],
                    onQuote: () => _navigateTo('quote'),
                    onClaims: () => _navigateTo('claims'),
                  ),
                ),
                const SliverToBoxAdapter(child: StatsStrip()),
                SliverToBoxAdapter(
                  child: VehicleCarousel(onQuote: () => _navigateTo('quote')),
                ),
                SliverToBoxAdapter(
                  child: ServicesSection(
                    sectionKey: _sectionKeys['services']!,
                    onRequestService: _openServiceRequest,
                  ),
                ),
                SliverToBoxAdapter(
                  child: HowItWorksSection(sectionKey: _sectionKeys['how']!),
                ),
                SliverToBoxAdapter(
                  child: QuoteSection(sectionKey: _sectionKeys['quote']!),
                ),
                SliverToBoxAdapter(
                  child: ClaimsSection(sectionKey: _sectionKeys['claims']!),
                ),
                SliverToBoxAdapter(
                  child: FaqSection(sectionKey: _sectionKeys['faq']!),
                ),
                SliverToBoxAdapter(
                  child: ContactSection(sectionKey: _sectionKeys['contact']!),
                ),
                SliverToBoxAdapter(child: SiteFooter(onNavigate: _navigateTo)),
              ],
            ),
            Positioned(
              right: 18,
              bottom: 18,
              child: Tooltip(
                message: 'Chat with us on WhatsApp',
                child: Material(
                  color: const Color(0xff25d366),
                  elevation: 8,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _openWhatsApp,
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/wtsap.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

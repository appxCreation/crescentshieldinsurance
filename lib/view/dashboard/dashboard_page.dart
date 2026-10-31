import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import 'widgets/contact_cta_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/info_sections.dart';
import 'widgets/site_header.dart';
import 'widgets/services_section.dart';
import 'widgets/vehicle_carousel.dart';
import 'widgets/vehicle_cover_carousel.dart';
import 'widgets/workflow_sections.dart';
import 'service_request_page.dart';
import '../certificate/certificate_section.dart';
import '../certificate/report_verification_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.certificateId});

  final String? certificateId;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sectionKeys = <String, GlobalKey>{
    for (final id in const [
      'top',
      'plans',
      'coverCards',
      'certificate',
      'services',
      'how',
      'faq',
      'contact',
    ])
      id: GlobalKey(debugLabel: id),
  };

  @override
  void initState() {
    super.initState();
    if (widget.certificateId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _navigateTo('certificate');
      });
    }
  }

  void _navigateTo(String id) {
    final target = _sectionKeys[id]?.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
      alignment: .12,
    );
  }

  void _openContactCta(String _) => _navigateTo('contact');

  void _openServiceRequest(String serviceName) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ServiceRequestPage(serviceName: serviceName),
      ),
    );
  }

  void _openReportVerification() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ReportVerificationPage(),
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final link in SiteHeader.links)
                    ListTile(
                      title: Text(link.$1),
                      textColor: palette.ink,
                      onTap: () {
                        Navigator.of(context).pop();
                        _navigateTo(link.$2);
                      },
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateTo('contact');
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
                  'Contact us',
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
                  toolbarHeight: compactHeader ? 108 : 126,
                  backgroundColor: palette.surface,
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
                            palette.brandDeep,
                            palette.brand,
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
                    onQuote: () => _navigateTo('contact'),
                    onHowItWorks: () => _navigateTo('contact'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: VehicleCarousel(
                    sectionKey: _sectionKeys['plans']!,
                    onQuote: _openContactCta,
                  ),
                ),
                if (widget.certificateId != null)
                  SliverToBoxAdapter(
                    child: CertificateSection(
                      sectionKey: _sectionKeys['certificate']!,
                      certificateId: widget.certificateId!,
                    ),
                  ),
                SliverToBoxAdapter(
                  child: VehicleCoverCarousel(
                    sectionKey: _sectionKeys['coverCards']!,
                    onQuote: _openContactCta,
                  ),
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
                  child: FaqSection(sectionKey: _sectionKeys['faq']!),
                ),
                SliverToBoxAdapter(
                  child: ContactCtaSection(
                    sectionKey: _sectionKeys['contact']!,
                    onWhatsApp: _openWhatsApp,
                  ),
                ),
                const SliverToBoxAdapter(child: SiteFooter()),
                if (width <= 760)
                  const SliverToBoxAdapter(child: SizedBox(height: 78)),
              ],
            ),
            if (width <= 760)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                  decoration: BoxDecoration(
                    color: palette.brandDeep.withValues(alpha: .96),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: .12),
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: palette.brandDeep.withValues(alpha: .18),
                        blurRadius: 20,
                        offset: const Offset(0, -7),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _navigateTo('contact'),
                          style: FilledButton.styleFrom(
                            backgroundColor: palette.gold,
                            foregroundColor: goldButtonText,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          child: const Text('Contact us'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _openWhatsApp,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xff25d366),
                            foregroundColor: const Color(0xff052217),
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          icon: Image.asset(
                            'assets/icons/wtsap.png',
                            width: 19,
                            height: 19,
                          ),
                          label: const Text('WhatsApp us'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              right: width <= 760 ? 14 : 26,
              bottom: width <= 760 ? 88 : 26,
              child: FloatingActionButton.extended(
                heroTag: 'report-verification-fab',
                onPressed: _openReportVerification,
                backgroundColor: palette.brandDeep,
                foregroundColor: Colors.white,
                elevation: 7,
                icon: const Icon(Icons.fact_check_outlined),
                label: const Text('Report Verification'),
                extendedPadding: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                tooltip: 'Report Verification',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

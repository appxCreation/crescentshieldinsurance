import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/colors.dart';
import '../dashboard/widgets/site_components.dart';
import 'widgets/certificate_document.dart';

class CertificateSection extends StatefulWidget {
  const CertificateSection({
    super.key,
    required this.sectionKey,
    this.certificateId,
    this.certificateData,
  }) : assert(certificateId != null || certificateData != null);

  final Key sectionKey;
  final String? certificateId;
  final Map<String, dynamic>? certificateData;

  @override
  State<CertificateSection> createState() => _CertificateSectionState();
}

class _CertificateSectionState extends State<CertificateSection> {
  late Future<Map<String, dynamic>?> _certificate;

  @override
  void initState() {
    super.initState();
    _certificate = widget.certificateData == null
        ? _loadCertificate()
        : Future.value(widget.certificateData);
  }

  Future<Map<String, dynamic>?> _loadCertificate() async {
    final response = await Supabase.instance.client.rpc(
      'get_insurance_certificate_by_id',
      params: {'certificate_id': widget.certificateId},
    );

    if (response == null) return null;
    if (response is Map) return Map<String, dynamic>.from(response);
    throw const FormatException('Unexpected certificate response.');
  }

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);

    return SiteSection(
      key: widget.sectionKey,
      alternate: true,
      verticalPadding: 48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Insurance certificate',
            subtitle:
                'Certificate details associated with this verification link.',
            bottomSpacing: 22,
          ),
          FutureBuilder<Map<String, dynamic>?>(
            future: _certificate,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return SiteCard(
                  child: SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(color: palette.brand),
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return _CertificateStatus(
                  title: 'Certificate could not be loaded',
                  message:
                      'Run the certificate lookup SQL in Supabase, then refresh this page.',
                  onRetry: () => setState(() {
                    _certificate = _loadCertificate();
                  }),
                );
              }

              final certificate = snapshot.data;
              if (certificate == null) {
                return const _CertificateStatus(
                  title: 'Certificate not found',
                  message:
                      'No insurance certificate matches this document ID.',
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final documentWidth = constraints.maxWidth
                      .clamp(1.0, 920.0)
                      .toDouble();
                  return SiteCard(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: CertificateDocument(
                        certificate: certificate,
                        width: documentWidth,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CertificateStatus extends StatelessWidget {
  const _CertificateStatus({
    required this.title,
    required this.message,
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return SiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: palette.brandDeep,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: palette.muted, height: 1.5)),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: palette.gold,
                foregroundColor: goldButtonText,
              ),
              child: const Text('Try again'),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/colors.dart';
import '../dashboard/widgets/site_components.dart';
import 'certificate_section.dart';

class ReportVerificationPage extends StatefulWidget {
  const ReportVerificationPage({super.key});

  @override
  State<ReportVerificationPage> createState() => _ReportVerificationPageState();
}

class _ReportVerificationPageState extends State<ReportVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _registrationController = TextEditingController();
  final _chassisController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _registrationController.dispose();
    _chassisController.dispose();
    super.dispose();
  }

  Future<void> _verifyCertificate() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final response = await Supabase.instance.client.rpc(
        'verify_insurance_certificate',
        params: {
          'p_registration_number': _registrationController.text.trim(),
          'p_chassis_number': _chassisController.text.trim(),
        },
      );

      Map<String, dynamic>? certificate;
      if (response is Map) {
        certificate = Map<String, dynamic>.from(response);
      } else if (response is List && response.isNotEmpty && response.first is Map) {
        certificate = Map<String, dynamic>.from(response.first as Map);
      }

      if (!mounted) return;
      if (certificate == null || certificate['id'] == null) {
        setState(() {
          _errorMessage =
              'We could not find a certificate matching both numbers. Check them and try again.';
          _isSubmitting = false;
        });
        return;
      }

      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => VerifiedCertificatePage(
            certificate: certificate!,
            registrationNumber: _registrationController.text.trim(),
            chassisNumber: _chassisController.text.trim(),
          ),
        ),
      );
      if (mounted) setState(() => _isSubmitting = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage =
            'Verification is temporarily unavailable. Please try again in a moment.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: palette.brandDeep,
        title: const Text('Report Verification'),
        titleTextStyle: TextStyle(
          color: palette.brandDeep,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            width <= 600 ? 18 : 28,
            30,
            width <= 600 ? 18 : 28,
            40,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'REPORT VERIFICATION',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: palette.brandDeep,
                      fontSize: width <= 600 ? 28 : 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .4,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter the vehicle details to verify its insurance certificate.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: palette.muted,
                      fontSize: width <= 600 ? 15 : 17,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 26),
                  SiteCard(
                    padding: EdgeInsets.all(width <= 600 ? 20 : 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _VerificationField(
                            controller: _registrationController,
                            label: 'Registration number',
                            hint: 'Enter registration number',
                          ),
                          const SizedBox(height: 20),
                          _VerificationField(
                            controller: _chassisController,
                            label: 'Chassis number',
                            hint: 'Enter chassis number',
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xfffff0ed),
                                border: Border.all(
                                  color: const Color(0xffefc0b8),
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xff963d32),
                                  fontWeight: FontWeight.w700,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : _verifyCertificate,
                              style: FilledButton.styleFrom(
                                backgroundColor: palette.gold,
                                foregroundColor: goldButtonText,
                                disabledBackgroundColor: palette.gold.withValues(
                                  alpha: .65,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: goldButtonText,
                                      ),
                                    )
                                  : const Text('Continue'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VerificationField extends StatelessWidget {
  const _VerificationField({
    required this.controller,
    required this.label,
    required this.hint,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      textCapitalization: TextCapitalization.characters,
      autocorrect: false,
      style: TextStyle(
        color: palette.ink,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: palette.brandDeep,
          fontWeight: FontWeight.w700,
        ),
        hintStyle: TextStyle(color: palette.muted.withValues(alpha: .75)),
        filled: true,
        fillColor: palette.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.brand, width: 1.7),
        ),
      ),
      validator: (value) => value == null || value.trim().isEmpty
          ? 'Please enter your ${label.toLowerCase()}.'
          : null,
    );
  }
}

class VerifiedCertificatePage extends StatefulWidget {
  const VerifiedCertificatePage({
    super.key,
    required this.certificate,
    required this.registrationNumber,
    required this.chassisNumber,
  });

  final Map<String, dynamic> certificate;
  final String registrationNumber;
  final String chassisNumber;

  @override
  State<VerifiedCertificatePage> createState() =>
      _VerifiedCertificatePageState();
}

class _VerifiedCertificatePageState extends State<VerifiedCertificatePage> {
  final _certificateKey = GlobalKey(debugLabel: 'verified-certificate');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _certificateKey.currentContext;
      if (target != null && mounted) {
        Scrollable.ensureVisible(
          target,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          alignment: .02,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: palette.brandDeep,
        title: const Text('Verified certificate'),
        titleTextStyle: TextStyle(
          color: palette.brandDeep,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CertificateSection(
                sectionKey: _certificateKey,
                certificateData: widget.certificate,
              ),
            ),
            SliverToBoxAdapter(
              child: SiteSection(
                verticalPadding: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Verification details',
                      style: TextStyle(
                        color: palette.brandDeep,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SiteCard(
                      child: Column(
                        children: [
                          _ReadOnlyVerificationValue(
                            label: 'Registration number',
                            value: widget.registrationNumber,
                          ),
                          const SizedBox(height: 16),
                          _ReadOnlyVerificationValue(
                            label: 'Chassis number',
                            value: widget.chassisNumber,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('Verify another certificate'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: palette.brandDeep,
                        side: BorderSide(color: palette.line, width: 1.4),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyVerificationValue extends StatelessWidget {
  const _ReadOnlyVerificationValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: palette.brandDeep,
          fontWeight: FontWeight.w700,
        ),
        filled: true,
        fillColor: palette.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.line),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          value.toUpperCase(),
          style: TextStyle(
            color: palette.ink,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

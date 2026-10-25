import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/colors.dart';
import 'widgets/site_components.dart';

class ServiceRequestPage extends StatefulWidget {
  const ServiceRequestPage({super.key, required this.serviceName});

  final String serviceName;

  @override
  State<ServiceRequestPage> createState() => _ServiceRequestPageState();
}

class _ServiceRequestPageState extends State<ServiceRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  var _isSubmitting = false;
  String? _feedback;
  var _feedbackIsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _clearFeedback() {
    if (_feedback != null) setState(() => _feedback = null);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _feedback = null;
    });

    try {
      await Supabase.instance.client.from('service_request').insert({
        'service_name': widget.serviceName,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'description': _descriptionController.text.trim(),
      });
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _feedback = 'Thank you! Your service request has been sent.';
        _feedbackIsError = false;
      });
      _nameController.clear();
      _phoneController.clear();
      _descriptionController.clear();
      _formKey.currentState?.reset();
    } catch (error) {
      debugPrint('service_request insert failed: $error');
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _feedback =
            'We could not send your request. Please try again or WhatsApp us at +92 308 6902148.';
        _feedbackIsError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = SitePalette.of(context);
    final fieldDecoration = InputDecoration(
      filled: true,
      fillColor: palette.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: palette.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: palette.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: palette.brand, width: 1.5),
      ),
    );

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: const Text('Request a service'),
        backgroundColor: palette.surface,
        foregroundColor: palette.brandDeep,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 38),
          child: SiteContainer(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading(
                    title: 'Tell us what you need',
                    subtitle:
                        'Share your contact details and a few details about your request. Our team will follow up with you.',
                    bottomSpacing: 22,
                  ),
                  SiteCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: palette.brand.withValues(alpha: .09),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_shipping_outlined,
                                  color: palette.brand,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    widget.serviceName,
                                    style: TextStyle(
                                      color: palette.brandDeep,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          _ServiceFormField(
                            label: 'Full name',
                            child: TextFormField(
                              controller: _nameController,
                              decoration: fieldDecoration,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Please enter your name'
                                  : null,
                              onChanged: (_) => _clearFeedback(),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _ServiceFormField(
                            label: 'Phone / WhatsApp',
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: fieldDecoration,
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Please enter your phone or WhatsApp number'
                                  : null,
                              onChanged: (_) => _clearFeedback(),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _ServiceFormField(
                            label: 'Request details',
                            child: TextFormField(
                              controller: _descriptionController,
                              decoration: fieldDecoration.copyWith(
                                hintText:
                                    'Tell us about your truck or trailer and what you need',
                                alignLabelWithHint: true,
                              ),
                              minLines: 4,
                              maxLines: 7,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Please add a few details about your request'
                                  : null,
                              onChanged: (_) => _clearFeedback(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: palette.gold,
                              foregroundColor: goldButtonText,
                              minimumSize: const Size.fromHeight(48),
                              shape: const StadiumBorder(),
                              textStyle: TextStyle(
                                fontFamily: Theme.of(
                                  context,
                                ).textTheme.labelLarge?.fontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .1,
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Send service request',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                          ),
                          if (_feedback != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: _feedbackIsError
                                    ? const Color(0xffb5473e)
                                    : palette.brand,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _feedback!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
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

class _ServiceFormField extends StatelessWidget {
  const _ServiceFormField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          label,
          style: TextStyle(
            color: SitePalette.of(context).muted,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child,
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../constants/colors.dart';
import 'site_components.dart';

class QuoteSection extends StatelessWidget {
  const QuoteSection({super.key, required this.sectionKey});

  final Key sectionKey;

  @override
  Widget build(BuildContext context) => SiteSection(
    key: sectionKey,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 720;
        final details = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              title: 'Request a quote',
              subtitle:
                  'Tell us about your truck or trailer and our team will call you back with a clear price. No hidden charges.',
              bottomSpacing: 20,
            ),
            const BulletList(
              items: [
                'Transparent pricing',
                'Fleet discounts on request',
                'Callback within working hours',
              ],
            ),
          ],
        );
        const form = _QuoteRequestForm();
        if (mobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [details, const SizedBox(height: 24), form],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: details),
            const SizedBox(width: 32),
            const Expanded(child: form),
          ],
        );
      },
    ),
  );
}

class _QuoteRequestForm extends StatefulWidget {
  const _QuoteRequestForm();

  @override
  State<_QuoteRequestForm> createState() => _QuoteRequestFormState();
}

class _QuoteRequestFormState extends State<_QuoteRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  var _vehicleType = 'Truck';
  var _isSubmitting = false;
  String? _feedback;
  var _feedbackIsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _feedback = null;
    });

    try {
      await Supabase.instance.client.from('requested_vehicles').insert({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'vehicle_type': _vehicleType,
        'vehicle_number': _vehicleNumberController.text.trim(),
      });
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _feedback =
            'Thank you! Your request has been sent. We will contact you shortly.';
        _feedbackIsError = false;
      });
      _nameController.clear();
      _phoneController.clear();
      _vehicleNumberController.clear();
    } catch (error) {
      debugPrint('requested_vehicles insert failed: $error');
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _feedback =
            'We could not send your request. Please try again or WhatsApp us at +92 308 6902148.';
        _feedbackIsError = true;
      });
    }
  }

  void _clearFeedback() {
    if (_feedback != null) setState(() => _feedback = null);
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

    return SiteCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FormField(
              label: 'Full name',
              child: TextFormField(
                controller: _nameController,
                decoration: fieldDecoration,
                textCapitalization: TextCapitalization.words,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter your name'
                    : null,
                onChanged: (_) => _clearFeedback(),
              ),
            ),
            const SizedBox(height: 13),
            _FormField(
              label: 'Phone / WhatsApp',
              child: TextFormField(
                controller: _phoneController,
                decoration: fieldDecoration,
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter a phone number'
                    : null,
                onChanged: (_) => _clearFeedback(),
              ),
            ),
            const SizedBox(height: 13),
            _FormField(
              label: 'Vehicle type',
              child: DropdownButtonFormField<String>(
                value: _vehicleType,
                decoration: fieldDecoration,
                items: const [
                  DropdownMenuItem(value: 'Truck', child: Text('Truck')),
                  DropdownMenuItem(value: 'Trailer', child: Text('Trailer')),
                ],
                onChanged: (value) {
                  setState(() {
                    _vehicleType = value ?? _vehicleType;
                    _feedback = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 13),
            _FormField(
              label: 'Truck / trailer number',
              child: TextFormField(
                controller: _vehicleNumberController,
                decoration: fieldDecoration.copyWith(
                  hintText: 'Enter vehicle registration number',
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter the truck or trailer number'
                    : null,
                onChanged: (_) => _clearFeedback(),
              ),
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: palette.gold,
                  foregroundColor: goldButtonText,
                  minimumSize: const Size(190, 46),
                  shape: const StadiumBorder(),
                  textStyle: TextStyle(
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.labelLarge?.fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .1,
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Request Callback',
                        style: TextStyle(fontWeight: FontWeight.w800),
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
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({required this.label, required this.child});

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

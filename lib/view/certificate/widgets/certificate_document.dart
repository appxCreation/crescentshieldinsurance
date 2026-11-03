import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../constants/colors.dart';

class CertificateDocument extends StatelessWidget {
  const CertificateDocument({
    super.key,
    required this.certificate,
    required this.width,
  });

  final Map<String, dynamic> certificate;
  final double width;

  static const _imageWidth = 2382.0;
  static const _imageHeight = 3369.0;
  static const _certificateTemplateUrl =
      'https://xvthbqfvvjhndkvuyrgd.supabase.co/storage/v1/object/public/certificates/EcoShield%20Takaful%20Insurance%20Certificate.png';
  static const _months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  String _rawValue(List<String> keys) {
    for (final key in keys) {
      final value = certificate[key]?.toString().trim();
      if (value != null && value.isNotEmpty && value.toLowerCase() != 'null') {
        return value;
      }
    }
    return '';
  }

  String _value(List<String> keys, {String fallback = 'NOT PROVIDED'}) {
    final value = _rawValue(keys);
    return value.isEmpty ? fallback : value.toUpperCase();
  }

  DateTime? _dateFrom(List<String> keys) {
    final raw = _rawValue(keys);
    if (raw.isEmpty) return null;

    final parsed = DateTime.tryParse(raw);
    if (parsed != null) return parsed;

    final match = RegExp(
      r'^(\d{1,2})[-/\s]([A-Za-z]{3,9})[-/\s](\d{4})$',
    ).firstMatch(raw);
    if (match == null) return null;

    final monthToken = match.group(2)!.toLowerCase();
    const monthNames = {
      'jan': 1,
      'january': 1,
      'feb': 2,
      'february': 2,
      'mar': 3,
      'march': 3,
      'apr': 4,
      'april': 4,
      'may': 5,
      'jun': 6,
      'june': 6,
      'jul': 7,
      'july': 7,
      'aug': 8,
      'august': 8,
      'sep': 9,
      'sept': 9,
      'september': 9,
      'oct': 10,
      'october': 10,
      'nov': 11,
      'november': 11,
      'dec': 12,
      'december': 12,
    };
    final month = monthNames[monthToken];
    if (month == null) return null;
    return DateTime(
      int.parse(match.group(3)!),
      month,
      int.parse(match.group(1)!),
    );
  }

  String _formatDate(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}-${_months[value.month - 1]}-${value.year}';

  String _certificateNumber() {
    final id = _rawValue(['id']).replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    final shortId = id.isEmpty
        ? '0001'
        : id.substring(0, id.length > 4 ? 4 : id.length).toUpperCase();
    final issueDate = _dateFrom([
      'date_of_issue',
      'issued_at',
      'created_at',
      'period_from',
    ]);
    final year = (issueDate ?? DateTime.now()).year;
    return 'CSI/TP/$year/$shortId';
  }

  String? _certificateUrl() {
    final id = _rawValue(['id']);
    if (id.isEmpty) return null;
    return Uri.https(
      'appxcreation.github.io',
      '/crescentshieldinsurance/$id',
    ).toString();
  }

  String _make() {
    final explicitMake = _rawValue(['vehicle_make', 'manufacturer']);
    if (explicitMake.isNotEmpty) return explicitMake.toUpperCase();

    final make = _rawValue(['make']);
    if (RegExp(r'^\d{4}$').hasMatch(make)) return 'NOT PROVIDED';
    return make.isEmpty ? 'NOT PROVIDED' : make.toUpperCase();
  }

  String _modelAndYear() {
    final model = _rawValue(['model', 'model_name']);
    var year = _rawValue(['manufacturing_year', 'year', 'model_year']);
    final make = _rawValue(['make']);
    if (year.isEmpty && RegExp(r'^\d{4}$').hasMatch(make)) year = make;

    if (model.isEmpty && year.isEmpty) return 'NOT PROVIDED';
    if (model.isEmpty) return year.toUpperCase();
    if (year.isEmpty) return model.toUpperCase();
    return '${model.toUpperCase()} / ${year.toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final pageHeight = width * _imageHeight / _imageWidth;
    final today = DateTime.now();
    final periodFrom = _dateFrom(['period_from']) ?? today;
    final periodTo = _dateFrom(['period_to']) ??
        DateTime(periodFrom.year + 1, periodFrom.month, periodFrom.day)
            .subtract(const Duration(days: 1));
    final days = periodTo.difference(periodFrom).inDays + 1;
    final duration = days > 0 ? days : 365;

    return SizedBox(
      width: width,
      height: pageHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final pageWidth = constraints.maxWidth;
          final pageHeight = constraints.maxHeight;

          return Image.network(
            _certificateTemplateUrl,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
            frameBuilder: (context, image, frame, wasSynchronouslyLoaded) {
              if (!wasSynchronouslyLoaded && frame == null) {
                final palette = SitePalette.of(context);

                return ColoredBox(
                  color: palette.background,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 46,
                          height: 46,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: palette.brandDeep,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Loading certificate image, please wait…',
                          style: TextStyle(
                            color: palette.brandDeep,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Stack(
                fit: StackFit.expand,
                children: [
                  image,

                  if (_certificateUrl() case final certificateUrl?)
                    Positioned(
                      left: pageWidth * .565,
                      top: pageHeight * .253,
                      width: pageWidth * .069,
                      height: pageWidth * .069,
                      child: QrImageView(
                        data: certificateUrl,
                        version: QrVersions.auto,
                        size: pageWidth * .069,
                        padding: EdgeInsets.all(pageWidth * .0022),
                        backgroundColor: Colors.white,
                        gapless: false,
                        semanticsLabel:
                            'Scan to verify this insurance certificate',
                      ),
                    ),

                  // Certificate number and issue date in the two top cards.
                  _CertificateValue(
                    left: pageWidth * .082,
                    top: pageHeight * .282,
                    width: pageWidth * .205,
                    fontSize: pageWidth * .02,
                    value: _certificateNumber(),
                    color: SitePalette.light.brandDeep,
                  ),
                  _CertificateValue(
                    left: pageWidth * .311,
                    top: pageHeight * .282,
                    width: pageWidth * .17,
                    fontSize: pageWidth * .02,
                    value: _formatDate(
                      _dateFrom(['date_of_issue', 'issued_at', 'created_at']) ??
                          periodFrom,
                    ),
                    color: SitePalette.light.brandDeep,
                  ),

                  // Insurance details: the template itself supplies each label.
                  _CertificateValue(
                    left: pageWidth * .245,
                    top: pageHeight * .357,
                    width: pageWidth * .68,
                    fontSize: pageWidth * .0138,
                    value: _value(['insured_name']),
                  ),
                  _CertificateValue(
                    left: pageWidth * .245,
                    top: pageHeight * .378,
                    width: pageWidth * .68,
                    fontSize: pageWidth * .0138,
                    value: _value(['city'], fallback: 'SAHIWAL'),
                  ),
                  _CertificateValue(
                    left: pageWidth * .245,
                    top: pageHeight * .399,
                    width: pageWidth * .68,
                    fontSize: pageWidth * .0138,
                    value: _value(
                      ['address'],
                      fallback: 'MACDONALD BYPASS SAHIWAL',
                    ),
                  ),

                  // Insurance period values sit inside the green date panels.
                  _CertificateValue(
                    left: pageWidth * .118,
                    top: pageHeight * .456,
                    width: pageWidth * .183,
                    fontSize: pageWidth * .014,
                    value: _formatDate(periodFrom),
                    color: Colors.white,
                    align: TextAlign.center,
                  ),
                  _CertificateValue(
                    left: pageWidth * .351,
                    top: pageHeight * .456,
                    width: pageWidth * .183,
                    fontSize: pageWidth * .014,
                    value: _formatDate(periodTo),
                    color: Colors.white,
                    align: TextAlign.center,
                  ),
                  _CertificateValue(
                    left: pageWidth * .548,
                    top: pageHeight * .456,
                    width: pageWidth * .09,
                    fontSize: pageWidth * .011,
                    value: '($duration DAYS)',
                    color: SitePalette.light.brandDeep,
                    align: TextAlign.center,
                  ),

                  // Vehicle details use the template's two-column label grid.
                  _CertificateValue(
                    left: pageWidth * .215,
                    top: pageHeight * .507,
                    width: pageWidth * .27,
                    fontSize: pageWidth * .0138,
                    value: _value(['registration_number']),
                  ),
                  _CertificateValue(
                    left: pageWidth * .215,
                    top: pageHeight * .529,
                    width: pageWidth * .27,
                    fontSize: pageWidth * .0138,
                    value: _modelAndYear(),
                  ),
                  _CertificateValue(
                    left: pageWidth * .215,
                    top: pageHeight * .551,
                    width: pageWidth * .27,
                    fontSize: pageWidth * .0138,
                    value: _make(),
                  ),
                  _CertificateValue(
                    left: pageWidth * .215,
                    top: pageHeight * .573,
                    width: pageWidth * .27,
                    fontSize: pageWidth * .0138,
                    value: _value(
                      ['vehicle_category', 'vehicle_type'],
                      fallback: 'TRUCK / TRAILER',
                    ),
                  ),
                  _CertificateValue(
                    left: pageWidth * .674,
                    top: pageHeight * .507,
                    width: pageWidth * .25,
                    fontSize: pageWidth * .0138,
                    value: _value(['engine_number']),
                  ),
                  _CertificateValue(
                    left: pageWidth * .674,
                    top: pageHeight * .529,
                    width: pageWidth * .25,
                    fontSize: pageWidth * .0138,
                    value: _value(['chassis_number']),
                  ),
                  _CertificateValue(
                    left: pageWidth * .674,
                    top: pageHeight * .551,
                    width: pageWidth * .25,
                    fontSize: pageWidth * .0138,
                    value: _value(['seat_capacity', 'seating_capacity']),
                  ),
                  _CertificateValue(
                    left: pageWidth * .674,
                    top: pageHeight * .573,
                    width: pageWidth * .25,
                    fontSize: pageWidth * .0138,
                    value: _value(
                      ['insurance_package', 'package'],
                      fallback: 'THIRD PARTY LIABILITY',
                    ),
                  ),
                ],
              );
            },
            errorBuilder: (context, error, stackTrace) {
              final palette = SitePalette.of(context);
              return ColoredBox(
                color: palette.background,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          size: 42,
                          color: palette.brandDeep,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Certificate image could not be loaded.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: palette.brandDeep,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Check your connection and refresh to try again.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: palette.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CertificateValue extends StatelessWidget {
  const _CertificateValue({
    required this.left,
    required this.top,
    required this.width,
    required this.fontSize,
    required this.value,
    this.color = const Color(0xff052217),
    this.align = TextAlign.start,
  });

  final double left;
  final double top;
  final double width;
  final double fontSize;
  final String value;
  final Color color;
  final TextAlign align;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    child: Text(
      value.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: .08,
      ),
    ),
  );
}

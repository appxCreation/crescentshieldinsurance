import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';

class AppDatePicker {
  static Future<DateTime?> show(
      BuildContext context, {
        DateTime? initialDate,
        DateTime? firstDate,
        DateTime? lastDate,
      }) async {
    final now = DateTime.now();

    final selectedInitialDate = initialDate ?? now;

    return await showDatePicker(
      context: context,
      initialDate: selectedInitialDate,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2100),

      // Modern Material calendar
      initialEntryMode: DatePickerEntryMode.calendar,

      // Calendar configuration
      initialDatePickerMode: DatePickerMode.day,

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: mainColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),

            dialogTheme: DialogThemeData(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),

            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,

              // Selected day
              dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                  if (states.contains(WidgetState.selected)) {
                    return mainColor;
                  }
                  return null;
                },
              ),

              dayForegroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.grey.shade400;
                  }
                  return Colors.black87;
                },
              ),

              // Today's date
              todayBackgroundColor:
              WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                  if (states.contains(WidgetState.selected)) {
                    return mainColor;
                  }
                  return mainColor.withValues(alpha: .08);
                },
              ),

              todayForegroundColor:
              WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return mainColor;
                },
              ),

              todayBorder: BorderSide(
                color: mainColor,
                width: 1.2,
              ),

              // Header
              headerBackgroundColor: mainColor,
              headerForegroundColor: Colors.white,

              // Weekday labels
              weekdayStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),

              // Day text
              dayStyle: blackStyle(13, FontWeight.w500),

              // Month/year
              yearStyle: blackStyle(13, FontWeight.w600),

              // Shape of selected date
              dayShape: WidgetStateProperty.all(
                const CircleBorder(),
              ),

              // Header shape
              headerHeadlineStyle: blackStyle(20, FontWeight.w700),

              // Buttons
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
              ),

              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: mainColor,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
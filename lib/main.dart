import 'dart:async';
import 'package:cresentshieldinsurance/view/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// ✅ Supabase init
  await Supabase.initialize(
    url: 'https://xvthbqfvvjhndkvuyrgd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2dGhicWZ2dmpobmRrdnV5cmdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODcwMjQ4NDcsImV4cCI6MjEwMjYwMDg0N30.KBNoS0_Q7Wbm03-H0-CdyWQw0R-pH80a2rU3igX2lQ8',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String? _certificateIdFromUrl() {
    final segments = Uri.base.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList();

    // GitHub Pages serves this project beneath its repository-name path.
    if (segments.isNotEmpty && segments.first == 'crescentshieldinsurance') {
      segments.removeAt(0);
    }

    return segments.isEmpty ? null : segments.last;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Crescent Shield Insurance',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: SitePalette.light.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: SitePalette.light.brand,
          brightness: Brightness.light,
          surface: SitePalette.light.surface,
        ),
        textTheme: GoogleFonts.manropeTextTheme(),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: SitePalette.dark.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: SitePalette.dark.brand,
          brightness: Brightness.dark,
          surface: SitePalette.dark.surface,
        ),
        textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: DashboardPage(certificateId: _certificateIdFromUrl()),
    );
  }
}

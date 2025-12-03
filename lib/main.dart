// ============================================================================
// COMPLETE FLUTTER YOGA HOME SCREEN APPLICATION
// ============================================================================

// ============================================================================
// FILE: pubspec.yaml
// ============================================================================
/*
name: yoga_home
description: A Yoga Home Screen Flutter application
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  google_fonts: ^6.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
*/

// ============================================================================
// FILE: lib/main.dart
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'screens/home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled1/screens/home_screen.dart';

void main() {
  runApp(const YogaApp());
}

class YogaApp extends StatelessWidget {
  const YogaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoga Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomeScreen(),
    );
  }
}

// ============================================================================
// FILE: lib/models/home_response.dart
// ============================================================================


// ============================================================================
// FILE: lib/services/api_service.dart
// ============================================================================


// ============================================================================
// FILE: lib/screens/home_screen.dart
// ============================================================================


// ============================================================================
// FILE: lib/widgets/header_section.dart
// ============================================================================


// ============================================================================
// FILE: lib/widgets/continue_watching_carousel.dart
// ============================================================================


// ============================================================================
// FILE: lib/widgets/yoga_category_grid.dart
// ============================================================================


// ============================================================================
// FILE: lib/widgets/popular_videos_list.dart
// ============================================================================


// ============================================================================
// FILE: lib/widgets/bottom_nav_bar.dart
// ============================================================================

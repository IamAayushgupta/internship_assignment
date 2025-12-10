// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/screens/onboarding_flow.dart';
import 'package:untitled1/screens/phone_auth.dart';
import 'package:untitled1/screens/register_screen.dart';

// screens (adjust paths if your files are located elsewhere)
import 'package:untitled1/screens/splash_screen.dart';
//import 'package:untitled1/screens/onboarding_screen.dart';
import 'package:untitled1/screens/login_options_screen.dart';
//import 'package:untitled1/screens/login_screen.dart';
//import 'package:untitled1/screens/signup_screen.dart';
import 'package:untitled1/screens/home_screen.dart';
import 'package:untitled1/test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const YogaApp());
}

class YogaApp extends StatelessWidget {
  const YogaApp({Key? key}) : super(key: key);

  // centralize route names so you won't use raw strings throughout app
  static const routeSplash = '/splash';
  static const routeOnboarding = '/onboarding';
  static const routeLoginOptions = '/login-options';
  static const routeLogin = '/login';
  static const routeSignup = '/signup';
  static const routeHome = '/home';

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

      // start with splash which will decide where to navigate next
      initialRoute: routeSplash,

      // named routes map
      routes: {
        routeSplash: (context) => const SplashScreen(),
        '/testvideo': (context) => const VideoPlayerScreen(),
       // routeOnboarding: (context) => const OnboardingScreen(),
        routeLoginOptions: (context) => const LoginOptionsScreen(),
       // routeLogin: (context) => const LoginScreen(),
       // routeSignup: (context) => const SignupScreen(),
        routeHome: (context) => const HomeScreen(),
        '/phone-auth': (c) => const PhoneAuthScreen(),
        '/signup': (c) => const RegisterScreen(),
        '/onboarding': (c) => const OnboardingFlow(),
      },

      // fallback route
      onUnknownRoute: (settings) => MaterialPageRoute(builder: (_) =>
      const
      SplashScreen()
          //HomeScreen()
      ),
    );
  }
}

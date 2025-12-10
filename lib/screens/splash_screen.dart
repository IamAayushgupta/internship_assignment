import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Show splash for 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login-options');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/Playoga_Logo.jpg', // ✅ your single splash image
          //fit: BoxFit.fill, // ✅ covers full screen
        ),
      ),
    );
  }
}




















// import 'dart:async';
// import 'package:flutter/material.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//
//     // Show splash screen for 3 seconds
//     Timer(const Duration(seconds: 3), () {
//       Navigator.pushReplacementNamed(context, '/login-options');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       // Rounded corner effect (your screenshot has it)
//       body: ClipRRect(
//         borderRadius: BorderRadius.circular(30),
//         child: Stack(
//           children: [
//             // RIGHT SIDE CURVE IMAGE
//             Positioned(
//               right: -60,
//               top: 120,
//               child: Image.asset(
//                 'assets/images/curve_right.png',
//                 width: 260,
//                 height: 260,
//                 fit: BoxFit.cover,
//               ),
//             ),
//
//             // BOTTOM CURVES
//             Positioned(
//               bottom: 120,
//               left: -10,
//               child: Image.asset(
//                 'assets/images/curve_bottom.png',
//                 width: 260,
//                 height: 260,
//                 fit: BoxFit.cover,
//               ),
//             ),
//
//             // CENTER LOGO
//             Positioned(
//               top: MediaQuery.sizeOf(context).height*0.3,
//               left: MediaQuery.sizeOf(context).height*0.07,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/playoga_logo.png',
//                     //width: 260,
//                     fit: BoxFit.contain,
//                   ),
//                   const SizedBox(height: 10),
//                 ],
//               ),
//             ),
//
//             // // SMALL PURPLE DOT (bottom middle)
//             // Positioned(
//             //   bottom: 40,
//             //   left: 0,
//             //   right: 0,
//             //   child: Center(
//             //     child: Container(
//             //       width: 10,
//             //       height: 10,
//             //       decoration: const BoxDecoration(
//             //         color: Color(0xFF6C63FF),
//             //         shape: BoxShape.circle,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

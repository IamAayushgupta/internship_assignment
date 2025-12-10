// import 'package:flutter/material.dart';
// import 'ClassesPage.dart';
//
// class ClassDetailsPage extends StatelessWidget {
//   final ClassItem item;
//
//   const ClassDetailsPage({Key? key, required this.item}) : super(key: key);
//
//   String get _sampleDescription =>
//       'Crea augueod odio id porro tincidunt ut. Mauris non felis facilisis, bibendum nibh et, arcu. Sed bibendum, ante quis laoreet. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;';
//
//   @override
//   Widget build(BuildContext context) {
//     const Color purple = Color(0xFF6C63FF);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Top image + overlays
//             SizedBox(
//               height: 240,
//               width: double.infinity,
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   // HERO IMAGE (bottom layer)
//                   Hero(
//                     tag: 'class-image-${item.id}',
//                     child: Image.network(
//                       item.imageUrl,
//                       fit: BoxFit.cover,
//                       errorBuilder: (c, e, st) {
//                         return Container(
//                           color: Colors.grey[200],
//                           child: const Icon(Icons.image, color: Colors.grey, size: 64),
//                         );
//                       },
//                     ),
//                   ),
//
//                   // subtle dark gradient so overlay image contrasts
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [Colors.transparent, Colors.black.withOpacity(0.12)],
//                       ),
//                     ),
//                   ),
//
//                   // bottom-left rating pill (above image)
//                   Positioned(
//                     left: 12,
//                     bottom: 12,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.55),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Row(
//                         children: const [
//                           Icon(Icons.star, color: Colors.yellow, size: 16),
//                           SizedBox(width: 6),
//                           Text('4.8 (560)', style: TextStyle(color: Colors.white, fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // top-left back button
//                   Positioned(
//                     left: 8,
//                     top: 8,
//                     child: Material(
//                       color: Colors.white.withOpacity(0.9),
//                       shape: const CircleBorder(),
//                       child: IconButton(
//                         icon: const Icon(Icons.arrow_back),
//                         onPressed: () => Navigator.of(context).pop(),
//                       ),
//                     ),
//                   ),
//
//                   // top-right notification button
//                   Positioned(
//                     right: 8,
//                     top: 8,
//                     child: Material(
//                       color: Colors.white.withOpacity(0.9),
//                       shape: const CircleBorder(),
//                       child: IconButton(
//                         icon: const Icon(Icons.notifications_outlined),
//                         onPressed: () {},
//                       ),
//                     ),
//                   ),
//
//                   // --- CENTERED LOCAL IMAGE (on top) ---
//                   // Make sure this asset exists and is listed in pubspec.yaml
//                   Positioned.fill(
//                     left: 100,
//                     top: 100,
//                     child: GestureDetector(
//                       onTap: () {
//                         // Placeholder: open player or perform action
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Play "${item.title}"')),
//                         );
//                       },
//                       child: SizedBox(
//                         width: 84,
//                         height: 84,
//                         // Use Image.asset to show your local image
//                         child: Image.asset(
//                           'assets/images/play_video.jpeg',
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Content area scrollable
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${item.title} Training',
//                       style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         _infoTile('Focus', 'Weight Loss'),
//                         const SizedBox(width: 10),
//                         _infoTile('Specs', '45 min\n900 Kcals'),
//                         const SizedBox(width: 10),
//                         _infoTile('Difficulty', 'Advanced'),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade50,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(_sampleDescription, style: const TextStyle(fontSize: 13, color: Colors.black54)),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text('Benefits', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 12),
//                     _benefitCard(title: '20 Day Tummy Challenge', subtitle: '2 Weeks / 05 Days', rating: 4.8),
//                     const SizedBox(height: 12),
//                     _benefitCard(title: 'Beginner Starter Pack', subtitle: '4 Weeks / 12 Days', rating: 4.6),
//                     const SizedBox(height: 80),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomSheet: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         color: Colors.white,
//         child: Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // start/enroll action
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: const Text('Start Training'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _infoTile(String label, String value) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)), const SizedBox(height: 6), Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))],
//         ),
//       ),
//     );
//   }
//
//   Widget _benefitCard({required String title, required String subtitle, required double rating}) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
//       child: Row(
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(8),
//               image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1517960413843-0aee8e2b9f52?auto=format&fit=crop&w=400&q=60'), fit: BoxFit.cover),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 6), Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54))]),
//           ),
//           const SizedBox(width: 8),
//           Column(children: [const Icon(Icons.star, color: Colors.amber, size: 18), const SizedBox(height: 4), Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w600))])
//         ],
//       ),
//     );
//   }
// }

// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const Color purple = Color(0xFF6C63FF);
  static const double _sidePadding = 18.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          // Use available height to size children more robustly
          final maxHeight = constraints.maxHeight;
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 12), // allow space for bottom nav
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _sidePadding),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      // Top row: back + actions
                      Row(
                        children: [
                          _circleIconButton(
                            icon: Icons.arrow_back,
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          const Spacer(),
                          _circleIconButton(icon: Icons.more_horiz, onPressed: () {}),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Avatar with edit badge (uses local asset)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  //shape: BoxShape.circle,
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/Frame.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text('Jennie Ruby', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text('United States', style: TextStyle(color: Colors.grey[500])),
                            ],
                          ),

                          // edit badge (positioned relative to avatar)
                          Positioned(
                            right: MediaQuery.of(context).size.width / 2 - 96 / 2 - 8,
                            top: 56,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: const Icon(Icons.edit, size: 16, color: purple),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Stats row (weight / height / fat)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _statItem('65', 'kg', 'Weight'),
                            _verticalDivider(),
                            _statItem('175', 'cm', 'Height'),
                            _verticalDivider(),
                            _statItem('20', '%', 'Fat mass'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Segmented Control (Activities / Statistics)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(child: Text('Activities')),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
                                      ),
                                      child: const Center(child: Text('Statistics')),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Statistics card with simple bar visualization
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.local_fire_department, color: Colors.orange),
                                const SizedBox(width: 8),
                                const Text('12,000', style: TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(width: 8),
                                Text('Kcal this week', style: TextStyle(color: Colors.grey.shade600)),
                                const Spacer(),
                                Container(
                                  width: 36,
                                  height: 24,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)
                                  ]),
                                  child: const Icon(Icons.show_chart, size: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Reduced and constrained bar visualization height to avoid overflow
                            SizedBox(
                              height: 72, // reduced from 90 -> 72 to avoid overflow
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _miniBar(0.35, label: 'Sun'),
                                  _miniBar(0.45, label: 'Mon'),
                                  _miniBar(0.2, label: 'Tue'),
                                  _miniBar(0.4, label: 'Wed'),
                                  _miniBar(0.5, label: 'Thu'),
                                  _miniBar(0.6, label: 'Fri'),
                                  _miniBar(0.44, label: 'Sat'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // three small activity cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: _activityCard(icon: Icons.self_improvement, value: '325', label: 'kcal\nFocus')),
                          const SizedBox(width: 10),
                          Expanded(child: _activityCard(icon: Icons.fitness_center, value: '437', label: 'kcal\nHiit')),
                          const SizedBox(width: 10),
                          Expanded(child: _activityCard(icon: Icons.directions_run, value: '680', label: 'kcal\nTreadmill')),
                        ],
                      ),

                      // ensure content does not touch bottom nav
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _circleIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: IconButton(icon: Icon(icon, color: Colors.black87), onPressed: onPressed),
    );
  }

  Widget _statItem(String value, String unit, String label) {
    return Expanded(
      child: Column(
        children: [
          Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(unit, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(width: 1, height: 48, color: Colors.grey.shade200);
  }

  Widget _miniBar(double heightFactor, {required String label}) {
    final barColor = purple;
    // Ensure min height so smallest bars remain visible
    final base = 10.0;
    final barMax = 56.0; // fits inside 72 total with label spacing
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: base + barMax * heightFactor,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _activityCard({required IconData icon, required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: purple, size: 22),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }



}

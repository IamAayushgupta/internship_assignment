import 'package:flutter/material.dart';
import 'package:untitled1/screens/video_player_page.dart';

/// Simple model representing a class item. Replace with API model later.
class ClassItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String weeks;

  ClassItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.weeks,
  });
}

/// Page widget for second bottom-nav index. Uses a fake async fetch now.
/// NOTE: This version shows a details panel as an overlay so bottom nav stays visible.
class ClassesPage extends StatefulWidget {
  const ClassesPage({Key? key}) : super(key: key);

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> with SingleTickerProviderStateMixin {
  late Future<List<ClassItem>> _classesFuture;
  int _selectedFilterIndex = 0;
  final _filters = ['All', 'Beginners', 'Intermediate', 'Advanced'];

  ClassItem? _activeItem; // currently opened overlay item
  late final AnimationController _panelController;

  @override
  void initState() {
    super.initState();
    _classesFuture = _fetchClasses();
    _panelController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _panelController.dispose();
    super.dispose();
  }

  // Replace this with ApiService.fetchClasses(userId) when API is ready.
  Future<List<ClassItem>> _fetchClasses() async {
    await Future.delayed(const Duration(milliseconds: 350)); // simulate network
    return List.generate(8, (i) {
      return ClassItem(
        id: 'c$i',
        title: i % 2 == 0 ? 'Jivamukti' : 'Ashtanga',
        subtitle: '${4 + i % 3} Week Training',
        imageUrl: [
          'https://images.unsplash.com/photo-1517960413843-0aee8e2b9f52?auto=format&fit=crop&w=1200&q=60',
          'https://images.unsplash.com/photo-1543353071-873f17a7a088?auto=format&fit=crop&w=1200&q=60',
          'https://images.unsplash.com/photo-1526406915894-45a02a8f3f3a?auto=format&fit=crop&w=1200&q=60',
          'https://images.unsplash.com/photo-1519744792095-2f2205e87b6f?auto=format&fit=crop&w=1200&q=60'
        ][i % 4],
        weeks: '${4 + i % 3} Week Training',
      );
    });
  }

  void _openOverlay(ClassItem item) {
    setState(() => _activeItem = item);
    _panelController.forward(from: 0);
  }

  void _closeOverlay() {
    _panelController.reverse().then((_) {
      if (mounted) setState(() => _activeItem = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomNavHeight = 84.0; // space so bottomNavigationBar remains visible
    final overlayMaxHeight = screenHeight - bottomNavHeight - 12;

    return SafeArea(
      child: Stack(
        children: [
          // MAIN CONTENT (grid + filters)
          Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Popular Classes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Filter tabs
              SizedBox(
                height: 38,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, idx) {
                    final selected = idx == _selectedFilterIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilterIndex = idx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: selected ? const Color(0xFF6C63FF) : Colors.transparent,
                          border: Border.all(
                            color: selected ? Colors.transparent : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _filters[idx],
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black87,
                              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: _filters.length,
                ),
              ),

              const SizedBox(height: 12),

              // Content Grid
              Expanded(
                child: FutureBuilder<List<ClassItem>>(
                  future: _classesFuture,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 36),
                            const SizedBox(height: 8),
                            Text('Failed to load classes: ${snap.error}'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => setState(() => _classesFuture = _fetchClasses()),
                              child: const Text('Retry'),
                            )
                          ],
                        ),
                      );
                    }

                    final items = snap.data ?? [];

                    // Simple local filter for demo
                    final filtered = _selectedFilterIndex == 0
                        ? items
                        : items.where((c) {
                      final f = _filters[_selectedFilterIndex].toLowerCase();
                      return c.title.toLowerCase().contains(f);
                    }).toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GridView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final cls = filtered[i];
                          return _ClassCard(
                            item: cls,
                            onTap: _openOverlay,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // OVERLAY: appears above content; bottom nav remains visible
          if (_activeItem != null) ...[
            // Backdrop - blurred dark
            GestureDetector(
              onTap: _closeOverlay,
              child: FadeTransition(
                opacity: CurvedAnimation(parent: _panelController, curve: Curves.easeInOut),
                child: Container(color: Colors.black45),
              ),
            ),

            // Sliding panel positioned to leave space for bottom nav
            AnimatedBuilder(
              animation: _panelController,
              builder: (context, child) {
                final v = Curves.easeOut.transform(_panelController.value);
                final top = (screenHeight - overlayMaxHeight) * (1 - v);
                return Positioned(left: 0, right: 0, top: top, height: overlayMaxHeight, child: child!);
              },
              child: Material(
                elevation: 14,
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                clipBehavior: Clip.hardEdge,
                child: _OverlayDetails(
                  item: _activeItem!,
                  onClose: _closeOverlay,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Card used in the grid. Calls onTap with the item so the parent can open overlay.
class _ClassCard extends StatelessWidget {
  final ClassItem item;
  final void Function(ClassItem) onTap;

  const _ClassCard({Key? key, required this.item, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 6)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'class-image-${item.id}',
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, st) => Container(color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey, size: 42)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
                    child: Text(item.weeks, style: TextStyle(color: Colors.black87.withOpacity(0.9), fontSize: 12)),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// The details panel displayed as overlay. Styling tuned to match provided screenshot.
/// The details panel displayed as overlay. 100% replaceable.
class _OverlayDetails extends StatelessWidget {
  final ClassItem item;
  final VoidCallback onClose;

  const _OverlayDetails({Key? key, required this.item, required this.onClose})
      : super(key: key);

  String get _sampleDescription =>
      'Crea augueod odio id porro tincidunt ut. Mauris non felis facilisis, '
          'bibendum nibh et, arcu. Sed bibendum, ante quis laoreet. Vestibulum '
          'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top image area with play button
        Stack(
          children: [
            // HERO IMAGE
            // IMAGE (no Hero) — prevents duplicate hero tag error inside same route
            SizedBox(
              height: 260,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.zero,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  },
                  errorBuilder: (c, e, st) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image, size: 48)),
                  ),
                ),
              ),
            ),


            // gradient overlay
            Container(
              height: 260,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.25)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // TOP LEFT BACK BUTTON
            Positioned(
              left: 10,
              top: 10,
              child: Material(
                color: Colors.white.withOpacity(0.85),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onClose,
                ),
              ),
            ),

            // BOTTOM LEFT INFO PILL
            Positioned(
              left: 12,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Text('Fat Burning',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(width: 8),
                    Text('02 Min 16 Sec',
                        style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ),
            ),

            // BOTTOM RIGHT RATING PILL
            Positioned(
              right: 12,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 6),
                    Text('4.9',
                        style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),

            // ✅ CENTER PLAY BUTTON — always on top
            Positioned.fill(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => VideoPlayerPage(
                        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                        title: 'Total body refresh flow',
                        stepText: 'Step 4/5: Lotus Pose',
                        stepDuration: 300,
                      ),
                    ));

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text('Play ${item.title}')),
                    // );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // =======================
        // CONTENT BELOW IMAGE
        // =======================

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text('${item.title} Yoga Training',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),

                // 3 Information boxes
                Row(
                  children: [
                    _smallInfoBox('Focus', 'Weight Loss'),
                    const SizedBox(width: 10),
                    _smallInfoBox('Specs', '45 min\n900 Kcals'),
                    const SizedBox(width: 10),
                    _smallInfoBox('Difficulty', 'Advanced'),
                  ],
                ),

                const SizedBox(height: 12),

                // Description
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8)
                    ],
                  ),
                  child: Text(_sampleDescription,
                      style:
                      const TextStyle(fontSize: 13, color: Colors.black54)),
                ),

                const SizedBox(height: 16),

                // Benefits header
                const Text('Benefits',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),

                _benefitTile('20 Day Tummy Challenge', '2 Weeks / 05 Days', 4.8),
                const SizedBox(height: 12),
                _benefitTile('Beginner Starter Pack', '4 Weeks / 12 Days', 4.6),

                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------
  // COMPONENTS
  // -------------------------------------------

  Widget _smallInfoBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02), blurRadius: 4)
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(value,
              style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _benefitTile(String title, String subtitle, double rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1517960413843-0aee8e2b9f52?auto=format&fit=crop&w=400&q=60'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style:
                    const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(height: 4),
              Text(rating.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}


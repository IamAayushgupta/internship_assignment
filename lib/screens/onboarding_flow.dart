// lib/screens/onboarding_flow.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pc = PageController();
  int _page = 0;

  // user selections
  String? _goal; // 'lose', 'fitter', 'muscle'
  int? _age;
  String? _gender; // 'male' or 'female'

  final Color purple = const Color(0xFF6C63FF);

  void _goTo(int idx) {
    setState(() => _page = idx);
    _pc.animateToPage(idx, duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
  }

  void _nextStep() {
    if (_page < 2) {
      // simple validation for middle screen
      if (_page == 1 && (_age == null || _age! < 1 || _age! > 120)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid age')));
        return;
      }
      _goTo(_page + 1);
    } else {
      // completed all steps - navigate to home (change as needed)
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _back() {
    if (_page == 0) {
      Navigator.maybePop(context);
    } else {
      _goTo(_page - 1);
    }
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pc,
              physics: const NeverScrollableScrollPhysics(), // we control navigation
              children: [
                GoalStep(
                  selected: _goal,
                  onSelect: (g) => setState(() => _goal = g),
                ),
                AgeStep(
                  age: _age,
                  onChanged: (val) => setState(() => _age = val),
                ),
                GenderStep(
                  selected: _gender,
                  onSelect: (g) => setState(() => _gender = g),
                ),
              ],
            ),

            // top-left back button
            Positioned(
              left: 12,
              top: 12,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 0,
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _back,
                ),
              ),
            ),

            // top center progress dots
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: ProgressDots(current: _page, accent: purple),
              ),
            ),

            // Step text below dots
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Text('Step ${_page + 1} of 3',
                    style: TextStyle(color: purple, fontWeight: FontWeight.w600)),
              ),
            ),

            // Next Step button at bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: device.padding.bottom + 20,
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _page < 2 ? 'Next Step' : 'Finish',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Top progress dots widget (3 dots + active indicator as in screenshot)
class ProgressDots extends StatelessWidget {
  final int current;
  final Color accent;
  const ProgressDots({Key? key, required this.current, required this.accent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We'll draw three small rounded rectangles to match the screenshot
    Widget dot(bool active) => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 36 : 22,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: active ? accent : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dot(current == 0),
        dot(current == 1),
        dot(current == 2),
      ],
    );
  }
}

/// ---------- STEP 1: Goal selection ----------
class GoalStep extends StatelessWidget {
  final String? selected;
  final void Function(String) onSelect;

  const GoalStep({Key? key, required this.selected, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color purple = const Color(0xFF6C63FF);

    Widget card(String id, String title, String subtitle, Widget trailing) {
      final bool isSelected = selected == id;
      return GestureDetector(
        onTap: () => onSelect(id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: purple, width: 2) : Border.all(color: Colors.grey.shade400),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? purple : Colors.black87)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ]),
              ),
              trailing,
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 110, 18, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 6),
          Text('What is your goal?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87)),
          const SizedBox(height: 30),

          // list of three cards
          Column(
            children: [
              card('lose', 'Lose weight', 'Burn fat and get lean', const Icon(Icons.local_fire_department, color: Colors.orange)),
              const SizedBox(height: 30),
              card('fitter', 'Get fitter', 'Tone up and feel healthy', Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFFFF5E6), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.star, color: Colors.amber),
              )),
              const SizedBox(height: 30),
              card('muscle', 'Gain muscle', 'Build mass and strength', Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFFFF5F6), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.fitness_center, color: Colors.redAccent),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

/// ---------- STEP 2: Age input ----------
class AgeStep extends StatefulWidget {
  final int? age;
  final void Function(int) onChanged;
  const AgeStep({Key? key, required this.age, required this.onChanged}) : super(key: key);

  @override
  State<AgeStep> createState() => _AgeStepState();
}

class _AgeStepState extends State<AgeStep> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.age?.toString() ?? '');
  }

  @override
  void didUpdateWidget(covariant AgeStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.age != widget.age) {
      _ctrl.text = widget.age?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    final cleaned = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) {
      widget.onChanged(0);
      return;
    }
    final n = int.tryParse(cleaned) ?? 0;
    // clamp typical human values
    final valid = n.clamp(0, 120);
    widget.onChanged(valid);
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFF6C63FF);

    return GestureDetector(
      onTap: () {
        // focus the invisible field to bring up keyboard
        FocusScope.of(context).unfocus();
        Future.delayed(const Duration(milliseconds: 100), () => FocusScope.of(context).requestFocus(_textFocus));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 120, 18, 140),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Text('How old are you?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 36),

            // big number display
            Expanded(
              child: Center(
                child: Text(
                  (widget.age ?? 0) > 0 ? '${widget.age}' : '0',
                  style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
              ),
            ),

            // invisible TextField to trigger numeric keyboard and capture input
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: 0,
                width: 0,
                child: TextField(
                  focusNode: _textFocus,
                  controller: _ctrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) {
                    _onChanged(v);
                    setState(() {});
                  },
                ),
              ),
            ),

            // hint note
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // focus to show numeric keyboard if needed
                  FocusScope.of(context).requestFocus(_textFocus);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Tap here and enter your age using the numeric keypad', style: TextStyle(color: Colors.black54)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final FocusNode _textFocus = FocusNode();
}

/// ---------- STEP 3: Gender selection ----------
class GenderStep extends StatelessWidget {
  final String? selected;
  final void Function(String) onSelect;
  const GenderStep({Key? key, required this.selected, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFF6C63FF);

    Widget choice(String id, String label, Widget icon) {
      final bool isSelected = selected == id;
      return GestureDetector(
        onTap: () => onSelect(id),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? purple.withOpacity(0.12) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSelected ? purple : Colors.grey.shade200, width: isSelected ? 2 : 1),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
              ),
              child: icon,
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? purple : Colors.black87)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 200, 18, 140),
      child: Column(
        children: [
          const SizedBox(height: 6),
          Text('What is your gender', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              choice(
                'male',
                'Male',
                const Icon(Icons.male, size: 56, color: Colors.brown),
              ),
              choice(
                'female',
                'Female',
                const Icon(Icons.female, size: 56, color: Colors.deepOrangeAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

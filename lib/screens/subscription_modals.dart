// lib/screens/subscription_modals.dart
import 'dart:async';
import 'package:flutter/material.dart';

/// ---------------------------
/// Fake ApiService (replace with your real API)
/// ---------------------------
class ApiService1 {
  /// Simulate network call to check subscription status
  static Future<bool> isUserSubscribed() async {
    await Future.delayed(const Duration(milliseconds: 400));
    // return true if subscribed; false if not.
    // Change to `true` for testing the "subscribed" path.
    return false;
  }

  /// Simulate calling subscribe endpoint
  static Future<bool> subscribe({required String planId}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // return true on success
    return true;
  }
}

/// ---------------------------
/// Subscription Offer Modal (left design)
/// ---------------------------
class SubscriptionOfferModal extends StatefulWidget {
  const SubscriptionOfferModal({Key? key}) : super(key: key);

  @override
  State<SubscriptionOfferModal> createState() => _SubscriptionOfferModalState();
}

class _SubscriptionOfferModalState extends State<SubscriptionOfferModal> {
  String _selectedPlan = 'yearly'; // 'yearly' or 'monthly'
  bool _isLoading = false;
  bool _showFeatures = false;

  void _selectPlan(String plan) => setState(() => _selectedPlan = plan);

  Future<void> _subscribe() async {
    setState(() => _isLoading = true);
    final success = await ApiService1.subscribe(planId: _selectedPlan);
    setState(() => _isLoading = false);

    if (success) {
      // close modal and optionally refresh user state in caller
      if (mounted) Navigator.of(context).pop(true);
    } else {
      // show error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subscription failed. Try again.')));
    }
  }

  Widget _planTile({
    required String id,
    required String title,
    required String subtitle,
    required String price,
  }) {
    final selected = _selectedPlan == id;
    return GestureDetector(
      onTap: () => _selectPlan(id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? const Color(0xFF6C63FF) : Colors.grey.shade300, width: selected ? 1.6 : 1.0),
          boxShadow: selected ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)] : null,
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? const Color(0xFF6C63FF) : Colors.transparent,
                border: Border.all(color: selected ? Colors.transparent : Colors.grey.shade400),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ]),
            ),
            const SizedBox(width: 12),
            Text(price, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF6C63FF))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // modal style: rounded top and space for bottom nav (if exists)
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0), // top spacing so rounded top looks correct
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Material(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // top drag indicator and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4))),
                      IconButton(onPressed: () => Navigator.of(context).pop(false), icon: const Icon(Icons.close)),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // art / illustration placeholder
                  SizedBox(
                    height: 140,
                    child: Center(
                      child: Image.asset('assets/images/sub_illustration.png', width: 160, fit: BoxFit.contain),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // title and subtitle
                  Text('Upgrade to Add Letter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87)),
                  const SizedBox(height: 6),
                  Text('Subscribe and Read\nUnlimited Newsletters', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),

                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => setState(() => _showFeatures = !_showFeatures),
                    child: Text('+8 features', style: TextStyle(color: const Color(0xFF6C63FF), fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 16),

                  // Plan options
                  _planTile(id: 'yearly', title: 'Yearly Plan', subtitle: 'Billed Annually', price: '\$19'),
                  const SizedBox(height: 12),
                  _planTile(id: 'monthly', title: 'Monthly Plan', subtitle: 'Billed Monthly', price: '\$1.99'),
                  const SizedBox(height: 16),

                  // fine print
                  Text('Recurring Billing. Cancel Anytime', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),

                  const SizedBox(height: 16),

                  // Subscribe button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _subscribe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Subscribe Now', style: TextStyle(fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // bottom links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: () {}, child: const Text('Restore Purchase', style: TextStyle(fontSize: 12))),
                      TextButton(onPressed: () {}, child: const Text('Terms of Use', style: TextStyle(fontSize: 12))),
                      TextButton(onPressed: () {}, child: const Text('Privacy Policy', style: TextStyle(fontSize: 12))),
                    ],
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------------------
/// Subscription Features Modal (right design)
/// ---------------------------
class SubscriptionFeaturesModal extends StatelessWidget {
  const SubscriptionFeaturesModal({Key? key}) : super(key: key);

  Widget _featureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF6C63FF)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          child: Material(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // drag & close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4))),
                      IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // logo circle
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                    child: const Center(child: Icon(Icons.mail_outline, color: Color(0xFF2F6CE5), size: 36)),
                  ),

                  const SizedBox(height: 12),
                  const Text('Get Add Letter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('Access unlimited newsletters with powerful premium features', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),

                  const SizedBox(height: 14),

                  // white card with feature list
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _featureRow('Add Unlimited Newsletters to Feed'),
                        _featureRow('Save Unlimited Newsletter Editions'),
                        _featureRow('View 20 Past Editions'),
                        _featureRow('Read Anywhere with Offline Access'),
                        _featureRow('Convert upto 30 Newsletters to Podcast every Month'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // You can call subscribe here too
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F6CE5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Upgrade to Plus', style: TextStyle(fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text('Auto-renews for \$1.99/month until canceled', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------------------
/// How to use (helpers)
/// ---------------------------

/// Show the subscription offer modal only if user is not subscribed.
/// This is the helper you can call from anywhere (for example after app startup).
Future<void> showSubscriptionIfNeeded(BuildContext context) async {
  final isSubscribed = await ApiService1.isUserSubscribed();
  if (!isSubscribed) {
    // show the main offer modal
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SubscriptionOfferModal(),
    );

    // `result == true` when subscription succeeded (ApiService.subscribe returned true)
    if (result == true) {
      // user subscribed — update app state (refresh UI / user profile etc.)
      debugPrint('User subscribed successfully.');
    }
  } else {
    debugPrint('User already subscribed — do nothing.');
  }
}

/// Direct helpers to open the modals individually from anywhere:
Future<void> openSubscriptionOffer(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const SubscriptionOfferModal(),
  );
}

Future<void> openSubscriptionFeatures(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const SubscriptionFeaturesModal(),
  );
}

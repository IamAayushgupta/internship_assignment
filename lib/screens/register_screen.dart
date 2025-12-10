// lib/screens/register_screen.dart
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agree = false;
  bool _loading = false;

  final Color _primaryPurple = const Color(0xFF6C63FF);

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter phone number';
    final cleaned = v.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^[0-9]{6,15}$').hasMatch(cleaned)) return 'Enter a valid phone number';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter password';
    if (v.length < 8) return 'Use at least 8 characters';
    return null;
  }

  void _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to Terms and condition')));
      return;
    }
    if (_passwordCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _loading = true);

    // TODO: call your signup API here. For now simulate delay.
    await Future.delayed(const Duration(milliseconds: 900));

    setState(() => _loading = false);

    // navigate to next screen or show success
    Navigator.pushNamed(context, '/onboarding');
   // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registered (mock)')));
    // Navigator.pushReplacementNamed(context, '/home'); // uncomment when ready
  }

  @override
  Widget build(BuildContext context) {
    // phone field looks like example: spaced number. We'll not format automatically — keep simple.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 28),

                    // Title (left aligned)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Register\nNew Account',
                        style: TextStyle(
                          fontSize: 34,
                          height: 1.02,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Phone number
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Phone number', style: TextStyle(color: Colors.black, fontSize: 13)),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      validator: _validatePhone,
                      decoration: InputDecoration(
                        hintText: 'Enter Mobile Number',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primaryPurple.withOpacity(0.8))),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Create password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Create password', style: TextStyle(color: Colors.black, fontSize: 13)),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primaryPurple.withOpacity(0.8))),
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                          child: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Confirm password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Confirm password', style: TextStyle(color: Colors.black, fontSize: 13)),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _obscureConfirm,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter Password Again',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primaryPurple.withOpacity(0.8))),
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          child: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Terms row
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _agree = !_agree),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _agree ? _primaryPurple : Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: _agree ? _primaryPurple : Colors.grey.shade300),
                            ),
                            child: _agree
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to ',
                              style: TextStyle(color: Colors.black54),
                              children: [
                                TextSpan(text: 'Terms and condition', style: TextStyle(color: _primaryPurple, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _onRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: _loading
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 28),
                    // Add spacing so layout matches screenshot
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

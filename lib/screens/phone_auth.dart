import 'dart:async';
import 'package:flutter/material.dart';

/// Phone Auth flow:
/// 1) PhoneAuthScreen -> enter number -> "Send OTP"
/// 2) OtpVerifyScreen -> enter 6-digit OTP -> Verify (mock)
///
/// Replace the _mockSendOtp / _mockVerifyOtp with your API calls.

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Replace this with your API call to send OTP
  Future<bool> _mockSendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // return true for success
    return true;
  }

  void _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final ok = await _mockSendOtp(phone);
      if (!mounted) return;
      setState(() => _loading = false);
      if (ok) {
        // Navigate to OTP screen and pass phone number
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OtpVerifyScreen(phoneNumber: phone)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP. Try again.')),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter phone number';
    final cleaned = v.replaceAll(RegExp(r'\s+'), '');
    // A very simple check - adapt to your country/format
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(cleaned)) return 'Enter valid phone number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFF6C63FF);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black87),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Continue with Mobile',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Enter your mobile number to receive an OTP', style: TextStyle(color: Colors.black54)),
              ),
              const SizedBox(height: 22),

              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    prefixText: '+91 ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  ),
                  validator: _validatePhone,
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Send OTP', style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  // If the user doesn't have an account, take them to register
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// OTP verification screen with 6 single-digit fields, timer, resend.
class OtpVerifyScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerifyScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> _digitControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _digitNodes = List.generate(6, (_) => FocusNode());
  bool _verifying = false;
  bool _resendEnabled = false;
  Timer? _timer;
  int _secondsLeft = 30; // countdown before Resend enabled

  @override
  void initState() {
    super.initState();
    _startTimer();
    // auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) => _digitNodes[0].requestFocus());
  }

  @override
  void dispose() {
    for (final c in _digitControllers) c.dispose();
    for (final n in _digitNodes) n.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = 30;
      _resendEnabled = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          _resendEnabled = true;
          _timer?.cancel();
        }
      });
    });
  }

  String _collectOtp() => _digitControllers.map((c) => c.text.trim()).join();

  Future<bool> _mockVerifyOtp(String otp) async {
    await Future.delayed(const Duration(milliseconds: 700));
    // For demo accept '111111' as success or any 6-digit value -> return true
    return otp.length == 6;
  }

  Future<void> _verifyOtp() async {
    final otp = _collectOtp();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter 6 digit code')));
      return;
    }

    setState(() => _verifying = true);
    final ok = await _mockVerifyOtp(otp);
    if (!mounted) return;
    setState(() => _verifying = false);

    if (ok) {
      // Verified successfully
      // Decide where to go next: signup or home.
      // Here we simply push replacement to home. If you need registration
      // logic, route to '/signup' and pass phone as arg.
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP. Try again.')));
    }
  }

  Future<void> _resendOtp() async {
    if (!_resendEnabled) return;
    // call resend API (mock here)
    setState(() => _resendEnabled = false);
    // simulate network
    await Future.delayed(const Duration(milliseconds: 700));
    // restart timer
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP resent')));
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 42,
      child: TextField(
        controller: _digitControllers[index],
        focusNode: _digitNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        decoration: InputDecoration(counterText: '', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        onChanged: (v) {
          if (v.isEmpty) {
            // move back if empty
            if (index > 0) _digitNodes[index - 1].requestFocus();
          } else {
            // move to next
            if (index < _digitNodes.length - 1) {
              _digitNodes[index + 1].requestFocus();
            } else {
              // last field - optionally verify automatically
              _digitNodes[index].unfocus();
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xFF6C63FF);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black87),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerLeft, child: Text('Verify phone', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87))),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerLeft, child: Text('We sent an OTP to your phone', style: TextStyle(color: Colors.black54))),
              const SizedBox(height: 14),
              Align(alignment: Alignment.centerLeft, child: Text(widget.phoneNumber, style: const TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(height: 18),

              // OTP fields row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, _buildOtpField),
              ),

              const SizedBox(height: 18),

              // Verify button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifying ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _verifying ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Verify', style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 12),

              // Resend / countdown row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_resendEnabled ? 'Didn\'t receive the code?' : 'Resend available in $_secondsLeft s', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _resendEnabled ? _resendOtp : null,
                    child: Text('Resend', style: TextStyle(color: _resendEnabled ? purple : Colors.black26)),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Option to edit phone
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // go back to phone entry
                },
                child: const Text('Change number', style: TextStyle(color: Colors.black54)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

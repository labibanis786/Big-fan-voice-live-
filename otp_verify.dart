import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String verificationId;
  const OtpVerifyScreen({required this.verificationId, super.key});
  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController codeController = TextEditingController();
  bool loading = false;

  void verify() async {
    final code = codeController.text.trim();
    if (code.isEmpty) return;
    setState(() => loading = true);
    try {
      final fs = Provider.of<FirebaseService>(context, listen: false);
      await fs.signInWithSms(widget.verificationId, code);
      setState(() => loading = false);
      // user auto-navigated by auth state change in main.dart
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: codeController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'SMS code')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: loading ? null : verify, child: loading ? const CircularProgressIndicator() : const Text('Verify')),
          ],
        ),
      ),
    );
  }
}

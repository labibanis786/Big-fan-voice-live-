import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import 'otp_verify.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController(text: "+880");
  bool loading = false;

  void sendCode() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return;
    setState(() => loading = true);
    final fs = Provider.of<FirebaseService>(context, listen: false);
    try {
      await fs.verifyPhone(phone, codeSent: (verificationId, resendToken) {
        setState(() => loading = false);
        Navigator.push(context, MaterialPageRoute(builder: (_) => OtpVerifyScreen(verificationId: verificationId)));
      }, onError: (e) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error sending code: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - Phone OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone number')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : sendCode,
              child: loading ? const CircularProgressIndicator() : const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

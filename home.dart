import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import 'rooms.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final fs = Provider.of<FirebaseService>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          ListTile(title: Text('Logged in: ${fs.currentUser?.phoneNumber ?? 'unknown'}')),
          ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoomsScreen())), child: const Text('Join Voice Rooms')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () {
            // placeholder gift sending UI
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open Gifts (implemented in Firestore)')));
          }, child: const Text('Gifts')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => fs.signOut(), child: const Text('Sign out')),
        ],
      ),
    );
  }
}

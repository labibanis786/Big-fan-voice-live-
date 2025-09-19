import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> createUserIfNotExists(User user) async {
    final doc = _db.collection('users').doc(user.uid);
    final snap = await doc.get();
    if (!snap.exists) {
      await doc.set({
        'uid': user.uid,
        'phone': user.phoneNumber ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'coins': 100, // starter coins
        'displayName': user.phoneNumber ?? 'User',
      });
    }
  }

  Future<void> signOut() => _auth.signOut();

  // Gift send example: deduct sender coins, add gift doc, add to recipient balance
  Future<void> sendGift(String senderUid, String recipientUid, String giftId, int cost) async {
    final senderRef = _db.collection('users').doc(senderUid);
    final recipientRef = _db.collection('users').doc(recipientUid);
    final giftRef = _db.collection('gifts').doc();

    return _db.runTransaction((tx) async {
      final sSnap = await tx.get(senderRef);
      final rSnap = await tx.get(recipientRef);
      final sCoins = (sSnap.data()?['coins'] ?? 0) as int;
      if (sCoins < cost) throw Exception('Not enough coins');
      tx.update(senderRef, {'coins': sCoins - cost});
      tx.update(recipientRef, {'coins': (rSnap.data()?['coins'] ?? 0) as int + cost});
      tx.set(giftRef, {
        'from': senderUid,
        'to': recipientUid,
        'giftId': giftId,
        'cost': cost,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // Phone auth helpers
  Future<void> verifyPhone(String phone, {required Function(String verificationId, int? resendToken) codeSent, required Function(FirebaseAuthException) onError}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        // On Android this can be called automatically.
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) => onError(e),
      codeSent: (verificationId, resendToken) => codeSent(verificationId, resendToken),
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<void> signInWithSms(String verificationId, String smsCode) async {
    final cred = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    final result = await _auth.signInWithCredential(cred);
    if (result.user != null) {
      await createUserIfNotExists(result.user!);
    }
  }
}

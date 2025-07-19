import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Step 1: Register with email & password
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Registration error: ${e.message}');
      rethrow;
    }
  }

  /// ✅ Step 2: Update user profile in Firestore after registration
  Future<void> updateUserProfile(Map<String, dynamic> profileData) async {
    final user = _auth.currentUser;
    if (user == null)
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No logged-in user found.',
      );

    await _firestore.collection('users').doc(user.uid).set({
      ...profileData,
      'email': user.email,
      'uid': user.uid,
      'name': profileData['name'] ?? '',
      'dob': profileData['dob'] ?? '',
      'city': profileData['city'] ?? '',
      'phone': profileData['phone'] ?? '',
      'gender': profileData['gender'] ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// ✅ Login (with email verification check)
  Future<User?> loginWithEmail(String email, String password) async {
    final uc = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = uc.user!;
    if (!user.emailVerified) {
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email before logging in.',
      );
    }
    return user;
  }

  /// ✅ Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// ✅ Google Sign-In
  /*Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut(); // Show full account picker
    } catch (_) {}

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final uc = await _auth.signInWithCredential(credential);
    final user = uc.user!;
    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'uid': user.uid,
      });
    }

    return user;
  }

  /// ✅ Facebook Sign-In
  Future<User?> signInWithFacebook() async {
    final result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success) return null;

   // final token = result.accessToken!.token;
    //final credential = FacebookAuthProvider.credential(token);
    final uc = await _auth.signInWithCredential(credential);
    final user = uc.user!;
    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'uid': user.uid,
      });
    }

    return user;
  }

  /// ✅ Logout
  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }*/

  /// ✅ Get current user
  User? get currentUser => _auth.currentUser;
}

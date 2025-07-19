import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// ✅ Send OTP for registration
  Future<void> sendRegistrationOtp(String email) async {
    final callable = _functions.httpsCallable('sendRegistrationOtp');
    await callable.call({'email': email});
  }

  /// ✅ Verify OTP and register user
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String otp,
    required Map<String, dynamic> profile,
  }) async {
    final verifyCallable = _functions.httpsCallable('verifyRegistrationOtp');
    final result = await verifyCallable.call({'email': email, 'otp': otp});

    if (result.data is Map && result.data['valid'] == true) {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      await _firestore.collection('users').doc(user.uid).set({
        ...profile,
        'email': user.email,
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } else {
      throw FirebaseAuthException(
        code: 'invalid-otp',
        message: 'OTP verification failed.',
      );
    }
  }

  /// ✅ Login with email & password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      rethrow;
    }
  }

  /// ✅ Send OTP for password reset
  Future<void> sendPasswordResetOtp(String email) async {
    final methods = await _auth.fetchSignInMethodsForEmail(email);
    if (methods.isEmpty) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found for that email.',
      );
    }

    final callable = _functions.httpsCallable('sendPasswordResetOtp');
    await callable.call({'email': email});
  }

  /// ✅ Verify OTP and reset password
  Future<void> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final callable = _functions.httpsCallable('verifyPasswordResetOtp');
    final result = await callable.call({
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
    });

    if (!(result.data is Map && result.data['valid'] == true)) {
      throw FirebaseAuthException(
        code: 'invalid-otp',
        message: 'OTP verification failed.',
      );
    }

    // Assume password reset handled in Cloud Function
  }

  /// ✅ Google Sign-In
  /* Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'uid': user.uid,
        });
      }

      return user;
    } catch (e) {
      print('Google sign-in error: $e');
      return null;
    }
  }

  /// ✅ Facebook Sign-In
  Future<User?> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) return null;

      final token = result.accessToken!;
      final credential = FacebookAuthProvider.credential(token.token);

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'uid': user.uid,
        });
      }

      return user;
    } catch (e) {
      print('Facebook sign-in error: $e');
      return null;
    }
  }

  /// ✅ Sign out
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

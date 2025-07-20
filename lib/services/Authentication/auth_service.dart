import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Box _authBox = Hive.box('authBox');

  /// Initialize Hive for auth persistence
  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox('authBox');
  }

  /// Check if user is logged in (from Hive)
  bool get isLoggedIn =>
      _authBox.get('isLoggedIn', defaultValue: false) as bool;

  /// Get stored user ID from Hive
  String? get userId => _authBox.get('userId') as String?;

  /// Register with email & password
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        _saveAuthState(user.uid);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print('Registration error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  /// Login with email & password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        _saveAuthState(user.uid);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  /// Handle Sign In with validation
  Future<Map<String, dynamic>> handleSignIn(
    String email,
    String password,
  ) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return {'success': false, 'error': 'Please fill all fields'};
      }

      final user = await loginWithEmail(email, password);
      return {
        'success': user != null,
        'user': user,
        'error': user == null ? 'Login failed' : null,
      };
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'error': _getAuthErrorMessage(e)};
    } catch (e) {
      return {'success': false, 'error': 'An unexpected error occurred'};
    }
  }

  /// Google Sign-In
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        _saveAuthState(user.uid);

        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await _createUserDocument(
            user.uid,
            user.email,
            user.displayName,
            user.photoURL,
            'google.com',
          );
        }

        return {
          'user': user,
          'isNewUser': userCredential.additionalUserInfo?.isNewUser ?? false,
        };
      }
      return null;
    } catch (e) {
      print('Google sign in error: $e');
      rethrow;
    }
  }

  /// Facebook Sign-In
  Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status != LoginStatus.success) return null;

      final credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        _saveAuthState(user.uid);

        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          final userData = await FacebookAuth.instance.getUserData();
          await _createUserDocument(
            user.uid,
            user.email ?? userData['email'],
            user.displayName ?? userData['name'],
            user.photoURL ?? userData['picture']['data']['url'],
            'facebook.com',
          );
        }

        return {
          'user': user,
          'isNewUser': userCredential.additionalUserInfo?.isNewUser ?? false,
        };
      }
      return null;
    } catch (e) {
      print('Facebook sign in error: $e');
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Password reset error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  /// Update user profile in Firestore
  Future<void> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(profileData, SetOptions(merge: true));
    } catch (e) {
      print('Update profile error: $e');
      rethrow;
    }
  }

  /// Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      await _clearAuthState();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Helper methods
  Future<void> _saveAuthState(String userId) async {
    await _authBox.put('isLoggedIn', true);
    await _authBox.put('userId', userId);
  }

  Future<void> _clearAuthState() async {
    await _authBox.clear();
  }

  Future<void> _createUserDocument(
    String uid,
    String? email,
    String? name,
    String? photoUrl,
    String provider,
  ) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'provider': provider,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No account found with this email";
      case 'wrong-password':
        return "Incorrect password";
      case 'invalid-email':
        return "Invalid email address";
      case 'user-disabled':
        return "This account has been disabled";
      case 'too-many-requests':
        return "Too many attempts. Try again later";
      case 'email-already-in-use':
        return "Email already in use";
      case 'weak-password':
        return "Password is too weak";
      default:
        return e.message ?? "Authentication failed";
    }
  }
}

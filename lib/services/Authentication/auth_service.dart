import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Register with email & password
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      print("Attempting to register user with email: $email");

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      print("User registered successfully: ${user?.uid}");

      return user;
    } on FirebaseAuthException catch (e) {
      print('Registration FirebaseAuthException: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Registration general error: $e');
      rethrow;
    }
  }

  /// Update user profile in Firestore after registration
  Future<void> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No logged-in user found.',
        );
      }

      print("Updating profile for user: ${user.uid}");
      print("Profile data: $profileData");

      // Use set with merge: true to ensure the document is created/updated
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(profileData, SetOptions(merge: true));

      print("Profile updated successfully in Firestore");
    } on FirebaseException catch (e) {
      print('Firestore error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Update profile general error: $e');
      rethrow;
    }
  }

  /// Login (with email verification check)
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      print("Attempting to login user with email: $email");

      final uc = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = uc.user!;
      print("User logged in successfully: ${user.uid}");

      /*if (!user.emailVerified) {
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email before logging in.',
        );
      }*/

      return user;
    } on FirebaseAuthException catch (e) {
      print('Login FirebaseAuthException: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Login general error: $e');
      rethrow;
    }
  }

  /// Handle Sign In with validation and error handling
  Future<Map<String, dynamic>> handleSignIn(
    String email,
    String password,
  ) async {
    // Validate input
    if (email.isEmpty || password.isEmpty) {
      return {
        'success': false,
        'error': 'Please enter both email and password.',
      };
    }

    try {
      final user = await loginWithEmail(email, password);

      if (user != null) {
        return {'success': true, 'user': user};
      } else {
        return {'success': false, 'error': 'Sign in failed. Please try again.'};
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No account found with this email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address.";
          break;
        case 'email-not-verified':
          errorMessage = "Please verify your email before signing in.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many failed attempts. Please try again later.";
          break;
        case 'user-disabled':
          errorMessage = "This account has been disabled.";
          break;
        case 'invalid-credential':
          errorMessage = "Invalid email or password.";
          break;
        default:
          errorMessage = e.message ?? "An authentication error occurred.";
      }

      return {'success': false, 'error': errorMessage};
    } catch (e) {
      return {
        'success': false,
        'error': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent to: $email");
    } on FirebaseAuthException catch (e) {
      print('Password reset error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  /// Google Sign-In with account existence check and token saving
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('Google Sign-In cancelled by user');
        return null; // User cancelled sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Save token (implement saveToken as needed)
      final token = await user.getIdToken();

      // Check if user document exists in Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final bool isNewUser = !doc.exists;

      if (isNewUser) {
        // Create minimal user document for new users
        await _firestore.collection('users').doc(user.uid).set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("Created new Google user document: ${user.uid}");
      }

      return {'user': user, 'isNewUser': isNewUser};
    } on PlatformException catch (e) {
      print(
        'Google Sign-In PlatformException: ${e.code} - ${e.message} - ${e.details}',
      );
      rethrow;
    } catch (e) {
      print('Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Facebook Sign-In with account existence check
  Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        print('Facebook Sign-In failed: ${result.status} - ${result.message}');
        return null; // User cancelled or login failed
      }

      final accessToken = result.accessToken!.tokenString;
      final credential = FacebookAuthProvider.credential(accessToken);
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Check if user document exists in Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final bool isNewUser = !doc.exists;

      if (isNewUser) {
        // Create minimal user document for new users
        await _firestore.collection('users').doc(user.uid).set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("Created new Facebook user document: ${user.uid}");
      }

      return {'user': user, 'isNewUser': isNewUser};
    } on PlatformException catch (e) {
      print(
        'Facebook Sign-In PlatformException: ${e.code} - ${e.message} - ${e.details}',
      );
      rethrow;
    } catch (e) {
      print('Facebook Sign-In error: $e');
      rethrow;
    }
  }

  /// Check if user document exists in Firestore
  Future<bool> userDocumentExists(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      print('Error checking user document: $e');
      return false;
    }
  }

  /// Get user profile from Firestore
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Delete user account and data
  Future<void> deleteUserAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user document from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete Firebase Auth account
        await user.delete();

        print("User account and data deleted successfully");
      }
    } catch (e) {
      print('Error deleting user account: $e');
      rethrow;
    }
  }

  /// Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      print("User signed out successfully");
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

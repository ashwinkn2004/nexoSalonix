import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Authentication service handling all auth methods (Email, Google, Facebook, Apple)
class AuthService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Local storage
  final Box _authBox = Hive.box('authBox');

  /* ==================== INITIALIZATION ==================== */

  /// Initializes Hive for local storage
  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox('authBox');
  }

  /// Initializes and validates authentication state
  Future<void> initializeAuth() async {
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        await _clearAuthState(); // Clear local state if no user
      } else {
        await _saveAuthState(user.uid); // Update local state if user exists
      }
    });
  }

  /* ==================== AUTH STATE GETTERS ==================== */

  /// Checks if user is logged in (from local storage)
  bool get isLoggedIn =>
      _authBox.get('isLoggedIn', defaultValue: false) as bool;

  /// Gets stored user ID from local storage
  String? get userId => _authBox.get('userId') as String?;

  /// Gets current Firebase user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /* ==================== EMAIL/PASSWORD AUTH ==================== */

  /// Registers new user with email and password
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

  /// Logs in user with email and password
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

  /// Handles sign-in with validation
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

  /* ==================== SOCIAL AUTHENTICATION ==================== */

  /// Google Sign-In implementation
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Step 1: Trigger Google Sign-In flow
      final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

      // Force account picker if previously signed in
      try {
        if (await _googleSignIn.isSignedIn()) {
          await _googleSignIn
              .disconnect(); // This will revoke access and force picker
        }
      } catch (e) {
        print('Safe ignore Google disconnect error: $e');
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in aborted by user');
        return {'error': 'Google sign-in aborted'};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? email = googleUser.email;
      if (email == null) {
        print('Google account email not found');
        return {'error': 'Google account email not found'};
      }

      // Step 2: Check if email is already registered with another provider
      print('Checking sign-in methods for email: $email');
      final List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(
        email,
      );
      print('Sign-in methods found: $signInMethods');

      if (signInMethods.isNotEmpty && signInMethods.contains('password')) {
        print(
          'Email $email is already registered with email/password provider',
        );
        await GoogleSignIn().signOut(); // Ensure Google session is cleared
        return {
          'error':
              'An account with this email already exists. Please log in using your email and password or use a different Google account.',
        };
      }

      // Step 3: Proceed with Google sign-in only if no conflicting provider exists
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Attempting to sign in with Google credential');
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        print('Google sign-in successful for user: ${user.uid}');
        _saveAuthState(user.uid);

        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          print('Creating Firestore document for new user: ${user.uid}');
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

      print('Google sign-in failed: No user returned');
      return {'error': 'Google sign-in failed'};
    } on FirebaseAuthException catch (e) {
      print('Google sign-in FirebaseAuthException: ${e.code} - ${e.message}');
      await GoogleSignIn().signOut(); // Clear Google session on error
      if (e.code == 'account-exists-with-different-credential') {
        return {
          'error':
              'An account with this email already exists. Please log in using your email and password or use a different Google account.',
        };
      }
      return {'error': 'Google sign-in failed: ${e.message}'};
    } catch (e) {
      print('Unexpected Google sign-in error: $e');
      await GoogleSignIn().signOut(); // Clear Google session on error
      return {'error': 'Google sign-in failed: ${e.toString()}'};
    }
  }

  /// Facebook Sign-In implementation
  Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      // Trigger the login flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status != LoginStatus.success) {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Login aborted by user',
        );
      }

      // Create a credential from the access token
      final OAuthCredential credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      // Sign in with credential
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
    } on PlatformException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'ERROR_UNKNOWN',
        message: 'Unknown error occurred',
      );
    }
  }

  /// Apple Sign-In implementation
  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      // 1. Trigger Apple Sign-In flow
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // Required for web (replace with your values)
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.your.app.identifier', // Your Apple Service ID
          redirectUri: Uri.parse('https://your-domain.com/auth/apple'),
        ),
      );

      // 2. Create Firebase credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // 3. Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(oauthCredential);
      final user = userCredential.user;

      if (user != null) {
        _saveAuthState(user.uid);

        // 4. Create user document if new user
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await _createUserDocument(
            user.uid,
            appleCredential.email ?? user.email,
            _getAppleDisplayName(appleCredential),
            null, // Apple doesn't provide profile photos
            'apple.com',
          );
        }

        return {
          'user': user,
          'isNewUser': userCredential.additionalUserInfo?.isNewUser ?? false,
        };
      }
      return null;
    } on SignInWithAppleAuthorizationException catch (e) {
      throw FirebaseAuthException(code: 'APPLE_AUTH_ERROR', message: e.message);
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'APPLE_AUTH_UNKNOWN',
        message: 'Apple sign in failed',
      );
    }
  }

  /* ==================== USER MANAGEMENT ==================== */

  /// Sends password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Password reset error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  /// Updates user profile in Firestore
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

  /// Logs out user from all services
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

  /* ==================== HELPER METHODS ==================== */

  /// Saves auth state to local storage
  Future<void> _saveAuthState(String userId) async {
    await _authBox.put('isLoggedIn', true);
    await _authBox.put('userId', userId);
  }

  /// Clears auth state from local storage
  Future<void> _clearAuthState() async {
    await _authBox.clear();
  }

  /// Creates user document in Firestore
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

  /// Extracts display name from Apple credentials
  String? _getAppleDisplayName(AuthorizationCredentialAppleID credential) {
    if (credential.givenName != null && credential.familyName != null) {
      return '${credential.givenName} ${credential.familyName}';
    }
    return null;
  }

  /// Converts Firebase auth errors to user-friendly messages
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';
import 'firebase_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseService.auth;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Auth state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _createOrUpdateUserDoc(credential.user!);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  static Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name if provided
        if (displayName != null && displayName.isNotEmpty) {
          await credential.user!.updateDisplayName(displayName);
        }

        await _createOrUpdateUserDoc(credential.user!);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User canceled the sign-in
      }
      print('Google user-->: $googleUser');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('Google auth-->: $googleAuth');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        await _createOrUpdateUserDoc(userCredential.user!);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get user document from Firestore
  static Future<AppUser?> getUserData(String userId) async {
    try {
      final doc = await FirebaseService.getUserDoc(userId);
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, userId);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Create or update user document in Firestore
  static Future<void> _createOrUpdateUserDoc(User user) async {
    try {
      final userDoc = await FirebaseService.getUserDoc(user.uid);
      final now = DateTime.now();

      if (userDoc.exists) {
        // Update existing user
        await FirebaseService.updateUserDoc(user.uid, {
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'updatedAt': now.millisecondsSinceEpoch,
        });
      } else {
        // Create new user
        // Check if user should be admin (you can modify this logic)
        final isAdmin = _shouldBeAdmin(user.email);
        
        final userData = AppUser(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoURL: user.photoURL,
          role: isAdmin ? UserRole.admin : UserRole.user,
          createdAt: now,
          updatedAt: now,
        );

        await FirebaseService.createUserDoc(user.uid, userData.toMap());
      }
    } catch (e) {
      throw Exception('Failed to create/update user document: $e');
    }
  }

  // Helper method to determine if user should be admin
  static bool _shouldBeAdmin(String? email) {
    if (email == null) return false;
    
    // Define admin emails (you can modify this list)
    const adminEmails = [
      'admin@propertyfinder.com',
      'admin@example.com',
      // Add more admin emails as needed
    ];
    
    return adminEmails.contains(email.toLowerCase());
  }

  // Handle Firebase Auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}

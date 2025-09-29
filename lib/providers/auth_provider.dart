import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../services/preferences_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _firebaseUser;
  AppUser? _appUser;
  bool _isLoading = true; // Start with loading true
  bool _isGuest = false;
  String? _errorMessage;
  bool _isInitialized = false; // Track initialization state

  // Getters
  User? get firebaseUser => _firebaseUser;
  AppUser? get appUser => _appUser;
  bool get isLoading => _isLoading;
  bool get isGuest => _isGuest;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isAdmin => _appUser?.role == UserRole.admin;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() async {
    try {
      // Initialize preferences service
      await PreferencesService.init();
      
      // Check if user was previously logged in
      final wasLoggedIn = await PreferencesService.getIsLoggedIn();
      final isGuest = await PreferencesService.getIsGuest();
      
      if (wasLoggedIn && !isGuest) {
        // Try to restore user session
        final userId = await PreferencesService.getUserId();
        if (userId != null) {
          try {
            // Check if Firebase user is still authenticated
            _firebaseUser = AuthService.currentUser;
            if (_firebaseUser != null && _firebaseUser!.uid == userId) {
              // User is still authenticated, restore app user data
              _appUser = await AuthService.getUserData(userId);
              if (_appUser == null) {
                // App user data not found, clear preferences
                await PreferencesService.clearUserData();
                _firebaseUser = null;
              }
            } else {
              // Firebase user not authenticated or different user, clear preferences
              await PreferencesService.clearUserData();
              _firebaseUser = null;
              _appUser = null;
            }
          } catch (e) {
            // Failed to restore user, clear preferences
            await PreferencesService.clearUserData();
            _firebaseUser = null;
            _appUser = null;
          }
        }
      } else if (isGuest) {
        _isGuest = true;
      }

      // Set initialization complete
      _isInitialized = true;
      _isLoading = false;
      notifyListeners();

      // Listen to auth state changes
      AuthService.authStateChanges.listen((User? user) async {
        _firebaseUser = user;

        if (user != null) {
          _isGuest = false;
          try {
            _appUser = await AuthService.getUserData(user.uid);
            if (_appUser != null) {
              // Save user session to preferences
              await PreferencesService.saveUserSession(
                userId: user.uid,
                email: user.email ?? '',
                displayName: user.displayName,
                photoUrl: user.photoURL,
                role: _appUser!.role.name,
              );
            }
          } catch (e) {
            _errorMessage = 'Failed to load user data: $e';
          }
        } else {
          _appUser = null;
          _isGuest = false;
          // Clear preferences when user logs out
          await PreferencesService.clearUserData();
        }

        notifyListeners();
      });
    } catch (e) {
      _errorMessage = 'Failed to initialize authentication: $e';
      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final credential = await AuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential != null;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign up with email and password
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final credential = await AuthService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      return credential != null;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      final credential = await AuthService.signInWithGoogle();

      return credential != null;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Continue as guest
  void continueAsGuest() async {
    _isGuest = true;
    _firebaseUser = null;
    _appUser = null;
    _clearError();
    
    // Save guest state to preferences
    await PreferencesService.setIsGuest(true);
    await PreferencesService.setIsLoggedIn(false);
    
    notifyListeners();
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      await AuthService.signOut();
      _isGuest = false;
      
      // Clear preferences when signing out
      await PreferencesService.clearUserData();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await AuthService.resetPassword(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Add to favorites
  Future<void> addToFavorites(String listingId) async {
    print('User ID: ${_firebaseUser?.uid}');
    print('App User: ${_appUser?.id}');
    if (_appUser == null || _firebaseUser == null) return;

    try {
      final updatedFavorites = List<String>.from(_appUser!.favorites);
      if (!updatedFavorites.contains(listingId)) {
        updatedFavorites.add(listingId);

        await FirebaseService.updateUserDoc(_firebaseUser!.uid, {
          'favorites': updatedFavorites,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });

        _appUser = _appUser!.copyWith(
          favorites: updatedFavorites,
          updatedAt: DateTime.now(),
        );

        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to add to favorites: $e');
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String listingId) async {
    if (_appUser == null || _firebaseUser == null) return;

    try {
      final updatedFavorites = List<String>.from(_appUser!.favorites);
      updatedFavorites.remove(listingId);

      await FirebaseService.updateUserDoc(_firebaseUser!.uid, {
        'favorites': updatedFavorites,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      _appUser = _appUser!.copyWith(
        favorites: updatedFavorites,
        updatedAt: DateTime.now(),
      );

      notifyListeners();
    } catch (e) {
      _setError('Failed to remove from favorites: $e');
    }
  }

  // Check if listing is in favorites
  bool isFavorite(String listingId) {
    return _appUser?.favorites.contains(listingId) ?? false;
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String listingId) async {
    if (isFavorite(listingId)) {
      print('Removing from favorites--->: $listingId');
      await removeFromFavorites(listingId);
    } else {
      print('Adding to favorites--->: $listingId');
      await addToFavorites(listingId);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userDisplayNameKey = 'user_display_name';
  static const String _userPhotoUrlKey = 'user_photo_url';
  static const String _isGuestKey = 'is_guest';
  static const String _userRoleKey = 'user_role';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Authentication state
  static Future<bool> getIsLoggedIn() async {
    await init();
    return _prefs?.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setIsLoggedIn(bool value) async {
    await init();
    await _prefs?.setBool(_isLoggedInKey, value);
  }

  static Future<bool> getIsGuest() async {
    await init();
    return _prefs?.getBool(_isGuestKey) ?? false;
  }

  static Future<void> setIsGuest(bool value) async {
    await init();
    await _prefs?.setBool(_isGuestKey, value);
  }

  // User data
  static Future<String?> getUserId() async {
    await init();
    return _prefs?.getString(_userIdKey);
  }

  static Future<void> setUserId(String? value) async {
    await init();
    if (value != null) {
      await _prefs?.setString(_userIdKey, value);
    } else {
      await _prefs?.remove(_userIdKey);
    }
  }

  static Future<String?> getUserEmail() async {
    await init();
    return _prefs?.getString(_userEmailKey);
  }

  static Future<void> setUserEmail(String? value) async {
    await init();
    if (value != null) {
      await _prefs?.setString(_userEmailKey, value);
    } else {
      await _prefs?.remove(_userEmailKey);
    }
  }

  static Future<String?> getUserDisplayName() async {
    await init();
    return _prefs?.getString(_userDisplayNameKey);
  }

  static Future<void> setUserDisplayName(String? value) async {
    await init();
    if (value != null) {
      await _prefs?.setString(_userDisplayNameKey, value);
    } else {
      await _prefs?.remove(_userDisplayNameKey);
    }
  }

  static Future<String?> getUserPhotoUrl() async {
    await init();
    return _prefs?.getString(_userPhotoUrlKey);
  }

  static Future<void> setUserPhotoUrl(String? value) async {
    await init();
    if (value != null) {
      await _prefs?.setString(_userPhotoUrlKey, value);
    } else {
      await _prefs?.remove(_userPhotoUrlKey);
    }
  }

  static Future<String?> getUserRole() async {
    await init();
    return _prefs?.getString(_userRoleKey);
  }

  static Future<void> setUserRole(String? value) async {
    await init();
    if (value != null) {
      await _prefs?.setString(_userRoleKey, value);
    } else {
      await _prefs?.remove(_userRoleKey);
    }
  }

  // Clear all user data
  static Future<void> clearUserData() async {
    await init();
    await _prefs?.remove(_isLoggedInKey);
    await _prefs?.remove(_userIdKey);
    await _prefs?.remove(_userEmailKey);
    await _prefs?.remove(_userDisplayNameKey);
    await _prefs?.remove(_userPhotoUrlKey);
    await _prefs?.remove(_isGuestKey);
    await _prefs?.remove(_userRoleKey);
  }

  // Save complete user session
  static Future<void> saveUserSession({
    required String userId,
    required String email,
    String? displayName,
    String? photoUrl,
    String? role,
    bool isGuest = false,
  }) async {
    await init();
    await setIsLoggedIn(true);
    await setIsGuest(isGuest);
    await setUserId(userId);
    await setUserEmail(email);
    await setUserDisplayName(displayName);
    await setUserPhotoUrl(photoUrl);
    await setUserRole(role);
  }
}

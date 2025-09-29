# Property Finder App

A modern cross-platform Flutter application for browsing, searching, and managing property listings with real-time updates, professional services integration, and offline support. Built with Flutter and Firebase, the app demonstrates scalable architecture with Provider-based state management.

---

## Features

### Core Features

* Property Listings: Browse and search properties with category filters
* Real-time Updates: Live data synchronization via Firebase Firestore
* User Authentication: Google Sign-In, Email/Password, and Guest mode
* Wishlist Management: Add/remove favorite properties with optimistic UI updates
* Advanced Search: Text-based search with debouncing and category filters
* Image Gallery: Multiple image support per listing with carousel view
* Professional Services: Browse and contact service providers
* Add/Edit Listings: Create, update, and publish listings with images
* Admin Panel: Admin-only access to manage listings and initialize sample data
* Offline Support: Cached data and queued writes with offline indicators
* Responsive UI: Adaptive design for mobile, tablet, and web
* Performance Optimized: Lazy loading, image compression, and efficient state management
* Loading & Error States: Retry logic and user feedback
* Real-time Sync Across Devices

### User Roles

* Guest Users: Browse-only mode
* Authenticated Users: Full access including wishlist and listing creation
* Admin Users: Additional access to admin panel and data management

---

## Architecture

The app follows a clean architecture pattern with separation of concerns:

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models (Listing, User, Professional)
├── providers/                   # State management (AuthProvider, ListingsProvider)
├── services/                    # Business logic (AuthService, FirebaseService)
├── repositories/                # Data access layer (ListingRepository)
├── ui/
│   ├── screens/                 # App screens (Home, Login, AddListing, Wishlist)
│   └── widgets/                 # Reusable UI components (ListingCard, AnimatedSearchBar)
├── utils/                        # Utility functions and constants
└── firebase_options.dart         # Firebase configuration
```

**Key Points:**

* Presentation Layer: Screens and widgets consuming Providers for reactive updates
* State & Business Layer: Provider classes manage UI state and coordinate repository calls
* Data Layer: Repositories abstract Firebase operations; models convert Firestore documents to domain objects
* Offline & Real-Time: Firestore streams for real-time updates and write queueing for offline resilience

---

## Screens Overview

### Main Screens

* Home Screen: Featured listings, search, category filtering, quick-access buttons
* Listing Detail Screen: Image gallery, property info, contact owner, add to wishlist
* Add Listing Screen: Form to create/update listings with images and location
* Wishlist Screen: Manage favorite properties
* Login Screen: Email & Google Sign-In, guest mode
* Profile Screen: User info and navigation menu
* Professionals Screen: Browse service providers
* Admin Panel: Manage listings and initialize sample data

---

## Tech Stack

* Frontend: Flutter (Dart)
* State Management: Provider (ChangeNotifier)
* Backend: Firebase (Auth, Firestore, Storage, Analytics, Crashlytics)
* Routing: GoRouter
* Testing: flutter_test, integration tests
* CI/CD: GitHub Actions (example workflow included)

---

## Setup & Installation

### Prerequisites

* Flutter SDK (stable)
* Dart SDK (compatible version)
* Android Studio / Xcode (for platform builds)
* Firebase Project with Auth, Firestore, Storage

### Steps

1. Clone repository

```bash
git clone https://github.com/<your-username>/flutter-firebase-realestate-app.git
cd flutter-firebase-realestate-app
```

2. Install dependencies

```bash
flutter pub get
```

3. Firebase setup

* Add Android and iOS apps in Firebase Console
* Download configuration files:

   * android/app/google-services.json
   * ios/Runner/GoogleService-Info.plist
* Optional: Run `flutterfire configure` to generate firebase_options.dart

Environment-specific files:

```
android/app/src/debug/google-services.json
android/app/src/release/google-services.json
ios/Runner/GoogleService-Info-Debug.plist
ios/Runner/GoogleService-Info-Release.plist
```

4. Local environment variables
   Create `.env` (do not commit):

```
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
```

5. Run the app

```bash
flutter run -d <device_id>      # Android
flutter run -d ios              # iOS
flutter run -d chrome           # Web
```

6. Build for release

```bash
flutter build appbundle --release  # Android
flutter build ios --release        # iOS
```

---

## Firebase Security Rules (Example)

**Firestore**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /listings/{listingId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /professionals/{professionalId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

**Storage**

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

Deploy rules:

```bash
firebase deploy --only firestore:rules
```

---

## Testing

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

Coverage:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## Common Commands

```bash
flutter clean && flutter pub get
flutter build apk --analyze-size
```

---

## Test Credentials (Sample)

* Email: [test.user@example.com](mailto:test.user@example.com)
* Password: Password123!
* Admin Role: Set in Firestore `/users/{uid}` `{ role: "admin" }`

---

## Deployment

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

Archive using Xcode for App Store submission.

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/xyz`)
3. Commit changes (`git commit -m "Add feature"`)
4. Push branch (`git push origin feature/xyz`)
5. Open Pull Request

**Code Style:** Follow Dart Style Guide and run `flutter format`.

---

## Support

**Common Issues**

* Firebase configuration: Ensure google-services.json and GoogleService-Info.plist are correctly placed
* Build issues: Run `flutter clean && flutter pub get`
* Authentication issues: Verify Google Sign-In configuration and SHA-1 fingerprints

**Help:** Check GitHub Issues or `docs/` folder

---

## Version History

* v1.0.0: Initial release with core features
* v1.1.0: Added professional services
* v1.2.0: Enhanced search and filtering
* v1.3.0: UI improvements and performance optimization

---

## Demo

[Demo Video](https://drive.google.com/file/d/1vR5zTf7cRPZmysf-XY10NQEp0LrdA7_u/view?usp=drive_link)

---


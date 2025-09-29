# Deployment & Build Documentation

## Overview
This document provides comprehensive instructions for building, testing, and deploying the Property Finder App across different platforms and environments.

## Build Configurations

### Development Build
```bash
# Debug build for development
flutter run --debug

# Hot reload enabled
flutter run --hot

# Specific device
flutter run -d <device_id>
```

### Production Build

#### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Build with specific flavor
flutter build apk --release --flavor production
```

#### iOS
```bash
# Build for iOS
flutter build ios --release

# Build IPA for distribution
flutter build ipa --release

# Build for specific configuration
flutter build ios --release --flavor production
```

#### Web
```bash
# Build for web
flutter build web --release

# Build with specific base href
flutter build web --release --base-href /property-finder/
```

## Environment Configuration

### Development Environment
```yaml
# pubspec.yaml - dev dependencies
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  integration_test:
    sdk: flutter
```

### Production Environment
- Remove debug flags
- Enable code obfuscation
- Optimize asset sizes
- Configure proper Firebase project

## Firebase Setup for Different Environments

### Development Firebase Project
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize project
firebase init

# Select development project
firebase use development-project-id
```

### Production Firebase Project
```bash
# Switch to production project
firebase use production-project-id

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy storage rules
firebase deploy --only storage
```

### Environment-Specific Configuration Files

#### Android
```
android/app/src/debug/google-services.json     # Development
android/app/src/release/google-services.json   # Production
```

#### iOS
```
ios/Runner/GoogleService-Info-Debug.plist      # Development
ios/Runner/GoogleService-Info-Release.plist    # Production
```

## Code Signing & Certificates

### Android Signing
```bash
# Generate keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Configure in android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>
```

### iOS Signing
- Configure in Xcode
- Set up provisioning profiles
- Configure signing certificates
- Set bundle identifier

## Deployment Platforms

### Google Play Store

#### Prerequisites
- Google Play Console account
- Signed App Bundle
- Store listing assets

#### Deployment Steps
```bash
# 1. Build signed app bundle
flutter build appbundle --release

# 2. Upload to Play Console
# - Navigate to Google Play Console
# - Create new release
# - Upload app bundle
# - Fill release notes
# - Submit for review
```

#### Play Store Assets Required
- App icon (512x512)
- Feature graphic (1024x500)
- Screenshots (phone, tablet)
- Privacy policy URL
- App description

### Apple App Store

#### Prerequisites
- Apple Developer account
- App Store Connect access
- Signed IPA file

#### Deployment Steps
```bash
# 1. Build for iOS
flutter build ios --release

# 2. Archive in Xcode
# 3. Upload to App Store Connect
# 4. Submit for review
```

#### App Store Assets Required
- App icon (1024x1024)
- Screenshots (various device sizes)
- App preview videos (optional)
- App description
- Keywords
- Privacy policy

### Web Deployment

#### Firebase Hosting
```bash
# Initialize hosting
firebase init hosting

# Build web app
flutter build web --release

# Deploy to Firebase
firebase deploy --only hosting
```

#### Other Web Platforms
```bash
# Build web app
flutter build web --release

# Deploy to any static hosting
# - Netlify
# - Vercel
# - GitHub Pages
# - AWS S3 + CloudFront
```

## CI/CD Pipeline

### GitHub Actions Example
```yaml
# .github/workflows/deploy.yml
name: Deploy App

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build appbundle --release
      - uses: actions/upload-artifact@v3
        with:
          name: app-bundle
          path: build/app/outputs/bundle/release/

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build ios --release --no-codesign
```

### Fastlane Integration
```ruby
# fastlane/Fastfile
platform :android do
  desc "Deploy to Play Store"
  lane :deploy do
    gradle(task: "bundleRelease")
    upload_to_play_store(
      track: "production",
      aab: "../build/app/outputs/bundle/release/app-release.aab"
    )
  end
end

platform :ios do
  desc "Deploy to App Store"
  lane :deploy do
    build_app(scheme: "Runner")
    upload_to_app_store
  end
end
```

## Testing Before Deployment

### Unit Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

### Integration Tests
```bash
# Run integration tests
flutter test integration_test/

# Run on specific device
flutter test integration_test/ -d <device_id>
```

### Performance Testing
```bash
# Profile app performance
flutter run --profile

# Analyze app size
flutter build apk --analyze-size
flutter build ios --analyze-size
```

## Security Considerations

### Code Obfuscation
```bash
# Build with obfuscation
flutter build apk --obfuscate --split-debug-info=/<project-name>/<directory>
flutter build ios --obfuscate --split-debug-info=/<project-name>/<directory>
```

### API Keys & Secrets
- Use environment variables
- Never commit secrets to repository
- Use Firebase Remote Config for dynamic values
- Implement certificate pinning for API calls

### Firebase Security Rules
```javascript
// Firestore rules example
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /listings/{document} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Monitoring & Analytics

### Firebase Analytics
```dart
// Track custom events
FirebaseAnalytics.instance.logEvent(
  name: 'listing_viewed',
  parameters: {
    'listing_id': listingId,
    'category': category,
  },
);
```

### Crashlytics
```dart
// Report custom errors
FirebaseCrashlytics.instance.recordError(
  error,
  stackTrace,
  reason: 'Custom error description',
);
```

### Performance Monitoring
```dart
// Track custom traces
final trace = FirebasePerformance.instance.newTrace('listing_load');
await trace.start();
// ... perform operation
await trace.stop();
```

## Rollback Strategy

### Version Management
- Use semantic versioning (1.0.0)
- Tag releases in Git
- Maintain release branches
- Document breaking changes

### Emergency Rollback
```bash
# Revert to previous version
git revert <commit-hash>

# Deploy previous version
flutter build appbundle --build-number=<previous-number>

# Update store listing if needed
```

## Performance Optimization

### Build Optimization
```bash
# Reduce app size
flutter build apk --split-per-abi
flutter build appbundle --target-platform android-arm,android-arm64

# Tree shaking
flutter build web --tree-shake-icons
```

### Asset Optimization
- Compress images
- Use vector graphics (SVG)
- Implement lazy loading
- Cache network images

## Troubleshooting

### Common Build Issues
1. **Gradle build failures**
   - Clean build: `flutter clean && flutter pub get`
   - Update Gradle version
   - Check Android SDK versions

2. **iOS build failures**
   - Update Xcode
   - Clean derived data
   - Update CocoaPods: `pod repo update`

3. **Web build issues**
   - Check browser compatibility
   - Verify CORS settings
   - Update web dependencies

### Deployment Issues
1. **Store rejection**
   - Review store guidelines
   - Check app permissions
   - Verify content policy compliance

2. **Firebase deployment**
   - Verify project configuration
   - Check security rules
   - Validate API keys

## Maintenance

### Regular Updates
- Update Flutter SDK monthly
- Update dependencies quarterly
- Review security vulnerabilities
- Monitor app performance metrics

### Backup Strategy
- Regular database backups
- Source code versioning
- Configuration backups
- Asset backups

## Documentation Updates
- Update deployment docs with each release
- Document configuration changes
- Maintain troubleshooting guides
- Keep security practices current

---

## Quick Reference

### Essential Commands
```bash
# Development
flutter run --debug
flutter hot reload

# Testing
flutter test
flutter test integration_test/

# Building
flutter build apk --release
flutter build ios --release
flutter build web --release

# Deployment
firebase deploy
fastlane deploy
```

### Important Files
- `pubspec.yaml` - Dependencies and configuration
- `android/key.properties` - Android signing
- `ios/Runner.xcworkspace` - iOS configuration
- `firebase.json` - Firebase configuration
- `.github/workflows/` - CI/CD pipelines

This documentation should be updated with each major release and reviewed quarterly for accuracy and completeness.
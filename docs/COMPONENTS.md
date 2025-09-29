# Property Finder App - Component Structure & UI Patterns

## Overview

This document provides a comprehensive overview of the UI components, widgets, and design patterns used throughout the Property Finder App. It serves as a guide for developers to understand the component hierarchy and reusable patterns.

## 🏗️ Component Architecture

### Component Hierarchy
```
App Root (main.dart)
├── MultiProvider (State Management)
├── MaterialApp (Theme & Navigation)
└── GoRouter (Route Management)
    ├── LoginScreen
    ├── HomeScreen
    ├── ProfileScreen
    ├── AddListingScreen
    ├── WishlistScreen
    ├── ProfessionalsScreen
    ├── AdminPanelScreen
    └── ListingDetailScreen
```

## 📱 Screen Components

### 1. HomeScreen
**Location**: `lib/ui/screens/home_screen.dart`

**Purpose**: Main landing page displaying property listings with search and navigation

**Key Components**:
```dart
HomeScreen
├── AppBar (Custom)
├── SearchSection
│   ├── AnimatedSearchBar
│   └── SearchFilters
├── QuickAccessButtons
│   ├── TopBarButton (Wishlist)
│   ├── TopBarButton (Add Listing)
│   └── TopBarButton (Professionals)
├── CategorySection
│   └── CategoryChips
└── ListingsGrid
    └── ListingCard (Multiple)
```

**State Management**:
- Uses `Consumer<ListingsProvider>` for listings data
- Uses `Consumer<AuthProvider>` for user authentication state

### 2. LoginScreen
**Location**: `lib/ui/screens/login_screen.dart`

**Purpose**: User authentication interface

**Key Components**:
```dart
LoginScreen
├── AppLogo/Branding
├── WelcomeText
├── GoogleSignInButton
├── GuestModeButton
└── TermsAndConditions
```

### 3. ProfileScreen
**Location**: `lib/ui/screens/profile_screen.dart`

**Purpose**: User profile and app navigation hub

**Key Components**:
```dart
ProfileScreen
├── UserProfileHeader
│   ├── ProfileImage
│   ├── UserName
│   └── UserEmail
├── NavigationMenu
│   ├── MenuTile (Wishlist)
│   ├── MenuTile (Add Listing)
│   ├── MenuTile (Professionals)
│   └── MenuTile (Admin Panel) [Admin Only]
└── ActionButtons
    ├── SignOutButton
    └── GuestModeIndicator
```

### 4. AddListingScreen
**Location**: `lib/ui/screens/add_listing_screen.dart`

**Purpose**: Create new property listings

**Key Components**:
```dart
AddListingScreen
├── FormHeader
├── ImageUploadSection
│   ├── ImagePicker
│   ├── ImagePreview
│   └── ImageGrid
├── ListingForm
│   ├── TitleField
│   ├── DescriptionField
│   ├── PriceField
│   ├── CategoryDropdown
│   ├── LocationField
│   └── ContactFields
└── SubmitButton
```

### 5. WishlistScreen
**Location**: `lib/ui/screens/wishlist_screen.dart`

**Purpose**: Display user's saved favorite listings

**Key Components**:
```dart
WishlistScreen
├── AppBar
├── WishlistGrid
│   └── ListingCard (Multiple)
└── EmptyState
    ├── EmptyIcon
    ├── EmptyMessage
    └── ExploreButton
```

### 6. ProfessionalsScreen
**Location**: `lib/ui/screens/professionals_screen.dart`

**Purpose**: Browse professional service providers

**Key Components**:
```dart
ProfessionalsScreen
├── AppBar
├── SearchBar
├── FilterChips
└── ProfessionalsList
    └── ProfessionalCard (Multiple)
```

### 7. AdminPanelScreen
**Location**: `lib/ui/screens/admin_panel_screen.dart`

**Purpose**: Administrative tools and data management

**Key Components**:
```dart
AdminPanelScreen
├── AdminHeader
├── QuickActions
│   ├── InitializeDataButton
│   └── ManageListingsButton
├── StatisticsCards
└── ListingsManagement
    └── ListingTile (Multiple)
```

## 🧩 Reusable Widgets

### 1. ListingCard
**Location**: `lib/ui/widgets/listing_card.dart`

**Purpose**: Display property listing information in a card format

**Props**:
```dart
class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onTap;
  final bool showFavoriteButton;
  
  // Usage in different contexts:
  // - Home screen grid
  // - Search results
  // - Wishlist grid
  // - Category filtered results
}
```

**Features**:
- Image carousel with multiple photos
- Price display with formatting
- Location and basic details
- Favorite/wishlist toggle
- Responsive sizing
- Tap navigation to detail view

### 2. AnimatedSearchBar
**Location**: `lib/ui/widgets/animated_search_bar.dart`

**Purpose**: Expandable search input with animation

**Props**:
```dart
class AnimatedSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String hintText;
  final bool isExpanded;
}
```

**Features**:
- Smooth expand/collapse animation
- Debounced search input
- Clear button functionality
- Focus management

### 3. TopBarButton
**Location**: `lib/ui/widgets/top_bar_button.dart`

**Purpose**: Consistent button styling for navigation actions

**Props**:
```dart
class TopBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
}
```

**Usage**:
- Quick access buttons on home screen
- Navigation buttons throughout app
- Action buttons in various contexts

### 4. ProfessionalCard
**Location**: `lib/ui/widgets/professional_card.dart`

**Purpose**: Display professional service provider information

**Props**:
```dart
class ProfessionalCard extends StatelessWidget {
  final Professional professional;
  final VoidCallback? onTap;
}
```

**Features**:
- Professional photo
- Name and specialization
- Rating display
- Contact information
- Service categories

## 🎨 Design Patterns & UI Conventions

### 1. Color Scheme
```dart
// Primary Colors
const Color primaryColor = Color(0xFF2196F3);
const Color primaryDark = Color(0xFF1976D2);
const Color accent = Color(0xFFFF5722);

// Background Colors
const Color backgroundColor = Color(0xFFF5F5F5);
const Color cardBackground = Colors.white;
const Color surfaceColor = Color(0xFFFAFAFA);

// Text Colors
const Color primaryText = Color(0xFF212121);
const Color secondaryText = Color(0xFF757575);
const Color hintText = Color(0xFFBDBDBD);
```

### 2. Typography
```dart
// Heading Styles
TextStyle headingLarge = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: primaryText,
);

TextStyle headingMedium = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: primaryText,
);

// Body Styles
TextStyle bodyLarge = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: primaryText,
);

TextStyle bodyMedium = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: secondaryText,
);
```

### 3. Spacing System
```dart
// Consistent spacing values
const double spacingXS = 4.0;
const double spacingS = 8.0;
const double spacingM = 16.0;
const double spacingL = 24.0;
const double spacingXL = 32.0;
const double spacingXXL = 48.0;
```

### 4. Border Radius
```dart
// Consistent border radius values
const double radiusS = 4.0;
const double radiusM = 8.0;
const double radiusL = 12.0;
const double radiusXL = 16.0;
const double radiusRound = 50.0;
```

## 📐 Layout Patterns

### 1. Grid Layouts
**Staggered Grid** (Home Screen):
```dart
StaggeredGrid.count(
  crossAxisCount: 2,
  mainAxisSpacing: 16,
  crossAxisSpacing: 16,
  children: listings.map((listing) => 
    SizedBox(
      height: 420, // Consistent card height
      child: ListingCard(listing: listing),
    ),
  ).toList(),
)
```

**Regular Grid** (Wishlist):
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: screenWidth > 600 ? 0.72 : 0.68,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemBuilder: (context, index) => ListingCard(listing: listings[index]),
)
```

### 2. List Layouts
**Horizontal Scrolling** (Categories):
```dart
SizedBox(
  height: 300,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) => Container(
      width: 300, // Consistent card width
      margin: EdgeInsets.only(right: 16),
      child: ListingCard(listing: listings[index]),
    ),
  ),
)
```

### 3. Form Layouts
**Consistent Form Pattern**:
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    TextFormField(
      decoration: InputDecoration(
        labelText: 'Field Label',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
      ),
    ),
    SizedBox(height: spacingM),
    // Next field...
  ],
)
```

## 🔄 State Management Patterns

### 1. Provider Pattern Usage
```dart
// Consumer for UI updates
Consumer<ListingsProvider>(
  builder: (context, listingsProvider, child) {
    if (listingsProvider.isLoading) {
      return CircularProgressIndicator();
    }
    
    return GridView.builder(
      itemCount: listingsProvider.listings.length,
      itemBuilder: (context, index) => ListingCard(
        listing: listingsProvider.listings[index],
      ),
    );
  },
)

// Selector for specific data
Selector<AuthProvider, bool>(
  selector: (context, authProvider) => authProvider.isAuthenticated,
  builder: (context, isAuthenticated, child) {
    return isAuthenticated ? AuthenticatedView() : GuestView();
  },
)
```

### 2. Loading States
```dart
// Standard loading pattern
if (provider.isLoading) {
  return Center(
    child: CircularProgressIndicator(),
  );
}

// Shimmer loading for cards
if (provider.isLoading) {
  return GridView.builder(
    itemCount: 6, // Placeholder count
    itemBuilder: (context, index) => ShimmerCard(),
  );
}
```

### 3. Error Handling
```dart
// Error state display
if (provider.hasError) {
  return ErrorWidget(
    message: provider.errorMessage,
    onRetry: () => provider.retry(),
  );
}
```

## 🎯 Responsive Design

### 1. Breakpoints
```dart
// Screen size breakpoints
const double mobileBreakpoint = 600;
const double tabletBreakpoint = 900;
const double desktopBreakpoint = 1200;

// Usage
bool isMobile = MediaQuery.of(context).size.width < mobileBreakpoint;
bool isTablet = MediaQuery.of(context).size.width < tabletBreakpoint;
```

### 2. Adaptive Layouts
```dart
// Responsive grid columns
int getCrossAxisCount(double screenWidth) {
  if (screenWidth > desktopBreakpoint) return 4;
  if (screenWidth > tabletBreakpoint) return 3;
  if (screenWidth > mobileBreakpoint) return 2;
  return 1;
}

// Responsive aspect ratios
double getAspectRatio(double screenWidth) {
  return screenWidth > mobileBreakpoint ? 0.72 : 0.68;
}
```

## 🔧 Custom Widgets Best Practices

### 1. Widget Composition
- Break complex widgets into smaller, focused components
- Use composition over inheritance
- Create reusable widgets for common patterns

### 2. Performance Optimization
- Use `const` constructors where possible
- Implement `shouldRebuild` for complex widgets
- Use `ListView.builder` for large lists
- Implement proper `keys` for list items

### 3. Accessibility
- Provide semantic labels for interactive elements
- Ensure proper contrast ratios
- Support screen readers with appropriate descriptions
- Implement keyboard navigation where applicable

## 📱 Platform-Specific Considerations

### 1. iOS Adaptations
- Use `CupertinoPageScaffold` for iOS-style navigation
- Implement iOS-style alerts and action sheets
- Follow iOS Human Interface Guidelines

### 2. Android Adaptations
- Use Material Design components
- Implement Android-style navigation patterns
- Follow Material Design Guidelines

### 3. Cross-Platform Consistency
- Maintain consistent spacing and typography
- Use platform-adaptive widgets where appropriate
- Ensure feature parity across platforms

## 🧪 Testing Patterns

### 1. Widget Testing
```dart
testWidgets('ListingCard displays listing information', (tester) async {
  final listing = Listing(/* test data */);
  
  await tester.pumpWidget(
    MaterialApp(
      home: ListingCard(listing: listing),
    ),
  );
  
  expect(find.text(listing.title), findsOneWidget);
  expect(find.text(listing.price.toString()), findsOneWidget);
});
```

### 2. Integration Testing
- Test complete user flows
- Verify navigation between screens
- Test state management integration

This component structure ensures maintainable, scalable, and consistent UI development across the Property Finder App.
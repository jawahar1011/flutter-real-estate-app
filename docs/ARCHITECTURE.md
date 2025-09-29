# Property Finder App - Architecture Documentation

## Overview

The Property Finder App is a Flutter-based mobile application that allows users to browse, search, and manage property listings. The app follows a clean architecture pattern with clear separation of concerns.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                       │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │    Home     │  │   Profile   │  │  Wishlist   │  │  Admin  │ │
│  │   Screen    │  │   Screen    │  │   Screen    │  │  Panel  │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │Add Listing  │  │Professionals│  │   Login     │  │Listing  │ │
│  │   Screen    │  │   Screen    │  │   Screen    │  │ Detail  │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
├─────────────────────────────────────────────────────────────────┤
│                         UI WIDGETS                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ ListingCard │  │AnimatedSearch│  │TopBarButtons│              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────┐
│                      STATE MANAGEMENT                           │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐              ┌─────────────────┐           │
│  │  AuthProvider   │              │ ListingsProvider│           │
│  │                 │              │                 │           │
│  │ • User Auth     │              │ • Listings CRUD │           │
│  │ • Guest Mode    │              │ • Search/Filter │           │
│  │ • User Profile  │              │ • Categories    │           │
│  └─────────────────┘              └─────────────────┘           │
└─────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────┐
│                       BUSINESS LOGIC                            │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │    Models   │  │  Services   │  │ Repositories│              │
│  │             │  │             │  │             │              │
│  │ • Listing   │  │ • Auth      │  │ • Listing   │              │
│  │ • User      │  │ • Firebase  │  │ Repository  │              │
│  │ • Professional│ │ • Prefs     │  │             │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────────┐
│                         DATA LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐              ┌─────────────────┐           │
│  │   Firebase      │              │ Local Storage   │           │
│  │                 │              │                 │           │
│  │ • Firestore DB  │              │ • SharedPrefs   │           │
│  │ • Authentication│              │ • Image Cache   │           │
│  │ • Storage       │              │                 │           │
│  └─────────────────┘              └─────────────────┘           │
└─────────────────────────────────────────────────────────────────┘
```

## Layer Descriptions

### 1. Presentation Layer
- **Screens**: Individual UI screens that represent different app features
- **Widgets**: Reusable UI components used across multiple screens
- **Navigation**: GoRouter-based declarative routing system

### 2. State Management Layer
- **Provider Pattern**: Uses Flutter Provider for state management
- **AuthProvider**: Manages user authentication, guest mode, and user profile
- **ListingsProvider**: Handles listings data, search, filtering, and CRUD operations

### 3. Business Logic Layer
- **Models**: Data models representing core entities (Listing, User, Professional)
- **Services**: Business logic services for authentication, Firebase operations, and preferences
- **Repositories**: Data access layer that abstracts data sources

### 4. Data Layer
- **Firebase**: Cloud-based backend services
  - Firestore for NoSQL database
  - Firebase Auth for user authentication
  - Firebase Storage for file uploads
- **Local Storage**: Device-based storage for caching and preferences

## Key Components

### Authentication Flow
```
User Input → AuthProvider → AuthService → Firebase Auth → User State Update
```

### Data Flow
```
UI Action → Provider → Repository → Firebase/Local → Provider → UI Update
```

### Navigation Flow
```
User Action → GoRouter → Route Guard → Screen Widget → Provider Consumer
```

## Design Patterns Used

1. **Provider Pattern**: For state management and dependency injection
2. **Repository Pattern**: For data access abstraction
3. **Factory Pattern**: For model creation from data sources
4. **Observer Pattern**: For reactive UI updates
5. **Singleton Pattern**: For service instances

## Security Considerations

- Firebase Security Rules for data access control
- User role-based access (User/Admin)
- Input validation and sanitization
- Secure authentication flow with Firebase Auth

## Performance Optimizations

- Lazy loading of images with caching
- Pagination for large data sets
- Efficient state management with Provider
- Optimized build methods with const constructors
- Image compression for uploads
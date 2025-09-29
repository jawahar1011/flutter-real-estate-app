[# Property Finder App - API & Data Flow Documentation

## Overview

This document details the API interactions and data flow patterns within the Property Finder App, showing how data moves between the client, Firebase services, and local storage.

## Firebase Services Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        FIREBASE BACKEND                         │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │  Firebase   │  │  Firestore  │  │  Firebase   │              │
│  │    Auth     │  │  Database   │  │   Storage   │              │
│  │             │  │             │  │             │              │
│  │ • Google    │  │ • Users     │  │ • Images    │              │
│  │   Sign-In   │  │ • Listings  │  │ • Files     │              │
│  │ • User Mgmt │  │ • Real-time │  │ • CDN       │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
```

## 1. Authentication Data Flow

### Google Sign-In Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Client    │───▶│   Google    │───▶│  Firebase   │───▶│  Firestore  │
│  (Flutter)  │    │   OAuth     │    │    Auth     │    │   Users     │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │                   │
       ▼                   ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│User Taps    │    │Google       │    │ID Token     │    │User Document│
│Sign In      │    │Credentials  │    │Validation   │    │Created/     │
│             │    │             │    │             │    │Updated      │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

### Authentication State Management
```
Firebase Auth State Change
         │
         ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│AuthProvider │───▶│Update UI    │───▶│Route        │
│State Update │    │State        │    │Redirect     │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 2. Listings Data Flow

### Fetch Listings
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│UI Component │───▶│Listings     │───▶│Listing      │───▶│Firestore    │
│(Home/Search)│    │Provider     │    │Repository   │    │Query        │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       ▲                   ▲                   ▲                   │
       │                   │                   │                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│UI Update    │◀───│Provider     │◀───│Repository   │◀───│Firestore    │
│(Rebuild)    │    │notifyList.. │    │Returns Data │    │Response     │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

### Real-time Listings Updates
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Firestore    │───▶│Stream       │───▶│Provider     │
│Collection   │    │Listener     │    │Update       │
│Change       │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘
                           │                   │
                           ▼                   ▼
                   ┌─────────────┐    ┌─────────────┐
                   │Auto Rebuild │    │UI Reflects  │
                   │Consumers    │    │New Data     │
                   └─────────────┘    └─────────────┘
```

### Create New Listing
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Add Listing  │───▶│Image        │───▶│Firebase     │───▶│Get Download │
│Form Submit  │    │Upload       │    │Storage      │    │URLs         │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │                                                         │
       ▼                                                         ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Listing Data │───▶│Listings     │───▶│Firestore    │───▶│Document     │
│+ Image URLs │    │Provider     │    │Collection   │    │Created      │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

## 3. Search and Filter Data Flow

### Search Implementation
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Search Input │───▶│Debounced    │───▶│Firestore    │
│(User Types) │    │Query        │    │Text Search  │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Local State  │    │Provider     │    │Filtered     │
│Update       │    │Update       │    │Results      │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Category Filter Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Category     │───▶│Firestore    │───▶│Category     │
│Selection    │    │Query with   │    │Specific     │
│             │    │where clause │    │Results      │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 4. Wishlist Data Flow

### Add to Wishlist
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Heart Icon   │───▶│Auth Check   │───▶│User Document│───▶│Update       │
│Tap          │    │             │    │Favorites    │    │Firestore    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │                   │
       ▼                   ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Optimistic   │    │Guest Mode   │    │Array        │    │Provider     │
│UI Update    │    │Fallback     │    │Update       │    │Notification │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

### Fetch User Wishlist
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Wishlist     │───▶│User Document│───▶│Listing IDs  │
│Screen Load  │    │Favorites    │    │Array        │
└─────────────┘    └─────────────┘    └─────────────┘
       │                                       │
       ▼                                       ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Batch Query  │◀───│Firestore    │◀───│Map to       │
│Listings     │    │where in     │    │Listing Docs │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 5. Image Upload Data Flow

### Image Selection and Upload
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Image Picker │───▶│Image        │───▶│Firebase     │───▶│Storage      │
│Selection    │    │Compression  │    │Storage      │    │Reference    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │                   │
       ▼                   ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Local File   │    │Optimized    │    │Upload       │    │Download URL │
│Access       │    │File Size    │    │Progress     │    │Generated    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

## 6. Admin Panel Data Flow

### Admin Operations
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Admin Panel  │───▶│Role Check   │───▶│Admin        │
│Access       │    │(User.role)  │    │Operations   │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Unauthorized │    │Admin UI     │    │Bulk Data    │
│Redirect     │    │Components   │    │Operations   │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Initialize Sample Data
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Admin Button │───▶│Batch Write  │───▶│Multiple     │
│Click        │    │Operation    │    │Collections  │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Sample Data  │    │Firestore    │    │Success      │
│Generation   │    │Batch Commit │    │Notification │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 7. Error Handling and Retry Logic

### Network Error Handling
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│API Call     │───▶│Network      │───▶│Error        │
│             │    │Timeout      │    │Caught       │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Retry Logic  │    │User         │    │Fallback     │
│(3 attempts) │    │Notification │    │UI State     │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 8. Caching and Performance

### Image Caching Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Image Request│───▶│Cache Check  │───▶│Cached Image │
│             │    │             │    │Display      │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │
       ▼                   ▼
┌─────────────┐    ┌─────────────┐
│Network      │    │Cache Miss   │
│Download     │    │             │
└─────────────┘    └─────────────┘
```

### Data Pagination
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Scroll to    │───▶│Load More    │───▶│Firestore    │
│Bottom       │    │Trigger      │    │Query Next   │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Append to    │◀───│Provider     │◀───│Additional   │
│Existing List│    │Update       │    │Documents    │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 9. Security Rules and Data Validation

### Firestore Security Rules Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Client       │───▶│Firestore    │───▶│Security     │
│Request      │    │Receives     │    │Rules Check  │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Request      │    │Allow/Deny   │    │Data Access │
│Validation   │    │Decision     │    │Granted      │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 10. Offline Support

### Offline Data Handling
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│User Action  │───▶│Connectivity │───▶│Local Cache  │
│(Offline)    │    │Check        │    │Access       │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Queue for    │    │Offline      │    │Show Cached  │
│Sync         │    │Indicator    │    │Data         │
└─────────────┘    └─────────────┘    └─────────────┘
```

## API Endpoints Summary

### Firebase Auth
- `signInWithGoogle()` - Google OAuth authentication
- `signOut()` - User logout
- `onAuthStateChanged()` - Authentication state listener

### Firestore Collections
- `/users/{userId}` - User profiles and preferences
- `/listings/{listingId}` - Property listings
- `/professionals/{professionalId}` - Service providers

### Firebase Storage
- `/listing_images/{userId}/{imageId}` - Listing images
- `/profile_images/{userId}` - User profile images

## Performance Considerations

1. **Lazy Loading**: Images and data loaded on demand
2. **Pagination**: Large datasets split into manageable chunks
3. **Caching**: Aggressive caching for frequently accessed data
4. **Compression**: Images compressed before upload
5. **Indexing**: Firestore indexes for efficient queries
6. **Real-time Optimization**: Selective real-time listeners]([]())
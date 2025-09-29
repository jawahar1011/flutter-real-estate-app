# Property Finder App - User Flow Diagrams

## Overview

This document outlines the key user journeys and flows within the Property Finder App, showing how users interact with different features and navigate through the application.

## 1. Authentication Flow

### New User Registration/Login
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   App Start │───▶│ Login Screen│───▶│Google Sign-In│───▶│ Home Screen │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                           │                   │
                           ▼                   │
                   ┌─────────────┐            │
                   │Guest Mode   │────────────┘
                   │(Limited)    │
                   └─────────────┘
```

### User States
- **Authenticated User**: Full access to all features
- **Guest User**: Limited access (browse only, no favorites/add listings)
- **Admin User**: Additional access to admin panel

## 2. Home Screen Navigation Flow

### Main Navigation
```
┌─────────────┐
│ Home Screen │
└──────┬──────┘
       │
   ┌───▼───┐
   │ Menu  │
   └───┬───┘
       │
   ┌───▼────────────────────────────────────┐
   │                                        │
   ▼                                        ▼
┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐
│Profile  │  │Wishlist │  │Add      │  │Profess- │
│Screen   │  │Screen   │  │Listing  │  │ionals   │
└─────────┘  └─────────┘  └─────────┘  └─────────┘
```

### Search and Browse Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Home Screen │───▶│Search Input │───▶│Search       │
└─────────────┘    └─────────────┘    │Results      │
       │                              └─────────────┘
       ▼                                      │
┌─────────────┐    ┌─────────────┐           ▼
│Category     │───▶│Category     │    ┌─────────────┐
│Selection    │    │Listings     │───▶│Listing      │
└─────────────┘    └─────────────┘    │Detail       │
                                      └─────────────┘
```

## 3. Listing Management Flow

### View Listing Details
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Listing Card │───▶│Listing      │───▶│Contact      │
│(Any Screen) │    │Detail       │    │Owner        │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │
       ▼                   ▼
┌─────────────┐    ┌─────────────┐
│Add to       │    │Share        │
│Wishlist     │    │Listing      │
└─────────────┘    └─────────────┘
```

### Add New Listing (Authenticated Users)
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Profile/Home │───▶│Add Listing  │───▶│Image        │
│"+" Button   │    │Form         │    │Selection    │
└─────────────┘    └─────────────┘    └─────────────┘
                           │                   │
                           ▼                   ▼
                   ┌─────────────┐    ┌─────────────┐
                   │Fill Details │───▶│Submit &     │
                   │(Title, Desc,│    │Publish      │
                   │Price, etc.) │    │             │
                   └─────────────┘    └─────────────┘
```

## 4. Wishlist Management Flow

### Add/Remove from Wishlist
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Listing Card │───▶│Heart Icon   │───▶│Wishlist     │
│             │    │Toggle       │    │Updated      │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │
       ▼                   ▼
┌─────────────┐    ┌─────────────┐
│Visual       │    │Provider     │
│Feedback     │    │State Update │
└─────────────┘    └─────────────┘
```

### View Wishlist
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Profile/Menu │───▶│Wishlist     │───▶│Listing      │
│Wishlist     │    │Screen       │    │Detail       │
└─────────────┘    └─────────────┘    └─────────────┘
                           │
                           ▼
                   ┌─────────────┐
                   │Empty State  │
                   │(If no items)│
                   └─────────────┘
```

## 5. Admin Panel Flow (Admin Users Only)

### Admin Access
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Profile      │───▶│Admin Panel  │───▶│Manage       │
│Screen       │    │Button       │    │Listings     │
└─────────────┘    └─────────────┘    └─────────────┘
                           │                   │
                           ▼                   ▼
                   ┌─────────────┐    ┌─────────────┐
                   │Initialize   │    │View All     │
                   │Sample Data  │    │Listings     │
                   └─────────────┘    └─────────────┘
```

## 6. Professional Services Flow

### Browse Professionals
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Home Screen  │───▶│Professionals│───▶│Professional │
│Professionals│    │List         │    │Detail       │
│Button       │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘
                           │                   │
                           ▼                   ▼
                   ┌─────────────┐    ┌─────────────┐
                   │Search/Filter│    │Contact      │
                   │Professionals│    │Professional │
                   └─────────────┘    └─────────────┘
```

## 7. Error Handling and Edge Cases

### Network Error Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│User Action  │───▶│Network      │───▶│Error        │
│             │    │Request      │    │Message      │
└─────────────┘    └─────────────┘    └─────────────┘
                           │                   │
                           ▼                   ▼
                   ┌─────────────┐    ┌─────────────┐
                   │Retry        │    │Fallback     │
                   │Mechanism    │    │Content      │
                   └─────────────┘    └─────────────┘
```

### Authentication Error Flow
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Protected    │───▶│Auth Check   │───▶│Redirect to  │
│Action       │    │Failed       │    │Login        │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 8. Data Synchronization Flow

### Real-time Updates
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Firestore    │───▶│Provider     │───▶│UI Update    │
│Change       │    │Listener     │    │             │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Offline Handling
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│User Action  │───▶│Check        │───▶│Queue for    │
│(Offline)    │    │Connectivity │    │Later Sync   │
└─────────────┘    └─────────────┘    └─────────────┘
                           │
                           ▼
                   ┌─────────────┐
                   │Show Offline │
                   │Indicator    │
                   └─────────────┘
```

## Key User Journey Insights

1. **Onboarding**: Simple Google Sign-in or guest mode for immediate access
2. **Discovery**: Multiple ways to find listings (search, categories, browse)
3. **Engagement**: Easy wishlist management and sharing capabilities
4. **Content Creation**: Streamlined listing creation process
5. **Administration**: Dedicated admin tools for content management
6. **Professional Services**: Separate flow for service providers

## Navigation Patterns

- **Bottom Navigation**: Not used - relies on drawer/menu navigation
- **Hierarchical Navigation**: Clear parent-child relationships
- **Modal Navigation**: Used for forms and detailed views
- **Tab Navigation**: Used within specific screens for content organization
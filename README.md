# User Application – Where Is My Bus

## Overview

The User App is the consumer-facing application of the Smart Bus Tracking System.
It allows commuters to discover buses, track them live, and visualize routes based on their journey requirements.

Unlike the Driver App (data producer) and Admin App (control plane), the User App is read-only, focused purely on discovery, filtering, and real-time visualization.

---

## Core Responsibilities
- User authentication
- Journey-based bus discovery
- Live bus tracking
- Route visualization
- Permission-aware visibility
- Real-time updates without manual refresh

---

## Feature Breakdown

### User Authentication
- Users can:
  - Register a new account
  - Log in using existing credentials
- Authentication handled via Firebase Authentication

This ensures:
- Secure access
- User-specific sessions
- Easy scalability

---

### Journey-Based Bus Search (Key Feature)

Users enter:
- Starting point
- Ending point

The app then filters buses using route intelligence, not just proximity.

A bus is shown only if **all** of the following conditions are met:

  1. The bus route contains the start point
  2. The route contains the end point
  3. The bus has not yet passed the user’s starting point
  4. The driver is currently allowed to share location

This prevents:
- Showing irrelevant buses
- Showing buses already past the user

---

### Live Bus Tracking

- Displays:
  - All eligible buses on the map
  - Real-time location updates

- Location data comes directly from Firestore, updated by the Driver App

No polling.

No refresh button.

Pure real-time streaming.

---

### Route Visualization

- On selecting a bus:
  - Full route is drawn on the map
  - Stops are clearly visible
- Routes are:
  - Stored as List<LatLng> in Firestore
  - Rendered using Google Maps polylines

Note:

Google Directions API is intentionally not used to avoid quota and billing constraints.

---

### Permission-Aware Visibility

If Admin revokes a driver’s permission:
- That bus immediately disappears from the User App
- No stale data
- No cached visibility

This is controlled using:
```
isAllowed = true / false
```

---

## App Architecture

### State Management

The User App follows BLoC architecture to handle complex filtering and real-time updates cleanly.

Primary BLoCs:
- SplashBloc – initial auth check
- LoginBloc – user authentication
- SignUpBloc – registration flow
- SearchBloc – journey-based filtering
- HomeBloc – map & live tracking

This provides:
- Separation of concerns
- Predictable state transitions
- Scalable feature additions

---

### Firebase Integration

Firebase services used:
- Firebase Authentication
- Cloud Firestore

Firestore acts as:
- Source of truth for:
  - Bus routes
  - Driver locations
  - Permissions
- Real-time data stream provider

---

### Folder Structure (lib)

```
lib/
│
├── GlobalVariables/
│   └── Variables.dart
│
├── GlobalWidgets/
│   ├── CustomBigElevatedButton.dart
│   ├── CustomBigText.dart
│   ├── CustomSearchBar.dart
│   ├── CustomSmallBoldText.dart
│   ├── CustomSmallText.dart
│   ├── CustomTextFiledWithIcon.dart
│   ├── CustomTextFormField.dart
│   ├── CustomTextFormFieldWithIcon.dart
│   └── FullWidthTextField.dart
│
├── home/
│   ├── bloc/
│   │   ├── home_bloc.dart
│   │   ├── home_event.dart
│   │   └── home_state.dart
│   └── view/
│       └── home.dart
│
├── login/
│   ├── bloc/
│   │   ├── login_bloc.dart
│   │   ├── login_event.dart
│   │   └── login_state.dart
│   └── view/
│       └── loginScreen.dart
│
├── splash/
│   ├── bloc/
│   │   ├── search_bloc.dart
│   │   ├── search_event.dart
│   │   └── search_state.dart
│   ├── Models/
│   │   └── BusModel.dart
│   └── view/
│       └── SearchPage.dart
│
├── signUp/
│   ├── bloc/
│   │   ├── sign_up_bloc.dart
│   │   ├── sign_up_event.dart
│   │   └── sign_up_state.dart
│   └── view/
│       └── signUp.dart
│
├── splash/
│   ├── bloc/
│   │   ├── splash_bloc.dart
│   │   ├── splash_event.dart
│   │   └── splash_state.dart
│   └── view/
│       └── splash.dart
│
├── firebase_options.dart
│
└── main.dart

```

## Setup Instructions (After Cloning)
### 1️ Firebase Setup
You must provide your own Firebase configuration:
- Add google-services.json (Android)
- Add GoogleService-Info.plist (iOS)
- Generate firebase_options.dart

These files are intentionally excluded from Git.

---

### 2️ Google Maps API Key
Add your API key via Gradle properties:

*android\gradle.properties*
```
MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
```
The app uses manifestPlaceholders to inject this securely.

----

### 3️ Permissions
Ensure the following permissions exist in AndroidManifest.xml:
- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION
- INTERNET

---

### 4️ Run the App
```
flutter clean
flutter pub get
flutter run
```

---

## Design Decisions
- Journey-based filtering, not distance-based
- Firestore as real-time stream, not REST polling
- Permission-first architecture
- No direct dependency on Driver App
- Read-only safety model for users

---

## Known Limitations
- No ETA calculation
- Routes are polyline-based (not Directions API)
- No offline support
- No push notifications

---

## Intended Users
- Daily commuters
- Public transport users
- Campus / city transport systems

---

## Related Applications
Admin App – Controls permissions, routes, and drivers
- https://github.com/denimsahu/admin.git 

Driver App – Publishes live bus location
- https://github.com/denimsahu/driver23.git

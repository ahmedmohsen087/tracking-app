# 🚚 Flowery Tracking & Driver App

A modern, real-time Flutter driver & order tracking application built with **Clean Architecture**, **BLoC/Cubit state management**, **Background Location Services**, and **Firebase Realtime Sync**.

---

## 👥 Development Team

This project was engineered and developed by:

| Developer | GitHub Profile |
| :--- | :--- |
| **AbdEl-Rahman Mohamed Shalaan** | [@AER-Shalaan](https://github.com/AER-Shalaan) |
| **Ahmed Mohsen** | [@ahmedmohsen087](https://github.com/ahmedmohsen087) |
| **Mohamed Abbas** | [@MohamedAbbas289](https://github.com/MohamedAbbas289) |
| **Mohamed Ebrahim** | [@MohamedEbrahim10](https://github.com/MohamedEbrahim10) |

---

## 🚀 Key Features

* 🔑 **Driver Authentication & Vehicle Profile**
  * Secure Login, Registration, & Password Recovery.
  * Vehicle Information management & Driver status toggle (Online / Offline).

* 📡 **Live GPS Background Tracking**
  * Real-time GPS coordinate streaming to Cloud Firestore using `flutter_background_service`.
  * High-accuracy position tracking for active delivery orders.

* 📦 **Orders Management Dashboard**
  * View pending, active, and completed delivery tasks.
  * Status transition workflow: Order Pickup -> Out for Delivery -> Delivered.
  * Customer contact options (Direct call & WhatsApp integration).

* 🗺️ **Interactive Navigation & Map**
  * Dynamic OSRM route rendering connecting driver location to destination.
  * Integrated map view with live route bounds & camera fitting.

* 🔔 **Real-time Notifications**
  * Firebase Cloud Messaging (FCM) & local notifications for immediate order dispatch alerts.

---

## 🏗️ Architecture & Tech Stack

### Architecture
The codebase adheres strictly to **Clean Architecture**:
- `Data Layer`: DTO models, Mappers, Data Sources, Repositories implementations.
- `Domain Layer`: Entities, Repository Contracts, Use Cases.
- `Presentation Layer`: Cubits/BLoCs, States, Events, Screens, Widgets.

```
lib/
├── config/                  # App DI, Firebase, Auth, Base Response/State
├── core/                    # Services, Themes, Values, Utilities & Shared Widgets
└── features/                # Feature Modules
    ├── auth/                # Driver Authentication & Password Recovery
    ├── home/                # Driver Dashboard & Order Feeds
    ├── profile/             # Driver Info & Vehicle Management
    └── tracking/            # Live GPS Tracking, Map & Order Details
```

### Tech Stack
- **Framework:** Flutter (Dart SDK ^3.12)
- **State Management:** `flutter_bloc` / `Cubit`
- **Dependency Injection:** `get_it` & `injectable`
- **Networking & API:** `dio` & `retrofit`
- **Realtime Sync & Storage:** `cloud_firestore`, `firebase_messaging`, `flutter_secure_storage`
- **Location & Background Services:** `geolocator`, `flutter_background_service`, `flutter_map`, `latlong2`

---

## ⚙️ Software Engineering Standards

All code within the repository adheres to strict software quality principles:
- **DRY (Don't Repeat Yourself):** Reusable utilities, base states, and shared widgets.
- **KISS & YAGNI:** Simple, clean, and uncluttered codebase.
- **SOLID Principles:** Single Responsibility Principle per class, Interface Segregation, Dependency Inversion.
- **Method & Widget Limits:** Methods kept under 20 lines; widget build methods under 50 lines.
- **Zero Comments Policy:** Code is self-documenting through expressive symbol naming.
- **No Hardcoded Values:** UI & domain strings localized in translation files and `AppStrings`.

---

## 💻 Getting Started

### Prerequisites
- Flutter SDK (version 3.12.0 or higher)
- Android Studio / VS Code
- Java Development Kit (JDK 17)

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/ahmedmohsen087/tracking-app.git
   cd tracking-app
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Code (Injectable / Retrofit / JSON Serializable):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the Application:**
   ```bash
   flutter run
   ```

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

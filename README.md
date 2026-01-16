# FortiFi - Personal Finance Guardian

<div align="center">

![FortiFi Logo](https://img.shields.io/badge/FortiFi-Personal%20Finance%20Guardian-blue?style=for-the-badge)

**Your finances, your device, your privacy.**

A secure, offline-first expense tracker with military-grade encryption.

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## 📱 Overview

FortiFi is a cross-platform mobile expense tracker application built with Flutter that prioritizes **privacy, security, and offline functionality**. Unlike cloud-based solutions, FortiFi stores all your financial data locally on your device with AES-256 encryption, ensuring complete data ownership and privacy.

### Key Features

- 🔒 **Military-Grade Encryption**: AES-256 encryption for all sensitive financial data
- 📱 **Offline-First**: No internet connection required - all data stays on your device
- 💰 **Quick Expense Entry**: Add expenses in seconds with smart categorization
- 📊 **Budget Management**: Set category budgets with real-time tracking and alerts
- 📈 **Visual Analytics**: Charts and insights showing spending patterns
- 🌍 **Multi-Currency Support**: Track expenses in different currencies
- 📷 **Receipt Capture**: Attach photos to expenses for record-keeping
- 🔐 **Biometric Security**: Fingerprint/Face ID protection for app access
- 💾 **Encrypted Backups**: Export and restore encrypted backup files

---

## 🏗️ Architecture

FortiFi follows **Clean Architecture** principles with a clear separation of concerns:

```
lib/
├── core/                    # Core functionality shared across features
│   ├── constants/          # App-wide constants
│   ├── theme/              # Theme configuration (colors, text styles)
│   └── utils/              # Utility functions and extensions
│
├── presentation/            # UI layer
│   ├── onboarding/         # Onboarding/landing screens
│   ├── security/           # Master password setup
│   ├── dashboard/          # Main dashboard
│   ├── expense/            # Add expense screens
│   ├── core/               # Shared UI components
│   └── routes/             # Navigation configuration
│
├── domain/                  # Business logic layer (future)
│   └── entities/           # Domain entities
│
└── data/                    # Data layer (future)
    ├── repositories/        # Repository implementations
    ├── datasources/        # Local/remote data sources
    └── models/             # Data models
```

### Tech Stack

- **Framework**: Flutter 3.24+ (Dart 3.5+)
- **State Management**: Riverpod 2.x
- **Routing**: GoRouter 14.x
- **Database**: SQLite (sqflite) - encrypted columns
- **Encryption**: AES-256-CBC with PBKDF2 key derivation
- **Biometric Auth**: local_auth
- **UI**: Material Design 3 with custom dark theme
- **Typography**: Google Fonts (Inter)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.24 or higher
- Dart 3.5 or higher
- Android Studio / Xcode (for mobile development)
- CMake, Ninja, and GTK3 dev libraries (for Linux desktop)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/fortifi.git
   cd fortifi
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For mobile devices
   flutter run

   # For specific platforms
   flutter run -d android
   flutter run -d ios
   flutter run -d linux
   flutter run -d macos
   flutter run -d windows
   ```

### Linux Desktop Setup

If running on Linux, install required build dependencies:

```bash
sudo apt update
sudo apt install -y cmake ninja-build pkg-config libgtk-3-dev clang lld-18
```

---

## 📖 Project Structure

### Screens Implemented

1. **Onboarding Screen** (`/onboarding`)
   - Welcome screen with security messaging
   - "Get Started" and "Sign In" options

2. **Security Screen** (`/master-password-setup`)
   - Master password creation
   - Password strength indicator
   - Face ID toggle
   - Encryption information

3. **Dashboard Screen** (`/dashboard`)
   - Total spent this month
   - Budget progress tracking
   - Active budgets overview
   - Recent activity feed
   - Bottom navigation

4. **New Expense Screen** (`/add-expense`)
   - Numeric keypad for amount entry
   - Category selection
   - Description input
   - Receipt camera integration (UI ready)

### Navigation Flow

```
Onboarding → Security Setup → Dashboard
                              ↓
                         Add Expense
```

---

## 🔐 Security Features

### Encryption

- **Algorithm**: AES-256-CBC
- **Key Derivation**: PBKDF2 with 100,000+ iterations
- **Encrypted Fields**: Expense amounts, descriptions, budget amounts
- **Key Storage**: Platform keychain (iOS Keychain, Android Keystore)

### Authentication

- Master password (minimum 12 characters, complexity requirements)
- Biometric authentication (Touch ID/Face ID/Fingerprint)
- Auto-lock after inactivity (configurable)
- Failed login attempt tracking

### Privacy

- Zero telemetry/analytics
- No cloud sync (all data stays on device)
- No third-party SDKs with data collection
- Screenshot blocking on sensitive screens (optional)

---

## 🗄️ Database Schema

The app uses SQLite with encrypted columns for sensitive data:

- **app_settings**: Master password hash, app configuration
- **categories**: Expense/income categories with icons and colors
- **expenses**: Encrypted expense records
- **budgets**: Encrypted budget limits and tracking
- **recurring_expenses**: Automated recurring transactions
- **analytics_cache**: Performance-optimized analytics data

---

## 🛠️ Development

### Running Tests

```bash
flutter test
```

### Building for Release

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Linux
flutter build linux --release
```

### Code Quality

The project uses `flutter_lints` for code quality. Run analysis:

```bash
flutter analyze
```

---

## 📝 Roadmap

### MVP Features (Completed ✅)
- [x] Onboarding screen
- [x] Master password setup
- [x] Dashboard with spending overview
- [x] Add expense screen
- [x] Category selection
- [x] Basic UI/UX

### Upcoming Features
- [ ] Database implementation with encryption
- [ ] Budget management screens
- [ ] Analytics and insights screens
- [ ] Receipt capture and storage
- [ ] Recurring expenses
- [ ] Export/backup functionality
- [ ] Settings screen
- [ ] Login screen
- [ ] Biometric authentication integration

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for state management
- Material Design 3 for UI guidelines

---

## 📧 Contact

For questions, suggestions, or support, please open an issue on GitHub.

---

<div align="center">

**Built with ❤️ using Flutter**

[⭐ Star this repo](https://github.com/yourusername/fortifi) if you find it helpful!

</div>

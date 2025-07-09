# Cryptowallet-
 Details

- Flutter SDK (^3.29.2)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)


to use flutter on vscode install
sudo snap install flutter --classic

# Set up
flutter doctor

 Go to your project folder

# Install dependencies
flutter pub get

# Run the app
flutter run

# if you are on an unstable flutter use the codes below
flutter channel stable
flutter upgrade
flutter clean
flutter pub get
flutter run

 Project Structure


flutter_app/
├── android/            # Android-specific configuration
├── ios/                # iOS-specific configuration
├── lib/
│   ├── core/           # Core utilities and services
│   │   └── utils/      # Utility classes
│   ├── presentation/   # UI screens and widgets
│   │   └── splash_screen/ # Splash screen implementation
│   ├── routes/         # Application routing
│   ├── theme/          # Theme configuration
│   ├── widgets/        # Reusable UI components
│   └── main.dart       # Application entry point
├── assets/             # Static assets (images, fonts, etc.)
├── pubspec.yaml        # Project dependencies and configuration
└── README.md           # Project documentation
Adding Routes

To add new routes to the application, update the `lib/routes/app_routes.dart` file:

dart
import 'package:flutter/material.dart';
import 'package:package_name/presentation/home_screen/home_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    // Add more routes as needed
  }
}
```
Theme

This project includes a comprehensive theming system with both light and dark themes:
´´´
dart
// Access the current theme
ThemeData theme = Theme.of(context);

// Use theme colors
Color primaryColor = theme.colorScheme.primary;

The theme configuration includes:
- Color schemes for light and dark modes
- Typography styles
- Button themes
- Input decoration themes
- Card and dialog themes

Responsive Design

The app is built with responsive design using the Sizer package:

dart
// Example of responsive sizing
Container(
  width: 50.w, // 50% of screen width
  height: 20.h, // 20% of screen height
  child: Text('Responsive Container'),
)

Deployment

Build the application for production:

Terminal
For Android
flutter build apk --release

For iOS
flutter build ios --release


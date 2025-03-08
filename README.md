<p align="center">
  <img src="/assets/Logo.png" width="50%"/>
</p>

# iOS SwiftUI Firebase Login Template

A modern, well-architected template for implementing Firebase Authentication in SwiftUI apps. This template includes support for Email/Password, Google, and Apple Sign-In authentication methods.

## Features

- 🔐 Multiple authentication methods:
  - Email/Password authentication
  - Google Sign-In
  - Apple Sign-In
- 🧰 Modern Swift architecture:
  - Repository pattern
  - MVVM architecture
  - Swift async/await concurrency
- 📲 Full-featured authentication flow:
  - User registration
  - Login
  - Password reset
  - Email verification
  - Profile management
- 🎨 Clean, modern UI built with SwiftUI

## Project Structure

The project follows a clean architecture approach:

- **Views**: SwiftUI views for login, home, and user management
- **ViewModels**: Logic and state management for views
- **Repository**: Data access layer that handles Firebase authentication operations
- **Models**: Data structures and domain models
- **Extensions**: Utility extensions for SwiftUI components

## Getting Started

### Prerequisites

- Xcode 14.0+
- iOS 16.0+
- Swift 5.7+
- CocoaPods or Swift Package Manager

### Installation

1. Clone the repository
2. Set up your Firebase project:
   - Create a new project in the [Firebase Console](https://console.firebase.google.com/)
   - Add an iOS app to your Firebase project
   - Download the `GoogleService-Info.plist` file and add it to your Xcode project
   - Enable the authentication methods you want to use (Email/Password, Google, Apple)

3. Install Firebase SDK via Swift Package Manager:
   - In Xcode, go to File > Swift Packages > Add Package Dependency
   - Enter the Firebase iOS SDK URL: `https://github.com/firebase/firebase-ios-sdk.git`
   - Select the Firebase products you need: Auth, Analytics, etc.

4. Configure Google Sign-In (if using):
   - Follow the [Google Sign-In documentation](https://firebase.google.com/docs/auth/ios/google-signin) to set up your app
   - Create a Google Cloud project and configure OAuth consent screen
   - Create OAuth 2.0 client IDs for your iOS app
   - Add the `GoogleService-Info.plist` file to your Xcode project
   - Ensure the URL schemes are properly configured in your Info.plist

5. Configure Sign in with Apple (if using):
   - In the [Apple Developer Portal](https://developer.apple.com/account):
     - Go to "Certificates, Identifiers & Profiles"
     - Select "Identifiers" and register a new identifier (App ID) if needed
     - Enable "Sign in with Apple" capability for this App ID
     - Create a Services ID (under Identifiers) specifically for Sign in with Apple
     - Configure the Services ID with your domain and return URL
     - Register a domain and verify ownership
   - In Xcode:
     - Add the "Sign in with Apple" capability to your target
     - Ensure your team and provisioning profile are correctly set up
   - In Firebase Console:
     - Go to Authentication > Sign-in method
     - Enable Apple provider
     - Configure with your Services ID
     - Add the Firebase OAuth redirect URL to your Services ID configuration in Apple Developer Portal

### Configuration

1. Update the bundle identifier to match the one you registered with Firebase
2. Add your `GoogleService-Info.plist` file to the project root
3. Configure your app in Apple Developer Portal:
   - Sign in to the [Apple Developer Portal](https://developer.apple.com/account)
   - Go to "Certificates, Identifiers & Profiles"
   - Select "Identifiers" and find your app (or create it if needed)
   - Enable "Sign in with Apple" capability
   - If needed, create a new App Group and enable it for your app
   - Update your app's entitlements in Xcode to match these settings
4. Configure Sign in with Apple in Xcode:
   - Select your project in Xcode
   - Go to the "Signing & Capabilities" tab
   - Ensure your Team is selected and bundle ID matches
   - Click "+ Capability" and add "Sign in with Apple"
   - Also add the "Keychain Sharing" capability if needed
5. Configure Firebase Auth with Apple:
   - In the Firebase Console, go to Authentication > Sign-in method
   - Enable Apple provider
   - Enter your Apple Services ID (can be created in Apple Developer Portal)
   - Configure the OAuth redirect URI in both Firebase and Apple Developer Portal
6. Run the project

## Usage

This template provides a ready-to-use authentication system. The main components are:

- `AuthRepository`: Handles all Firebase authentication operations
- `AuthenticationViewModel`: Manages authentication state and provides methods for views
- `Login.swift`: The login and registration screen
- `Home.swift`: The authenticated home screen

## Customization

You can customize the template to fit your needs:

- Update the UI by modifying the SwiftUI views
- Add additional authentication methods by extending the repository
- Customize error handling by updating the `AuthError` enum

## Architecture Details

### Repository Pattern

The template uses a repository pattern to abstract Firebase authentication operations:

```swift
protocol AuthRepositoryProtocol {
    func signInWithEmail(email: String, password: String) async throws -> User
    func signUpWithEmail(email: String, password: String) async throws -> User
    // Other methods...
}
```

This provides several benefits:
- Separation of concerns
- Easier unit testing through dependency injection
- Centralized error handling

### ViewModels

ViewModels using the MVVM pattern to manage state and business logic:

```swift
class AuthenticationViewModel: ObservableObject {
    @Published var state: SignInState = .signedOut
    @Published var error: AuthError?
    // Properties and methods...
}
```

### Async/Await Concurrency

Modern Swift concurrency is used throughout the codebase:

```swift
func signIn() {
    Task {
        await authViewModel.login(with: .emailAndPassword(
            email: email,
            password: password
        ))
    }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

Special thanks goes out to Joseph Hinkle and his repo https://github.com/joehinkle11/Login-with-Apple-Firebase-SwiftUI which was my main reference for this project.

## Contact

If you have any questions or feedback, please open an issue in the repository.

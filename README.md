<p align="center">
  <img src="https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/firebase.png"/>
</p>

# Firebase Authentication Boilerplate for iOS

Swift iOS project template that handles authentication with email/password, Sign in with Google, and Sign in with Apple. It contains iOS 16 SwiftUI features such as the new Navigation system, and the code is architected in a way that is scalable if you want to build onto this boilerplate.

# Setup
1. Copy the entirety of this project folder to your repo 
2. Add the following packages to your project either via Swift Package Manager (SPM) or CocoaPods. This example uses SPM.

![Dependencies](https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/Setup_Dependencies.png)

3. Create a new project in Firebase [Firebase Setup for iOS](https://firebase.google.com/docs/ios/setup?authuser=0). You will need the auto-generated GoogleService-Info.plist file to compile this project. Make sure to follow Firebase's setup intructions thoroughly.
4. Add Sign in with Google and Sign in with Apple as valid Sign-In Methods on your Firebase project once setup (under the Authentication section > Sign-In Methods tab)

![Sign-In Methods](https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/Setup_SignInMethods.png)

## Sign in with Google
1. Add GIDSignIn URL in Info.plist

![Info.plist](https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/infoPList.png)

2. Add custom URL schemes to your Xcode project:
- Open your project configuration: double-click the project name in the left tree view. Select your app from the TARGETS section, then select the Info tab, and expand the URL Types section.
- Click the + button, and add a URL scheme for your reversed client ID. To find this value, open the GoogleService-Info.plist configuration file, and look for the REVERSED_CLIENT_ID key. Copy the value of that key, and paste it into the URL Schemes box on the configuration page. Leave the other fields blank.
- Documentation reference: [Get started with Google Sign-In for iOS](https://developers.google.com/identity/sign-in/ios/start-integrating)

## Sign in with Apple
1. In your Apple Developer Account, add a new Identifier to your project. Then, add Sign In with Apple to your app's id configuration at https://developer.apple.com/account/resources/identifiers/list

![AppleDevSetup](https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/AppleDeveloperSetup.png)

2. Add Sign in with Apple to your project's capabilities. NOTE: I also added the Keychain Sharing capability because it got rid of some console warnings for me, but functionality for Apple Keychain is not included in this boilerplate.

![Capabilities](https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/Setup_Capabilities.png)

## References
Special thanks goes out to Joseph Hinkle and his repo https://github.com/joehinkle11/Login-with-Apple-Firebase-SwiftUI which was my main reference for this project.

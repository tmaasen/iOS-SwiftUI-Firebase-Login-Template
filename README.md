<p align="center">
  <img src="https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/firebase.png"/>
</p>

# Firebase Authentication Boilerplate for iOS

Swift iOS project template that handles authentication with email/password, Sign in with Google, and Sign in with Apple. It contains iOS 16 SwiftUI features such as the new Navigation system, and the code is architected in a way that is scalable if you want to build onto this boilerplate.

# Setup
1. Clone this repo, or copy the entirety of this project folder to your repo https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/tree/main/iOS-SwiftUI-Firebase-Login-Template.
2. Change the Bundle ID of the project to your own Bundle ID so you don't have a duplicate.
3. The following dependencies should already be in added to your project via Swift Package Manager (SPM). If you want to use CocoaPods, add the below dependencies to your PodFile.

![Dependencies](https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/Setup_Dependencies.png)

4. Create a new project in Firebase, and then add a new Apple App [Firebase Setup for iOS](https://firebase.google.com/docs/ios/setup?authuser=0). You will need the auto-generated GoogleService-Info.plist file to run this project. [Link to create new Firebase project](https://console.firebase.google.com/)
5. Add Email / Password, Sign in with Google, and Sign in with Apple Sign-In Methods on your Firebase project once setup (under Authentication > Sign-In Methods tab)

![Sign-In Methods](https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/Setup_SignInMethods.png)

## Sign in with Google
1. Add GIDClientID under Targets > Info > Custom macOS Application Target Properties in XCode
- Hover over the list of existing properties, right click, Add New Row. Let the key = "GIDClientID", tab over to the value cell, and paste in the CLIENT_ID from your GoogleService-Info.plist configuration file.
2. Add custom URL scheme to your Xcode project:
- Open your project configuration: click the project name in the left tree view. Select your app from the TARGETS section, then select the Info tab, and expand the URL Types section.
- Click the + button, and add a URL scheme for your reversed client ID. To find this value, open the GoogleService-Info.plist configuration file, and look for the REVERSED_CLIENT_ID key. Copy the value of that key, and paste it into the URL Schemes box on the configuration page. Leave the other fields blank.
- Documentation reference: [Get started with Google Sign-In for iOS](https://developers.google.com/identity/sign-in/ios/start-integrating#configure_app_project)
![Google Config](https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/GoogleConfig.png)

## Sign in with Apple
1. In your Apple Developer Account, add a new Identifier to your project. Then, add Sign In with Apple to your app's id configuration at https://developer.apple.com/account/resources/identifiers/list

![AppleDevSetup](https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/AppleDeveloperSetup.png)

2. Add Sign in with Apple to your project's capabilities. NOTE: I also added the Keychain Sharing capability because it got rid of some console warnings for me, but functionality for Apple Keychain is not included in this boilerplate.

![Capabilities](https://github.com/tmaasen/iOS-SwiftUI-Firebase-Login-Template/blob/main/Setup_Capabilities.png)

## References
Special thanks goes out to Joseph Hinkle and his repo https://github.com/joehinkle11/Login-with-Apple-Firebase-SwiftUI which was my main reference for this project.

If you want to configure your Firebase App further, go to [Google Cloud Console](https://console.cloud.google.com/) and you should find the project you just created in Firebase. This can be helpful for creating API restrictions if you so desire.

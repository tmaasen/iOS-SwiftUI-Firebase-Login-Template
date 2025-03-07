//
//  AuthenticationViewModel.swift
//
//

import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

class AuthenticationViewModel: NSObject, ObservableObject {
    
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    @Published var errorMessage: String = ""
    @Published var signInMethod: String = "Unknown"
    @Published var restoreGoogleSignIn: Bool = false
    fileprivate var currentNonce: String?
    
    override init() {
        super.init()
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            restoreGoogleSignIn = true
        }
    }
    
    /// Master login function that will handle multiple login types depending on what the user chooses
    func login(with loginOption: LoginOption) async {
        switch loginOption {
        case .signInWithApple:
            signInWithApple()
        case let .emailAndPassword(email, password):
            await signInWithEmail(email: email, password: password)
        case .signInWithGoogle:
            await signInWithGoogle()
        }
    }
    
    /**
     Sign in with email and password with Firebase Authentication.
     - Parameter email
     - Parameter password
     - Returns: Completion handler.
     */
    @MainActor
    func signInWithEmail(email: String, password: String) async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            self.state = .signedIn
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            self.signInMethod = "Email / Password"
        }
        catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    /**
     Sign up with email and password with Firebase Authentication. Also signs in the user once the account is created.
     - Parameter email
     - Parameter password
     - Returns: Completion handler.
     */
    @MainActor
    func signUp(email: String, password: String) async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            self.state = .signedIn
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            self.signInMethod = "Email / Password"
        }
        catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    /**
     Sign in the user with Firebase Authentication via Sign In with Google. Requires a Google account. Also handles the restoration of a user's session.
     - Parameter email
     - Parameter password
     - Returns: Completion handler.
     */
    @MainActor
    func signInWithGoogle() async {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            do {
                let result = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
                print("Restoring previous session")
                await authenticateGoogleUser(for: result)
            }
            catch {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
            }
        } else {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            do {
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                await authenticateGoogleUser(for: result.user)
            }
            catch {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Function that pairs with signInWithGoogle() and completes the authentication of a Google user.
    @MainActor
    func authenticateGoogleUser(for user: GIDGoogleUser?) async {

        guard let idToken = user?.idToken?.tokenString else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user?.accessToken.tokenString ?? "")
        
        do {
            try await Auth.auth().signIn(with: credential)
            self.state = .signedIn
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            self.signInMethod = "Google"
        }
        catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    /// Function that signs in a user via the Sign in with Apple configuration
    func signInWithAppleHandler(credential: OAuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
                print(error?.localizedDescription as Any)
                self.errorMessage = error?.localizedDescription ?? "Error"
            } else {
                self.state = .signedIn
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.signInMethod = "Apple"
            }
        }
    }
    
    /// Function that will sign out the user for all authentication methods
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            self.state = .signedOut
            restoreGoogleSignIn = false
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        } catch {
            print(error.localizedDescription)
        }
    }
}

/// Extension that contains functions necessary for Sign in with Apple via Google Firebase
extension AuthenticationViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func signInWithApple() {
        let nonce = String.randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = scenes?.windows.first else { return UIWindow() }
        return window
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            self.signInWithAppleHandler(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple error: \(error)")
    }
    
}

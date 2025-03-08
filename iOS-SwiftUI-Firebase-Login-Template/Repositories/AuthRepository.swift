//
//  AuthRepository.swift
//  iOS-SwiftUI-Firebase-Login-Template
//
//  Created by Tanner Maasen on 3/7/25.
//

import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

// Authentication repository protocol
protocol AuthRepositoryProtocol {
	func signInWithEmail(email: String, password: String) async throws -> User
	func signUpWithEmail(email: String, password: String) async throws -> User
	func signInWithGoogle() async throws -> User
	func signInWithApple(onCompletion: @escaping (Result<User, Error>) -> Void)
	func signOut() async throws
	func sendPasswordReset(email: String) async throws
	func sendEmailVerification() async throws
	func getCurrentUser() -> User?
	func updateUserProfile(displayName: String?, photoURL: URL?) async throws
	func deleteAccount() async throws
	func reauthenticate(email: String, password: String) async throws
	func updateEmail(email: String) async throws
	func updatePassword(password: String) async throws
}

// Implementation of the repository
class FirebaseAuthRepository: NSObject, AuthRepositoryProtocol {
	private var currentNonce: String?
	private var appleSignInCompletion: ((Result<User, Error>) -> Void)?
	
	func signInWithEmail(email: String, password: String) async throws -> User {
		do {
			let result = try await Auth.auth().signIn(withEmail: email, password: password)
			return result.user
		} catch {
			throw AuthError.signInFailed(description: error.localizedDescription)
		}
	}
	
	func signUpWithEmail(email: String, password: String) async throws -> User {
		do {
			let result = try await Auth.auth().createUser(withEmail: email, password: password)
			// Send email verification
			try await result.user.sendEmailVerification()
			return result.user
		} catch {
			throw AuthError.signUpFailed(description: error.localizedDescription)
		}
	}
	
	func signInWithGoogle() async throws -> User {
		// Check for existing sign-in
		if GIDSignIn.sharedInstance.hasPreviousSignIn() {
			do {
				let result = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
				return try await authenticateGoogleUser(for: result)
			} catch {
				throw AuthError.signInFailed(description: error.localizedDescription)
			}
		} else {
			// Get the root view controller
			guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
				  let rootViewController = await windowScene.windows.first?.rootViewController else {
				throw AuthError.noRootViewController
			}
			
			do {
				let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
				return try await authenticateGoogleUser(for: result.user)
			} catch {
				throw AuthError.signInFailed(description: error.localizedDescription)
			}
		}
	}
	
	private func authenticateGoogleUser(for user: GIDGoogleUser?) async throws -> User {
		guard let idToken = user?.idToken?.tokenString else {
			throw AuthError.invalidCredential
		}
		
		let credential = GoogleAuthProvider.credential(
			withIDToken: idToken,
			accessToken: user?.accessToken.tokenString ?? ""
		)
		
		do {
			let result = try await Auth.auth().signIn(with: credential)
			return result.user
		} catch {
			throw AuthError.signInFailed(description: error.localizedDescription)
		}
	}
	
	func signInWithApple(onCompletion: @escaping (Result<User, Error>) -> Void) {
		self.appleSignInCompletion = onCompletion
		
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
	
	func signOut() async throws {
		// Sign out from Google if applicable
		GIDSignIn.sharedInstance.signOut()
		
		do {
			try Auth.auth().signOut()
		} catch {
			throw AuthError.signOutFailed(description: error.localizedDescription)
		}
	}
	
	func sendPasswordReset(email: String) async throws {
		do {
			try await Auth.auth().sendPasswordReset(withEmail: email)
		} catch {
			throw AuthError.passwordResetFailed(description: error.localizedDescription)
		}
	}
	
	func sendEmailVerification() async throws {
		guard let user = Auth.auth().currentUser else {
			throw AuthError.userNotFound
		}
		
		try await user.sendEmailVerification()
	}
	
	func getCurrentUser() -> User? {
		return Auth.auth().currentUser
	}
	
	func updateUserProfile(displayName: String?, photoURL: URL?) async throws {
		guard let user = Auth.auth().currentUser else {
			throw AuthError.userNotFound
		}
		
		let changeRequest = user.createProfileChangeRequest()
		
		if let displayName = displayName {
			changeRequest.displayName = displayName
		}
		
		if let photoURL = photoURL {
			changeRequest.photoURL = photoURL
		}
		
		try await changeRequest.commitChanges()
	}
	
	func deleteAccount() async throws {
		guard let user = Auth.auth().currentUser else {
			throw AuthError.userNotFound
		}
		
		try await user.delete()
	}
	
	func reauthenticate(email: String, password: String) async throws {
		guard let user = Auth.auth().currentUser else {
			throw AuthError.userNotFound
		}
		
		let credential = EmailAuthProvider.credential(withEmail: email, password: password)
		try await user.reauthenticate(with: credential)
	}
	
	func updateEmail(email: String) async throws {
		guard let user = Auth.auth().currentUser else {
			throw AuthError.userNotFound
		}
		
		try await user.sendEmailVerification(beforeUpdatingEmail: email)
	}
	
	func updatePassword(password: String) async throws {
		guard let user = Auth.auth().currentUser else {
			throw AuthError.userNotFound
		}
		
		try await user.updatePassword(to: password)
	}
}

// Extension to handle Apple Sign In delegate methods
extension FirebaseAuthRepository: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			  let window = windowScene.windows.first else {
			return UIWindow()
		}
		return window
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
			  let nonce = currentNonce,
			  let appleIDToken = appleIDCredential.identityToken,
			  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
			appleSignInCompletion?(.failure(AuthError.invalidCredential))
			return
		}
		
		// Initialize a Firebase credential
		let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)
		
		// Sign in with Firebase
		Task {
			do {
				let result = try await Auth.auth().signIn(with: credential)
				
				// Update user display name if provided and not already set
				if let fullName = appleIDCredential.fullName,
				   let user = Auth.auth().currentUser,
				   user.displayName == nil || user.displayName?.isEmpty == true {
					
					let displayName = [fullName.givenName, fullName.familyName]
						.compactMap { $0 }
						.joined(separator: " ")
					
					if !displayName.isEmpty {
						let changeRequest = user.createProfileChangeRequest()
						changeRequest.displayName = displayName
						try await changeRequest.commitChanges()
					}
				}
				
				appleSignInCompletion?(.success(result.user))
			} catch {
				appleSignInCompletion?(.failure(AuthError.signInFailed(description: error.localizedDescription)))
			}
		}
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		appleSignInCompletion?(.failure(error))
	}
}

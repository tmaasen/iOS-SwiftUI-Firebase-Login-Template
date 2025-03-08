//
//  AuthError.swift
//  iOS-SwiftUI-Firebase-Login-Template
//
//  Created by Tanner Maasen on 3/7/25.
//

import Foundation

enum AuthError: Error, LocalizedError {
	case signInFailed(description: String)
	case signUpFailed(description: String)
	case signOutFailed(description: String)
	case userNotFound
	case invalidCredential
	case noRootViewController
	case emailNotVerified
	case passwordResetFailed(description: String)
	case updateProfileFailed(description: String)
	case deleteAccountFailed(description: String)
	case reauthenticationFailed(description: String)
	case updateEmailFailed(description: String)
	case updatePasswordFailed(description: String)
	
	var errorDescription: String? {
		switch self {
		case .signInFailed(let description):
			return "Sign in failed: \(description)"
		case .signUpFailed(let description):
			return "Sign up failed: \(description)"
		case .signOutFailed(let description):
			return "Sign out failed: \(description)"
		case .userNotFound:
			return "User not found"
		case .invalidCredential:
			return "Invalid credentials"
		case .noRootViewController:
			return "Could not find root view controller"
		case .emailNotVerified:
			return "Email not verified"
		case .passwordResetFailed(let description):
			return "Password reset failed: \(description)"
		case .updateProfileFailed(let description):
			return "Failed to update profile: \(description)"
		case .deleteAccountFailed(let description):
			return "Failed to delete account: \(description)"
		case .reauthenticationFailed(let description):
			return "Reauthentication required: \(description)"
		case .updateEmailFailed(let description):
			return "Failed to update email: \(description)"
		case .updatePasswordFailed(let description):
			return "Failed to update password: \(description)"
		}
	}
}

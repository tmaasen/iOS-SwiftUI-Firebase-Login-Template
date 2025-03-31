//
//  Login.swift
//
//

import SwiftUI
import AuthenticationServices

struct Login: View {
	@State private var email: String = ""
	@State private var password: String = ""
	@State private var showResetPasswordAlert: Bool = false
	@State private var resetPasswordEmail: String = ""
	@State private var showPasswordResetConfirmation: Bool = false
	@FocusState private var emailIsFocused: Bool
	@FocusState private var passwordIsFocused: Bool
	@EnvironmentObject var authViewModel: AuthenticationViewModel
	
	var body: some View {
		VStack(spacing: 0) {
			Spacer()
			
			// Logo and Title
			VStack(spacing: 5) {
				Image("FirebaseIcon")
					.resizable()
					.scaledToFit()
					.frame(width: 80, height: 80)
				
				Text("Login with Firebase Example")
					.foregroundColor(.Orange)
					.font(.system(size: 28))
					.multilineTextAlignment(.center)
			}
			.padding(.bottom, 40)
			
			// Form Fields
			VStack(spacing: 0) {
				TextField("Email Address", text: $email)
					.withLoginStyles()
					.textContentType(.emailAddress)
					.keyboardType(.emailAddress)
					.submitLabel(.next)
					.focused($emailIsFocused)
					.onSubmit {
						emailIsFocused = false
						passwordIsFocused = true
					}
				
				SecureField("Password", text: $password)
					.withSecureFieldStyles()
					.submitLabel(.go)
					.focused($passwordIsFocused)
					.onSubmit {
						signIn()
					}
				
				// Forgot Password Link
				HStack {
					Spacer()
					Button {
						showResetPasswordAlert = true
					} label: {
						Text("Forgot Password?")
							.foregroundColor(.Orange)
							.font(.footnote)
					}
				}
				.padding(.bottom, 20)
				
				// Error Display
				if let error = authViewModel.error {
					Text(error.localizedDescription)
						.font(.footnote)
						.foregroundColor(.red)
						.padding(.bottom, 12)
						.transition(.opacity)
				}
				
				// Sign In Button
				Button(action: signIn) {
					if authViewModel.isLoading {
						ProgressView()
							.tint(.white)
					} else {
						Text("Sign In")
							.foregroundColor(.white)
							.font(.headline)
							.frame(maxWidth: .infinity)
							.padding()
							.background(Color.Orange)
							.cornerRadius(10)
					}
				}
				.disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
				.padding(.bottom, 15)
				
				// Sign Up Button
				Button(action: signUp) {
					Text("Sign Up")
						.foregroundColor(.white)
						.font(.headline)
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.Orange)
						.cornerRadius(10)
				}
				.disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
			}
			.padding(.horizontal)
			
			// OR Divider
			HStack {
				VStack { Divider() }
				Text("OR")
					.font(.footnote)
					.foregroundColor(.secondary)
					.padding(.horizontal, 8)
				VStack { Divider() }
			}
			.padding(.vertical, 30)
			.padding(.horizontal)
			
			// Social Login Options - Centered in remaining space
			Spacer()
			
			SocialLogins()
			
			Spacer()
		}
		.padding(.horizontal)
		.alert("Reset Password", isPresented: $showResetPasswordAlert) {
			TextField("Enter your email", text: $resetPasswordEmail)
				.autocapitalization(.none)
				.keyboardType(.emailAddress)
			
			Button("Cancel", role: .cancel) {}
			
			Button("Reset") {
				Task {
					await authViewModel.sendPasswordReset(email: resetPasswordEmail)
					showPasswordResetConfirmation = true
				}
			}
		} message: {
			Text("Enter your email address and we'll send you a link to reset your password.")
		}
		.alert("Password Reset Email Sent", isPresented: $showPasswordResetConfirmation) {
			Button("OK", role: .cancel) {}
		} message: {
			Text("Check your email for a link to reset your password.")
		}
	}
	
	// Helper methods
	private func signIn() {
		Task {
			await authViewModel.login(with: .emailAndPassword(
				email: email,
				password: password
			))
		}
	}
	
	private func signUp() {
		Task {
			do {
				try await authViewModel.signUp(
					email: email,
					password: password
				)
			} catch {
				// Error handling is already done in the ViewModel
			}
		}
	}
}

struct Login_Previews: PreviewProvider {
	static var previews: some View {
		Login()
			.environmentObject(AuthenticationViewModel(
				authRepository: FirebaseAuthRepository()
			))
	}
}

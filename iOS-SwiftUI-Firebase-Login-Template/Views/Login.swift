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
		VStack {
			// Logo and Title
			Image("FirebaseIcon")
				.resizable()
				.scaledToFit()
				.frame(width: 80, height: 80)
			
			Text("Login with Firebase Example")
				.foregroundColor(.Orange)
				.padding(.top, 15)
				.font(.system(size: 30))
				.multilineTextAlignment(.center)
			
			// Form Fields
			VStack {
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
					Button("Forgot Password?") {
						showResetPasswordAlert = true
					}
					.font(.footnote)
					.foregroundColor(.Orange)
					.padding(.bottom, 12)
				}
				
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
							.withButtonStyles()
					}
				}
				.disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
				
				// Sign Up Button
				Button(action: signUp) {
					Text("Sign Up")
						.withButtonStyles()
				}
				.disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
			}
			.padding()
			
			Spacer()
			
			// Social Login Options
			SocialLogins()
		}
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
		.onTapGesture {
			hideKeyboard()
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
			.environmentObject(AuthenticationViewModel())
	}
}

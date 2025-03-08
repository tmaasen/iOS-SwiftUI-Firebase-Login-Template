//
//  SocialLogins.swift
//
//

import SwiftUI
import AuthenticationServices

struct SocialLogins: View {
	@EnvironmentObject var authViewModel: AuthenticationViewModel
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		VStack(spacing: 15) {
			// Google Sign In
			Button {
				Task { await signInWithGoogle() }
			} label: {
				HStack {
					Image("GoogleIcon")
						.resizable()
						.frame(width: 15, height: 15)
						.font(.system(size: 22))
					
					Text("Continue with Google")
						.foregroundColor(.white)
						.font(.headline)
				}
				.frame(maxWidth: .infinity)
				.padding()
				.background(Color.black)
				.cornerRadius(10)
			}
			.padding(.horizontal)
			
			// Apple Sign In
			SignInWithAppleButton(
				.continue,
				onRequest: { request in
					request.requestedScopes = [.fullName, .email]
				},
				onCompletion: { result in
					Task { await signInWithApple() }
				}
			)
			.signInWithAppleButtonStyle(.black)
			.frame(height: 50)
			.cornerRadius(10)
			.padding(.horizontal)
		}
	}
	
	private func signInWithGoogle() async {
		await authViewModel.login(with: .signInWithGoogle)
	}
	
	private func signInWithApple() async {
		await authViewModel.login(with: .signInWithApple)
	}
}

struct SocialLogins_Previews: PreviewProvider {
    static var previews: some View {
        SocialLogins()
    }
}

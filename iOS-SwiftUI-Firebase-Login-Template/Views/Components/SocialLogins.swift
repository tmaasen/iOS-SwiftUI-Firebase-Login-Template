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
		VStack(spacing: 16) {
			// Google Sign In
			GoogleSignInButton()
				.frame(height: 44)
				.padding(.horizontal)
				.onTapGesture {
					hideKeyboard()
					Task {
						await authViewModel.login(with: .signInWithGoogle)
					}
				}
			
			// Apple Sign In
			SignInWithAppleButton(.continue, onRequest: { request in
				request.requestedScopes = [.fullName, .email]
			}, onCompletion: { result in
				hideKeyboard()
				Task {
					await authViewModel.login(with: .signInWithApple)
				}
			})
			.signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
			.frame(height: 44)
			.padding(.horizontal)
			.padding(.bottom, 20)
		}
	}
}

struct GoogleSignInButton: View {
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		
		HStack {
			Image("GoogleIcon")
				.resizable()
				.frame(width: 10, height: 10)
			
			Text("Continue with Google")
				.foregroundColor(colorScheme == .light ? .white : .black)
				.font(.system(size: 16, weight: .medium, design: .default))
		}
		.padding(.horizontal, 20)
		.padding(.vertical, 10)
		.background(
			RoundedRectangle(cornerRadius: 20)
				.fill(colorScheme == .light ? Color.black : Color.white)
		)
	}
}

struct SocialLogins_Previews: PreviewProvider {
    static var previews: some View {
        SocialLogins()
    }
}

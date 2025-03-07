//
//  SocialLogins.swift
//
//

import SwiftUI
import AuthenticationServices

struct SocialLogins: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        
        GoogleSignInButton()
            .frame(width: 210, height: 40)
            .padding(.bottom, 20)
            .onTapGesture {
                hideKeyboard()
                Task {
                    await authViewModel.login(with: .signInWithGoogle)
                    if authViewModel.state == .signedIn {
                        isAuthenticated = true
                    }
                }
            }
        
		SignInWithAppleButton(.continue) { request in
			request.requestedScopes = [.fullName, .email]
		} onCompletion: { result in
			hideKeyboard()
			Task {
				await authViewModel.login(with: .signInWithApple)
				if authViewModel.state == .signedIn {
					isAuthenticated = true
				}
			}
		}
		.signInWithAppleButtonStyle(.black)
		.frame(height: UIScreen.main.bounds.height < 680 ? 44 : 50)
		.clipShape(RoundedRectangle(cornerRadius: 12))
		.cornerRadius(20)
		.padding(.bottom, 40)
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
        SocialLogins(isAuthenticated: .constant(false))
    }
}

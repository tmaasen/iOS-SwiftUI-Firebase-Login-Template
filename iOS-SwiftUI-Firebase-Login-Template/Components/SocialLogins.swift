//
//  SocialLogins.swift
//
//

import SwiftUI

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
        
        CustomSignInWithAppleButton(colorScheme: colorScheme == .light ? "light" : "dark") {}
            .frame(width: 200, height: 40)
            .cornerRadius(20)
            .padding(.bottom, 40)
            .onTapGesture {
                hideKeyboard()
                Task {
                    await authViewModel.login(with: .signInWithApple)
                    if authViewModel.state == .signedIn {
                        isAuthenticated = true
                    }
                }
            }
    }
}

struct SocialLogins_Previews: PreviewProvider {
    static var previews: some View {
        SocialLogins(isAuthenticated: .constant(false))
    }
}

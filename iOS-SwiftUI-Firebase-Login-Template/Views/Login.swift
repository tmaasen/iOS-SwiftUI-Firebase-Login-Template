//
//  Login.swift
//
//

import SwiftUI

struct Login: View {
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var showAuthLoader: Bool = false
    @State private var showInvalidPWAlert: Bool = false
    @State private var isAuthenticated: Bool = false
    @FocusState private var emailIsFocused: Bool
    @FocusState private var passwordIsFocused: Bool
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            NavigationLink("", value: isAuthenticated)
            Image("FirebaseIcon")
                .resizable()
                .frame(width: 80, height: 80)
            
            Text("Login with Firebase Example")
                .foregroundColor(.Orange)
                .padding(.top, 15)
                .font(.system(size: 35))
                .multilineTextAlignment(.center)
            
            VStack {
                TextField("Email Address", text: $emailAddress)
                    .withLoginStyles()
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .focused($emailIsFocused)
                SecureField("Password", text: $password)
                    .withSecureFieldStyles()
                    .submitLabel(.next)
                    .focused($passwordIsFocused)
                if (!showAuthLoader) {
                    // Sign In
                    LoginButton(emailAddress: $emailAddress, password: $password, showAuthLoader: $showAuthLoader, showInvalidPWAlert: $showInvalidPWAlert, isAuthenticated: $isAuthenticated, buttonText: "Sign In")
                    // Create Account
                    LoginButton(emailAddress: $emailAddress, password: $password, showAuthLoader: $showAuthLoader, showInvalidPWAlert: $showInvalidPWAlert, isAuthenticated: $isAuthenticated, buttonText: "Create Account")
                } else {
                    ProgressView()
                }
            }
            .padding()
                        
            Spacer()

            SocialLogins(isAuthenticated: $isAuthenticated)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: Bool.self) { isAuth in
            if isAuth {
                Home()
            }
        }
    }
}

// FOR DEBUG
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

//
//  Home.swift
//
//

import SwiftUI
import FirebaseAuth

struct Home: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var isShowingSignOut: Bool = false
    @State private var isSignedOut: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Hello " + (Auth.auth().currentUser?.displayName ?? "User") + ". You are now signed in.")
                .padding(.bottom)
            Text("Email: " + (Auth.auth().currentUser?.email ?? "Could not provide value"))
                .padding(.bottom)
            Text("Sign-In Method: " + authViewModel.signInMethod)
                .padding(.bottom)
                        
            NavigationLink(value: isSignedOut) {
                HStack {
                    Image(systemName: "arrow.left.square.fill")
                    Text("Sign Out")
                }
                .onTapGesture { isShowingSignOut = true }
                .actionSheet(isPresented: $isShowingSignOut) {
                    ActionSheet(
                        title: Text("Are You Sure? If you sign out, you will return to the login screen."),
                        buttons: [
                            .destructive(Text("Sign out")) {
                                authViewModel.signOut()
                                isSignedOut = true
                            },
                            .cancel()
                        ]
                    )
                }
            }
            
            Spacer()

        }
        .navigationDestination(for: Bool.self) { boolvar in
            if boolvar == true {
                Login()
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

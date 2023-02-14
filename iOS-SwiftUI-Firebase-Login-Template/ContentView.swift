//
//  ContentView.swift
//  iOS-SwiftUI-Firebase-Login-Template
//
//  Created by Tanner Maasen on 2/11/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    var hasPersistedSignedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    var body: some View {
        NavigationStack {
            if authViewModel.state == .signedOut && !hasPersistedSignedIn && !authViewModel.restoreGoogleSignIn {
                Login()
            } else {
                Home()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
    }
}

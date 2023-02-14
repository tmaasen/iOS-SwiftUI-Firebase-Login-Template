//
//  iOS_SwiftUI_Firebase_Login_TemplateApp.swift
//  iOS-SwiftUI-Firebase-Login-Template
//
//  Created by Tanner Maasen on 2/11/23.
//

import SwiftUI
import Firebase

@main
struct iOS_SwiftUI_Firebase_Login_TemplateApp: App {
    @StateObject var authViewModel = AuthenticationViewModel()
    
    init() {
        FirebaseApp.configure()
    }
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}

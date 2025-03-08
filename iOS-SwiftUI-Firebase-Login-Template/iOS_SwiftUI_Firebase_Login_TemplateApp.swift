//
//  iOS_SwiftUI_Firebase_Login_TemplateApp.swift
//  iOS-SwiftUI-Firebase-Login-Template
//
//  Created by Tanner Maasen on 2/11/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct iOS_SwiftUI_Firebase_Login_TemplateApp: App {
	// Create the auth repository
	@StateObject var authViewModel = AuthenticationViewModel(
		authRepository: FirebaseAuthRepository()
	)
	
	init() {
		// Configure Firebase
		FirebaseApp.configure()
		
		// Additional setup if needed
		setupAppearance()
	}
	
	private func setupAppearance() {
		// Set up any global UI appearance settings
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		
		// Use the accent color for the navigation bar title
		let orangeColor = UIColor(named: "Orange")
		appearance.titleTextAttributes = [.foregroundColor: orangeColor ?? .systemOrange]
		appearance.largeTitleTextAttributes = [.foregroundColor: orangeColor ?? .systemOrange]
		
		// Apply the appearance settings
		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().compactAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
	}
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(authViewModel)
				.onOpenURL { url in
					// Handle deep links, such as those from Google Sign-In
					GIDSignIn.sharedInstance.handle(url)
				}
		}
	}
}

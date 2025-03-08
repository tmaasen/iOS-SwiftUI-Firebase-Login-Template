//
//  ContentView.swift
//  iOS-SwiftUI-Firebase-Login-Template
//
//  Created by Tanner Maasen on 2/11/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
	@EnvironmentObject var authViewModel: AuthenticationViewModel
	
	// This will check if we have a persisted login
	private var isPersistedLogin: Bool {
		UserDefaults.standard.bool(forKey: "isLoggedIn")
	}
	
	var body: some View {
		NavigationStack {
			// Show the appropriate view based on authentication state
			Group {
				if authViewModel.state == .signedIn ||
					(isPersistedLogin && authViewModel.currentUser != nil) {
					// User is authenticated, show the Home view
					Home()
				} else {
					// User is not authenticated, show the Login view
					Login()
				}
			}
			.animation(.easeInOut, value: authViewModel.state)
		}
		.overlay {
			// Show loading indicator when ViewModel is loading
			if authViewModel.isLoading {
				LoadingView()
			}
		}
		.alert(item: errorBinding) { authError in
			Alert(
				title: Text("Error"),
				message: Text(authError.errorDescription ?? "An unknown error occurred"),
				dismissButton: .default(Text("OK"))
			)
		}
	}
	
	// Map AuthError to an Identifiable error for alerts
	private var errorBinding: Binding<IdentifiableError?> {
		Binding<IdentifiableError?>(
			get: {
				guard let error = authViewModel.error else { return nil }
				return IdentifiableError(error: error)
			},
			set: { _ in authViewModel.error = nil }
		)
	}
}

// Helper for making errors identifiable for alerts
struct IdentifiableError: Identifiable {
	let id = UUID()
	let error: AuthError
	
	var errorDescription: String? {
		error.localizedDescription
	}
}

// Preview provider for Xcode previews
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(AuthenticationViewModel(
				authRepository: FirebaseAuthRepository()
			))
	}
}

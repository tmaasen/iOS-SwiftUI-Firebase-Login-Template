//
//  CustomSignInWithAppleButton.swift
//
//

import SwiftUI
import AuthenticationServices

struct CustomSignInWithAppleButton: UIViewRepresentable {
        
    var colorScheme: String
    
    let action: () -> ()

    func makeUIView(context: UIViewRepresentableContext<CustomSignInWithAppleButton>) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: colorScheme == "light" ? .black : .white)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: UIViewRepresentableContext<CustomSignInWithAppleButton>) {
        uiView.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped(_:)), for: .touchUpInside)
    }
    
    func makeCoordinator() -> CustomSignInWithAppleButton.Coordinator {
        Coordinator(action: self.action)
    }

    class Coordinator {
        let action: () -> ()
        init(action: @escaping() -> ()) {
            self.action = action
        }
        
        @objc fileprivate func buttonTapped(_ sender: Any) {
            action()
        }
    }
}

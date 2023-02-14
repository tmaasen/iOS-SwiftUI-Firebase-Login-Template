//
//  GoogleSignInButton.swift
//
//

import SwiftUI

struct GoogleSignInButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        HStack {
            Image("GoogleIcon")
                .resizable()
                .frame(width: 10, height: 10)
            
            Text("Sign in with Google")
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

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton()
    }
}

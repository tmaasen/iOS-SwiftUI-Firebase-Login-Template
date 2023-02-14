//
//  LoginOptions.swift
//
//

enum LoginOption {
    case signInWithApple
    case signInWithGoogle
    case emailAndPassword(email: String, password: String)
}

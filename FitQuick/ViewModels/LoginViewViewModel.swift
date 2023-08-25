//
//  LoginViewViewModel.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-12.
//

import FirebaseAuth
import Foundation

class LoginViewViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func login() {
        errorMessage = ""
        guard validate() else {
            return
        }
        
        // Try to log user in, if there is valid format but no account, throw error
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                errorMessage = "Login credentials do not work"
            }
        }
    }
    
    // function to validate fields are inputted properly
    private func validate() -> Bool {
        // reset error message
        errorMessage = ""
        
        // validate that fields are filled up
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        // validate a proper email address format
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address"
            return false
        }
        
        return true
    }
}

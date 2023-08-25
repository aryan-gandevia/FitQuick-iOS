//
//  RegisterViewViewModel.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-13.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class RegisterViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var userName = ""
    
    @Published var errorMessage = ""
    
    @Published var userId = ""
    
    var check = false
    
    //TODO: make sure all usernames are unique

    init() {
    }
    
    
    func register() {
        errorMessage = ""
        guard validate() else {
            print(errorMessage)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Error creating user:", error.localizedDescription)
            } else {
                print("successful")
                guard let userId = authResult?.user.uid else {
                    return
                }
                self?.insertUserRecord(id: userId)
            }
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id,
                           name: name,
                           userName: userName,
                           email: email,
                           joined: Date().timeIntervalSince1970,
                           gender: "None",
                           weight: 0,
                           height: 0,
                           age: 0)
        
        userId = id
                            
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    // validation function for input
    private func validate() -> Bool {
        errorMessage = ""
        
        // validate fields are filed in
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !userName.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "please fill in all the required fields!"
            return false
        }
              
        // validate a proper email address
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "please input a valid email address!"
            return false
        }
        
        // unique email and username validation
        let db = Firestore.firestore()
        db.collection("users")
            .getDocuments{ [weak self] querySnapshot, error in

                if let users = querySnapshot?.documents {
                    // go through all the users and see if there are emails or usernames that match what has been inputted
                    for user in users {
                        let temp = user.data()
                        
                        // username check
                        if temp["userName"] as? String == self?.userName {
                            self?.errorMessage = "This username has already been used. Please choose another one!"
                            self?.check = true
                            return
                        }
                        
                        // email check
                        if temp["email"] as? String == self?.email {
                            self?.errorMessage = "This email has already been registered. Please try logging in instead!"
                            self?.check = true
                            return
                        }

                    }
                }
            }
        
        // if the username or email isn't unique
        if check {
            return false
        }
        
        // validate a proper password
        // TODO: Add more password validation
        guard password.count >= 6 else {
            errorMessage = "please input a password longer than 6 characters!"
            return false
        }
        
        guard !(userName.count >= 15) else {
            errorMessage = "please input a username shorter than 15 characters"
            return false
        }
            
        return true
    }
}

//
//  PersonInformationViewViewModel.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-13.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class PersonaInformationViewViewModel: ObservableObject {
    @Published var gender = "None"
    @Published var weight = ""
    @Published var height = ""
    @Published var age = ""
    @Published var errorMessage = ""
    
    @Published var user: User? = nil
    
    private var uID = ""
    
    
    init() {}
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        self.uID = userId
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .getDocument { [weak self] snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.gender = data["gender"] as? String ?? "None"
                    self?.weight = String(data["weight"] as? Int ?? 0)
                    self?.height = String(data["height"] as? Int ?? 0)
                    self?.age = String(data["age"] as? Int ?? 0)
                    
                    self?.user = User(id: data["id"] as? String ?? "",
                                      name: data["name"] as? String ?? "",
                                      userName: data["userName"] as? String ?? "",
                                      email: data["email"] as? String ?? "",
                                      joined: data["joined"] as? TimeInterval ?? 0,
                                      gender: data["gender"] as? String ?? "None",
                                      weight: data["weight"] as? Int ?? 0,
                                      height: data["height"] as? Int ?? 0,
                                      age: data["age"] as? Int ?? 0)
                }
            }
    }
    
    func save() {
        errorMessage = ""
        guard validate() else {
            return
        }
        
        let updatedUser = User(id: uID,
                               name: user?.name as? String ?? "",
                               userName: user?.userName as? String ?? "",
                               email: user?.email as? String ?? "",
                               joined: user?.joined as? TimeInterval ?? 0,
                               gender: gender,
                               weight: Int(weight) ?? 0,
                               height: Int(height) ?? 0,
                               age: Int(age) ?? 0)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uID)
            .updateData(updatedUser.asDictionary())
    }
    
    func validate() -> Bool {
        errorMessage = ""
        guard !gender.trimmingCharacters(in: .whitespaces).isEmpty,
              !weight.trimmingCharacters(in: .whitespaces).isEmpty,
              !age.trimmingCharacters(in: .whitespaces).isEmpty,
              !height.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        guard !(Int(weight) ?? 0 <= 0),
              !(Int(age) ?? 0 <= 0),
              !(Int(height) ?? 0 <= 0) else {
            errorMessage = "Please enter valid measurements"
            return false
        }
        
        guard !(Int(weight) ?? 0 >= 1200) else {
            errorMessage = "Please enter a weight below 1200lbs"
            return false
        }
        
        guard !(Int(age) ?? 0 >= 110) else {
            errorMessage = "Please enter an age below 110 years old"
            return false
        }
        
        guard !(Int(height) ?? 0 >= 100) else {
            errorMessage = "Please enter a height below 100 inches"
            return false
        }
                
        return true
    }
}

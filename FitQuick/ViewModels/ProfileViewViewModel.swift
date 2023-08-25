//
//  ProfileViewViewModel.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-12.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class ProfileViewViewModel : ObservableObject {
    init() {}
    
    @Published var user: User? = nil
    
    @Published var showData: Bool = false
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .getDocument { [weak self] snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.user = User(id: data["id"] as? String ?? "",
                                      name: data["name"] as? String ?? "",
                                      userName: data["userName"] as? String ?? "",
                                      email: data["email"] as? String ?? "",
                                      joined: data["joined"] as? TimeInterval ?? 0,
                                      gender: data["gender"] as? String ?? "",
                                      weight: data["weight"] as? Int ?? 0,
                                      height: data["height"] as? Int ?? 0,
                                      age: data["age"] as? Int ?? 0)
                    
                    if data["weight"] as? Int ?? 0 == 0,
                       data["height"] as? Int ?? 0 == 0,
                       data["age"] as? Int ?? 0 == 0 {
                           self?.showData = true
                       }
                }
            }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

//
//  CompareViewViewModel.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-15.
//

import FirebaseFirestore
import Firebase
import Foundation

class CompareViewViewModel: ObservableObject {
    @Published var search = ""
    @Published var searchResults: [User] = []
    
    @Published var showingFaceOff = false
    
    @Published var currentUserId = ""
    
    @Published var liftResults: [String] = []
    @Published var liftSelected = ""
    
    let db = Firestore.firestore()
    
    init() {}
    
    func updatedSearch() {
        
        let searchQuery = db.collection("users")
            .whereField("userName", isGreaterThanOrEqualTo: search)
            .whereField("userName", isLessThan: search + "z")
        
        searchQuery.getDocuments { [weak self] snapshot, error in
            var fetchedResults: [User] = []
            if let users = snapshot?.documents {
                for user in users {
                    let temp = user.data()
                
                    if self?.currentUserId != temp["id"] as? String ?? "" {
                        fetchedResults.append(User(id: temp["id"] as? String ?? "",
                                                   name: temp["name"]  as? String ?? "",
                                                   userName: temp["userName"]  as? String ?? "",
                                                   email: temp["email"]  as? String ?? "",
                                                   joined: temp["joined"]  as? TimeInterval ?? 0,
                                                   gender: temp["gender"]  as? String ?? "",
                                                   weight: temp["weight"] as? Int ?? 0,
                                                   height: temp["height"] as? Int ?? 0,
                                                   age: temp["age"] as? Int ?? 0))
                    }
                   
                }
            }
            self?.searchResults = fetchedResults
        }
    }
    
    func fetchAvailableLifts() {
        
        db.collection("users")
            .document(currentUserId)
            .collection("lifts")
            .getDocuments {[weak self] snapshot, error in
                var fetchedLifts: [String] = []
                if let lifts = snapshot?.documents {
                    for lift in lifts {
                        let temp = lift.data()
                        fetchedLifts.append(temp["liftName"] as? String ?? "")
                    }
                }
                self?.liftResults = fetchedLifts
                if !fetchedLifts.isEmpty {
                    if let firstRes = fetchedLifts.first {
                        self?.liftSelected = firstRes
                    }
                }
            }
    }
    
}

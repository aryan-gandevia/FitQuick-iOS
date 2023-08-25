//
//  FaceOffViewViewModel.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-18.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class FaceOffViewViewModel: ObservableObject {
    
    @Published var currentUser: User? = nil
    @Published var otherUser: User? = nil
    
    @Published var currentUserLifts: [Lift] = []
    @Published var otherUserLifts: [Lift] = []
    
    private var db = Firestore.firestore()
    
    
    init() {}
    
    // wrapper function to fetch the two users
    func fetchUsers(currentUserId: String, otherUserId: String) {
        fetchOneUser(userId: currentUserId, currOrOther: true)
        fetchOneUser(userId: otherUserId, currOrOther: false)
    }
    
    // fetch a user
    func fetchOneUser(userId: String, currOrOther: Bool) {
        // fetch your user
        db.collection("users")
            .document(userId)
            .getDocument { [weak self] snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    var temp = User(id: data["id"] as? String ?? "",
                                      name: data["name"] as? String ?? "",
                                      userName: data["userName"] as? String ?? "",
                                      email: data["email"] as? String ?? "",
                                      joined: data["joined"] as? TimeInterval ?? 0,
                                      gender: data["gender"] as? String ?? "",
                                      weight: data["weight"] as? Int ?? 0,
                                      height: data["height"] as? Int ?? 0,
                                      age: data["age"] as? Int ?? 0)
                    if (currOrOther) {
                        self?.currentUser = temp
                    } else {
                        self?.otherUser = temp
                    }
                }
            }
    }
    
    // wrapper function to fetch all the lifts
    func fetchInformation(userId: String, otherUserId: String) {
        fetchLifts(userId: userId, currOrOther: true)
        fetchLifts(userId: otherUserId, currOrOther: false)
        organizeLifts()
    }
    
    // Get all the lifts for a user
    func fetchLifts(userId: String, currOrOther: Bool) {
        db.collection("users")
            .document(userId)
            .collection("lifts")
            .getDocuments { [weak self] snapshot, error in
                var fetchedResults: [Lift] = []
                if let lifts = snapshot?.documents {
                    for lift in lifts {
                        let temp = lift.data()
                        
                        fetchedResults.append(Lift(id: temp["id"] as? String ?? "",
                                                   liftName: temp["liftName"] as? String ?? "",
                                                   numReps: temp["numReps"] as? Int ?? 0,
                                                   weight: temp["weight"] as? Int ?? 0))
                    }
                }
                if (currOrOther) {
                    self?.currentUserLifts = fetchedResults
                } else {
                    self?.otherUserLifts = fetchedResults
                }
            }
    }
    
    // Removes all the lifts from the other user's lift list to only compare the same lifts
    func organizeLifts() {
        var newList: [Lift] = []
        
        for currUserLift in currentUserLifts {
            for otherUserLift in otherUserLifts {
                if currUserLift.liftName == otherUserLift.liftName {
                    newList.append(otherUserLift)
                }
            }
        }
        
        otherUserLifts = newList
    }
    
    func centeringCheck(diff: Int) -> Bool{
        if diff > 0 {
            return false
        }
        return true
    }
}

//
//  NewLiftViewViewModel.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-14.
//
import FirebaseAuth
import FirebaseFirestore
import Foundation

class NewLiftViewViewModel: ObservableObject {
    @Published var liftName = "Barbell Bench Press"
    @Published var numReps = ""
    @Published var weight = ""
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    @Published var showTips = false
    
    private var userId = ""
    
    init () {}
    
    func save() {
        // TODO: See if they are adding something they have already added
        guard canSave else {
            return
        }
        
        // Get current user id
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        userId = uID
        
        // Model
        let lift = Lift(id: liftName,
                        liftName: liftName,
                        numReps: Int(numReps) ?? 0,
                        weight: Int(weight) ?? 0)
        
        // Save model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uID)
            .collection("lifts")
            .document(liftName)
            .setData(lift.asDictionary())
    }
    
    var canSave: Bool {
        errorMessage = ""
        
        // validate correct numbers for weight and amount of reps
        guard !(Int(numReps) ?? 0 <= 0),
              !(Int(weight) ?? 0 <= 0) else {
            errorMessage = "Please input valid numbers for the lift's rep count and weight"
            return false
        }
        
        guard !(Int(weight) ?? 0 >= 2000) else {
            errorMessage = "Is this the Incredible Hulk? Please track a lift below 2000 pounds"
            return false
        }
        
        guard !(Int(numReps) ?? 0 >= 13) else {
            errorMessage = "Please track a set of 12 or less repititions"
            return false
        }
        
        return true
    }
}

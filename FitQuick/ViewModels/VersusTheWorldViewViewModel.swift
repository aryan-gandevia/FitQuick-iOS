//
//  VersusTheWorldViewViewModel.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-20.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

// TODO: clean up function and redundancies with variables for the oneRM calculation
class VersusTheWorldViewViewModel: ObservableObject {
    
    @Published var user: User? = nil
    @Published var lift: Lift? = nil
    
    @Published var liftMap: [String : [Double]] = [:]
    @Published var levels: [String] = ["Beginner", "Novice", "Intermediate", "Advanced", "Elite"]
    
    @Published var calculatedOneRM = 0
    @Published var weight = 0
    @Published var numReps = 0
    @Published var userWeight = 0
    @Published var levelsWeightList: [Double] = []
    @Published var message = ""
    
    private var db = Firestore.firestore()
    
    init() {}
    
    // fetch the user
    func fetchUser(userId: String) {
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
                    
                    self?.userWeight = data["weight"] as? Int ?? 0
                }
            }
    }
    
    // fetch the lift selected
    func fetchLift(userId: String, liftName: String) {
        db.collection("users")
            .document(userId)
            .collection("lifts")
            .document(liftName)
            .getDocument { [weak self] snapshot, error in
                guard let data = snapshot?.data(), error == nil else {
                    return
                }
                
                self?.lift = Lift(id: data["id"] as? String ?? "",
                                  liftName: data["liftName"] as? String ?? "",
                                  numReps: data["numReps"] as? Int ?? 0,
                                  weight: data["weight"] as? Int ?? 0)
                
                self?.weight = data["weight"] as? Int ?? 0
                self?.numReps = data["numReps"] as? Int ?? 0
            }
    }
    
    // setting data of lift ratios; ratios accurate as they are values taken from external sites that have data from millions of lifters and I averaged the ratios' values
    func setData() {
        liftMap["Barbell Bench Press"] = [0.5, 0.75, 1.25, 1.75, 2.0]
        liftMap["Barbell Inclined Bench Press"] = [0.5, 0.75, 1.0, 1.5, 1.75]
        liftMap["Barbell Deadlift"] = [1.0, 1.5, 2.0, 2.5, 3.0]
        liftMap["Barbell Squat"] = [0.75, 1.25, 1.5, 2.25, 2.75]
        liftMap["Barbell Romanian Deadlift"] = [0.75, 1.0, 1.5, 2.0, 2.75]
        liftMap["Barbell Shoulder Press"] = [0.35, 0.55, 0.8, 1.1, 1.4]
        liftMap["Barbell Row"] = [0.5, 0.75, 1.0, 1.5, 1.75]
        
    }
    
    // Brzycki formula from Matt Brzycki for 1RM
    func setOneRepMax(liftName: String) {
        let dWeight = Double(weight)
        let dNumReps = Double(numReps)
        let oneRM = dWeight / (1.0278 - (0.0278 * dNumReps))
        
        calculatedOneRM = Int(oneRM)
        
        var newLevels: [String] = []
        var check = true
        for (level, val) in zip(levels, liftMap[liftName] ?? [0.0]) {
            let uWeight = Double(userWeight)
            let temp = val * uWeight
            if oneRM <= temp && check {
                levelsWeightList.append(oneRM)
                newLevels.append("You")
                message = level
                check = false
            }
            newLevels.append(level)
            levelsWeightList.append(temp)
        }
        
        if check {
            levelsWeightList.append(oneRM)
            newLevels.append("You")
        }
        
        userLevelMessage()
        
        levels = newLevels
    }
    
    // message to display on the screen after analysis
    func userLevelMessage() {
        if message == "Beginner" {
            message = "You are a beginner lifter, but don't be discouraged. This is where the biggest gains happen!"
        } else if message == "Novice" {
            message = "You are a novice lifter. Stay consistent, you are getting there!"
        } else if message == "Intermediate" {
            message = "You are an intermediate lifter. This is no easy feat, keep pushing forward!"
        } else if message == "Advanced" {
            message = "You are an advanced lifter. You are currently pushing the human boundaries ,don't stop!"
        } else if message == "Elite" {
            message = "You are an elite lifer, are you sure you are natural..."
        } else {
            message = "Looks like we've stumbled across a professional lifter. Shoot me a message, I'm impressed!"
        }
    }
}

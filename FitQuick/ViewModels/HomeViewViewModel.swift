//
//  HomeViewViewModel.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-14.
//

import FirebaseFirestore
import Foundation

class HomeViewViewModel: ObservableObject {
    @Published var showingNewLiftView = false
    
    @Published var showTips = false
    
    init () {}
    
    func delete(id: String, userId: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("lifts")
            .document(id)
            .delete()
    }
}

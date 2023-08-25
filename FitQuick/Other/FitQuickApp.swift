//
//  FitQuickApp.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-12.
//

import FirebaseCore
import FirebaseAuth
import Firebase
import SwiftUI

@main
struct FitQuickApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

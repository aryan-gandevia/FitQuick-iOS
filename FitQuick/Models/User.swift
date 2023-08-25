//
//  User.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-12.
//

import Foundation

struct User: Codable, Hashable {
    let id: String
    let name: String
    let userName: String
    let email: String
    let joined: TimeInterval
    
    // For personal information
    let gender: String
    let weight: Int
    let height: Int
    let age: Int
}

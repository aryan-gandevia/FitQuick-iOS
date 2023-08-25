//
//  Lift.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-14.
//

import Foundation

struct Lift: Codable, Identifiable, Hashable {
    let id: String
    let liftName: String
    let numReps: Int
    let weight: Int
}

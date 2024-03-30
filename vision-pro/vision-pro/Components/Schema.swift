//
//  Schema.swift
//  Learning-App-Frontend
//
//  Created by Benny Wu on 2024-03-30.
//

import SwiftUI

// Placeholder for Classroom model
struct Classroom: Identifiable {
    let id = UUID()
    let name: String
    let university: String
    let imageName: String
}


// A mock data model for lessons or items associated with the class
struct Lesson: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}

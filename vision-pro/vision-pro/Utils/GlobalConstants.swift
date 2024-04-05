//
//  GlobalConstants.swift
//  vision-pro
//
//  Created by Benny Wu on 2024-03-30.
//

import SwiftUI

let backendBaseURL = "http://127.0.0.1:5000"

enum UserType {
    case teacher
    case student
}

struct UserTypeKey: EnvironmentKey {
    static let defaultValue: UserType = .student // Default value
}


extension EnvironmentValues {
    var userType: UserType {
        get { self[UserTypeKey.self] }
        set { self[UserTypeKey.self] = newValue }
    }
}

struct CustomAlertView: View {
    var message: String

    var body: some View {
        Text(message)
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.top, 50)
    }
}

struct AlertView: View {
    var message: String
    var type: AlertType

    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(type == .success ? Color.green : (type == .warning ? Color.yellow : Color.red))
            .cornerRadius(10)
    }
}

// Need (TODO):
// - User Object
// - Course Object
// - Chat Object




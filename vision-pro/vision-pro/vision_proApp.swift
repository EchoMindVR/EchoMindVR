//
//  vision_proApp.swift
//  vision-pro
//
//  Created by Benny Wu on 2024-03-30.
//

import SwiftUI

@main
struct Vision_Pro: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}

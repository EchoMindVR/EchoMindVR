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
        WindowGroup("Learning App", id: "modules") {
            ContentView()
        }
        .defaultSize(CGSize(width: 1500, height: 850))
    
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
        
    }
}

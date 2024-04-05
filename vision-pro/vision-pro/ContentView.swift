
import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var isPresentingClassroomDetail = false
    @State private var isLoggedIn = false
    @Environment(\.userType) var userType
    
    // Make this global too! Have a user object or somethign
    @State private var username = ""
    
    var body: some View {
        if (isLoggedIn) {
            HomePage(isPresentingClassroomDetail: $isPresentingClassroomDetail, isLoggedIn: $isLoggedIn, userName: $username)
        } else {
            LandingView(isLoggedIn: $isLoggedIn, userName: $username)
        }
    }

}

#Preview(windowStyle: .automatic) {
    ContentView()
}


import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var isPresentingClassroomDetail = false
    @State private var isLoggedIn = false
    var body: some View {
        if (isLoggedIn) {
            HomePage(isPresentingClassroomDetail: $isPresentingClassroomDetail, isLoggedIn: $isLoggedIn)
        } else {
            LandingView(isLoggedIn: $isLoggedIn)
        }
    }

}

#Preview(windowStyle: .automatic) {
    ContentView()
}


import SwiftUI
import RealityKit
import RealityKitContent

//    .fullScreenCover(isPresented: $isPresentingClassroomDetail) {
//                ClassroomDetailView(classroom: Classroom(name: "CS51 - Introduction to Generative AI", university: "Harvard University", imageName: "classroomImage"))
//            }
struct ContentView: View {
    @State private var isPresentingClassroomDetail = false
    @State private var isLoggedIn = false
    var body: some View {
        if (isLoggedIn) {
            HomePage(isLoggedIn: $isLoggedIn)
        } else {
            LandingView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

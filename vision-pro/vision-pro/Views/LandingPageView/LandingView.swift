import SwiftUI

struct LandingView: View {
    // Hover effect (button)
    @State private var isHovered = false
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                TypingTextView(text: "Empowering Your Learning Journey with Augmented Discovery.")
                    
                
                
                NavigationLink(destination: LoginPage(isLoggedIn: $isLoggedIn)) {
                    Text("Enter App")
                        .fontWeight(.semibold)
                        .frame(width: 180, height: 28)
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(isHovered ? Color.red : Color.clear, lineWidth: 2) // Add a white outline on hover
                        )
                }
                .hoverEffect()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("classroom") // Replace "backgroundImage" with the name of your image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all) // This makes the image extend into the safe area
        )
        .clipShape(RoundedRectangle(cornerRadius: 50))
    }
}

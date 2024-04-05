import SwiftUI

struct LandingView: View {
    @Binding var isLoggedIn: Bool
    @Binding var userName: String;
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                Spacer()
                // Typing animation
                TypingTextView(text: "Empowering Your Learning Journey with Augmented Discovery.")
                    .padding(.top, 100)
                                    
                // Login button
                NavigationLink(destination: LoginPage(isLoggedIn: $isLoggedIn, userName: $userName)) {
                    Text("Enter App")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(.semibold)
                        .frame(width: 250, height: 70)
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(40)
                }
                .hoverEffect()
                
                Spacer() // Pushes the copyright text to the bottom
                                
                // Copyright text
                Text("© 2024 Xiao, Ken, Jessica, Henry, Benny")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.bottom, 20) // Add some padding at the bottom
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("blue-night-sky") // Replace "backgroundImage" with the name of your image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all) // This makes the image extend into the safe area
        )
        .clipShape(RoundedRectangle(cornerRadius: 50))
    }
}

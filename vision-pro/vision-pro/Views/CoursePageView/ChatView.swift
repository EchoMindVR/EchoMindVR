import SwiftUI

struct ChatView: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack {
                Text("Chat")
                    .font(.title2)
                    .padding()
                
                ScrollView {
                    VStack {
                        // Your chat messages would go here
                        Text("Let's figure out how this will look")
                        // Repeat the above Text view for each message or create a custom view for messages
                    }
                }
                .frame(width: 630)
                
                Button(action: {
                    // Action to generate summary
                }) {
                    Text("Generate Summary")
                }
                
            }
            .background(Color.gray.opacity(0.2)) // Light gray background for the chat view
            .cornerRadius(20)
            .padding(.leading, 60)
            .padding(.bottom, 100)
            .padding(.top, 22)
            
            Spacer()
            
            SettingsView()
                .padding(.bottom, 80)
                .padding(.trailing, 50)
                
        }
    }
}

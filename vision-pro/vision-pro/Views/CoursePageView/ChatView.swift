import SwiftUI

struct ChatView: View {
    var lecture: String = "lec 1"
    @State private var gemmaOutput: String = ""
    
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
                
                Text(gemmaOutput) // Displaying the gemmaOutput
                    .font(.title3)
                    .padding()
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    // Action to generate summary
                }) {
                    Text("Generate Summary")
                }
                .padding(20)
                
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
        .onAppear {
            fetchChatData()
        }
    }
    
    func fetchChatData() {
        let initUrl = URL(string: "\(backendBaseURL)/gemma/init")!
        var initRequest = URLRequest(url: initUrl)
        initRequest.httpMethod = "POST"
        initRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let initBody: [String: String] = ["lecture": lecture]
        initRequest.httpBody = try? JSONSerialization.data(withJSONObject: initBody, options: [])

        URLSession.shared.dataTask(with: initRequest) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                return
            }

            // If the first request is successful, proceed with the second request
            let extendUrl = URL(string: "\(backendBaseURL)/gemma/extend")!
            var extendRequest = URLRequest(url: extendUrl)
            extendRequest.httpMethod = "POST"
            extendRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // Assuming the second request does not require a body, or you can add a body similar to the first request

            URLSession.shared.dataTask(with: extendRequest) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid response")
                    return
                }

                if let data = data, let outputString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.gemmaOutput = outputString
                    }
                }
            }.resume()
        }.resume()
    }
}

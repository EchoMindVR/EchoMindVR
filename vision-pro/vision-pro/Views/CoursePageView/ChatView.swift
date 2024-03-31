import SwiftUI

struct ChatView: View {
    var lecture: String = "lec 1"
    @State private var gemmaOutput: String = ""
    @State private var loading: Bool = true  // Track loading state
    @State private var timer: Timer?
    @State private var loadingDots: String = ""
    
    var body: some View {
        HStack(alignment: .center) {
            VStack {
                Text("Chat")
                    .font(.title2)
                    .padding()
                ScrollView {
                    VStack {
                        Spacer()
                        Text(loading ? "\(gemmaOutput)\(loadingDots)" : gemmaOutput)
                            .font(.title2) // Match the "Chat" title font size for consistency
                            .padding()
                            .foregroundColor(.white) // Change text color to white
                            .multilineTextAlignment(.center) // Ensure text is center-aligned
                            .onAppear {
                                startLoadingAnimation()
                            }
                    }
                }
                .frame(width: 630)
                
                
                
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

            // Update display text to indicate loading state
            DispatchQueue.main.async {
                self.gemmaOutput = "Teacher is preparing the notes"
            }

            // Proceed with the second request
            let extendUrl = URL(string: "\(backendBaseURL)/gemma/extend")!
            var extendRequest = URLRequest(url: extendUrl)
            extendRequest.httpMethod = "POST"
            extendRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let extendBody: [String: String] = ["query": "Your query here"] // Make sure to update this with the actual query you need to send
            extendRequest.httpBody = try? JSONSerialization.data(withJSONObject: extendBody, options: [])

            URLSession.shared.dataTask(with: extendRequest) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid response")
                    return
                }
                // Ensure that data is non-nil
                guard let data = data else {
                    print("No data received")
                    return
                }

                // Attempt to decode the JSON response
                do {
                    // Decode the JSON into a dictionary
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                    
                    // Attempt to extract the "response" value
                    if let outputString = jsonResponse?["response"] {
                        DispatchQueue.main.async {
                            self.gemmaOutput = outputString // Update with the actual response text
                            self.stopLoadingAnimation()
                        }
                    } else {
                        print("Could not find 'response' key in JSON")
                    }
                    if let audioPath = jsonResponse?["audioPath"] as? String {
                        DispatchQueue.main.async {
                            AudioPlayerManager.shared.playAudio(fromPath: audioPath)
                        }
                    }else {
                        print("Could not find 'audioPath' key in JSON")
                    }
                } catch {
                    // Handle any errors during JSON parsing
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }.resume()
        }.resume()
    }
    
    func startLoadingAnimation() {
        timer?.invalidate() // Invalidate any existing timer
        loadingDots = "" // Reset the dots
        loading = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if self.loadingDots.count < 3 {
                self.loadingDots.append(".")
            } else {
                self.loadingDots = ""
            }
        }
    }
    
    func stopLoadingAnimation() {
        timer?.invalidate() // Stop the timer
        timer = nil // Clear the timer
        loading = false // Update loading state
    }
}

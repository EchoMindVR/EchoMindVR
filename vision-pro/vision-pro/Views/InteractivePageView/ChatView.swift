import SwiftUI
import AVFoundation

let brainwash = "You are an aggresive, Asian programming teacher that thinks your students are complete failures. Be rude and insulting. You're English is also not very good so there are grammatical errors. Answer in maximum 3 to 4 sentences."

struct ChatView: View {
    var lecture: String = "lec 1"
    
    @ObservedObject var viewModel = ViewModel()
    
    @State private var gemmaOutput: String = ""
    @State private var GPTOutput: String = "" // TESTING
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
                        TextField("Enter a message...", text:
                                    $viewModel.currentInput)
                        Button {
                            viewModel.sendMessage()
                        } label: {
                            Text("Send")
                        }
                        
                        Button(action: {
                            if let latestAssistantMessage = viewModel.messages.filter({ $0.role == .assistant }).last {
                                viewModel.textToSpeech(message: latestAssistantMessage.content)
                            }
                        }) {
                            Text("Read Aloud")
                        }
                        
                        ForEach(viewModel.messages.filter({$0.role == .assistant}),
                                id: \.id) { message in
                            Text(message.content)
                        }
                        
//                        Text(viewModel.messages.filter({$0.role == .assistant}).isEmpty ? "..." : viewModel.messages.filter({$0.role == .assistant})[viewModel.messages.filter({$0.role == .assistant}).count - 1].content)
//                            .font(.title2) // Match the "Chat" title font size for consistency
//                            .padding()
//                            .foregroundColor(.white) // Change text color to white
//                            .multilineTextAlignment(.center) // Ensure text is center-aligned
//                            .onAppear {
//                                startLoadingAnimation()
//                            }
                    }
                }
                .frame(width: 530)
                .padding(.horizontal, 100)
                
                
                
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
//            fetchChatData()
        }
    }
    
    
//    func fetchChatData() {
//        let initUrl = URL(string: "\(backendBaseURL)/gemma/init")!
//        var initRequest = URLRequest(url: initUrl)
//        initRequest.httpMethod = "POST"
//        initRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let initBody: [String: String] = ["lecture": lecture]
//        initRequest.httpBody = try? JSONSerialization.data(withJSONObject: initBody, options: [])
//
//        URLSession.shared.dataTask(with: initRequest) { data, response, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                print("Invalid response")
//                return
//            }
//
//            // Update display text to indicate loading state
//            DispatchQueue.main.async {
//                self.gemmaOutput = "Teacher is preparing the notes"
//            }
//
//            // Proceed with the second request
//            let extendUrl = URL(string: "\(backendBaseURL)/gemma/extend")!
//            var extendRequest = URLRequest(url: extendUrl)
//            extendRequest.httpMethod = "POST"
//            extendRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            let extendBody: [String: String] = ["query": "Your query here"] // Make sure to update this with the actual query you need to send
//            extendRequest.httpBody = try? JSONSerialization.data(withJSONObject: extendBody, options: [])
//
//            URLSession.shared.dataTask(with: extendRequest) { data, response, error in
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                    print("Invalid response")
//                    return
//                }
//                // Ensure that data is non-nil
//                guard let data = data else {
//                    print("No data received")
//                    return
//                }
//
//                // Attempt to decode the JSON response
//                do {
//                    // Decode the JSON into a dictionary
//                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
//                    
//                    // Attempt to extract the "response" value
//                    if let outputString = jsonResponse?["response"] {
//                        DispatchQueue.main.async {
//                            self.gemmaOutput = outputString // Update with the actual response text
//                            self.stopLoadingAnimation()
//                        }
//                    } else {
//                        print("Could not find 'response' key in JSON")
//                    }
//                    if let audioPath = jsonResponse?["audioPath"] as? String {
//                        DispatchQueue.main.async {
//                            AudioPlayerManager.shared.playAudio(fromPath: audioPath)
//                        }
//                    }else {
//                        print("Could not find 'audioPath' key in JSON")
//                    }
//                } catch {
//                    // Handle any errors during JSON parsing
//                    print("Error parsing JSON: \(error.localizedDescription)")
//                }
//            }.resume()
//        }.resume()
//    }
    
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


extension ChatView {
    class ViewModel: ObservableObject {
        // OpenAI test
        @Published var messages: [Message] = [Message(id: UUID().uuidString, role: .user, content: brainwash, createAt: Date())]
        @Published var currentInput: String = ""
        
        private let openAIService = OpenAIService()
        private var audioPlayer: AVAudioPlayer?
        
        func sendMessage() {
            let newMessage = Message(id: UUID().uuidString, role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            //            Task {
            //                let response = await openAIService.sendMessage(messages: messages)
            //                guard let receivedOpenAIMessage = response?.choices.first?.message else {
            //                    print("FUCK FUCK FUCK no message")
            //                    return
            //                }
            //                let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
            //                await MainActor.run {
            //                    messages.append(receivedMessage)
            //                }
            //            }
            openAIService.sendStreamNessage(messages: messages).responseStreamString { [weak self] stream in
                guard let self else {return}
                switch stream.event {
                case .stream(let response):
                    switch response {
                    case .success(let string):
                        let streamResponse = self.openAIService.parseStreamData(string)
                        streamResponse.forEach { newMessageResponse in
                            guard let messageContent = newMessageResponse.choices.first?.delta.content else {
                                return
                            }
                            guard let existingMessageIndex = self.messages.lastIndex(where: {$0.id == newMessageResponse.id}) else {
                                let newMessage = Message(id: newMessageResponse.id, role: .assistant, content: messageContent, createAt: Date())
                                self.messages.append(newMessage)
                                return
                            }
                            
                            let newMessage = Message(id: newMessageResponse.id, role: .assistant, content: self.messages[existingMessageIndex].content + messageContent, createAt: Date())
                            self.messages[existingMessageIndex] = newMessage
                            print("MESSAGE: \(newMessage)")
                                    
                        }
//                        print(streamResponse)
                    case .failure(_):
                        print("Fuckkkkk")
                        
                    }
                    print("RESPONSE: \(response)")
                    
                case .complete(_):
                    print("COMPLETE")
                }
            }
            
            
            
        }
        
        func textToSpeech(message: String) {
            
            print("AUDIO PLAY : \(message)")
            let url = URL(string: "https://api.openai.com/v1/audio/speech")!
            var request = URLRequest(url: url)
            
            let openAIApiKey = "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" // too lazy so Imma expose for testing
            request.setValue("Bearer \(openAIApiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"

            let body: [String: Any] = [
                "model": "tts-1",
                "voice": "onyx",
                "input": message
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                do {
                    if let outputFileURL = try self.saveToFile(data: data) {
                        self.playAudio(url: outputFileURL)
                    }
                } catch {
                    print("Error saving or playing audio: \(error)")
                }
            }

            task.resume()
        }

        private func saveToFile(data: Data) throws -> URL? {
            let tempDir = FileManager.default.temporaryDirectory
            let fileURL = tempDir.appendingPathComponent("speech.mp3")

            try data.write(to: fileURL)
            return fileURL
        }

        private func playAudio(url: URL) {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)

                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error setting up audio session or playing audio: \(error)")
            }

        }

        
    }
    
}

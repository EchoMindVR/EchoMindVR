import SwiftUI

enum AccountType {
    case teacher, learner
}

enum AlertType {
    case success
    case warning
    case error
}

struct LoginPage: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var selectedAccountType: AccountType? = nil
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertOpacity: Double = 1.0
    @State private var alertType: AlertType = .success

    @Binding var isLoggedIn: Bool
    @Binding var userName: String

    var body: some View {
        ZStack {
            // Apply the blur effect here
            BlurView()
                .padding(.horizontal, 250)
                .padding(.vertical, 110)
                .cornerRadius(5)
                
            VStack {
                Spacer() // Pushes the copyright text to the bottom

                // Copyright text
                Text("© 2024 Xiao, Ken, Jessica, Henry, Benny")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.bottom, 20) // Add some padding at the bottom
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the entire screen
            
            VStack {
                Spacer()

                // Login Form
                HStack(spacing: 20) {
                    // Account Type Selection
                    VStack(alignment: .leading) {
                        Text("Choose Account Type")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.bottom, 30)
                        

                        HStack {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .padding(.horizontal, 8)
                            VStack (alignment: .leading){
                                Text("Teacher")
                                    .fontWeight(.medium)
                                Text("I teach things")
                                    .font(.system(size: 15))
                                    .opacity(0.4)
                                    .fontWeight(.light)
                            }
                            Spacer()
                        }
                        .frame(width: 260, height: 40)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.3))
                        .hoverEffect()
                        .padding(0) // Ensure no padding is applied
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedAccountType = .teacher
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedAccountType == .teacher ? Color.white : Color.clear, lineWidth: 2)
                        )

                        HStack {
                            Image(systemName: "book.circle")
                                .padding(.horizontal, 8)
                            VStack (alignment: .leading){
                                Text("Learner")
                                    .fontWeight(.medium)
                                Text("I learn things")
                                    .font(.system(size: 15))
                                    .opacity(0.4)
                                    .fontWeight(.light)
                            }
                            Spacer()
                        }
                        .frame(width: 260, height: 40)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.3))
                        .hoverEffect()
                        .padding(0) // Ensure no padding is applied
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedAccountType = .learner
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedAccountType == .learner ? Color.white : Color.clear, lineWidth: 2)
                        )
                    }
                    
                    
                    // Login Form
                    VStack (alignment: .leading){
                        Text("Log in to your Account")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                            

                        TextField("Username", text: $username)
                            .frame(width: 280, height: 15)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(12)

                        SecureField("Password", text: $password)
                            .frame(width: 280, height: 15)
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(12)

                        
//                        Button(action: {
//                            isLoggedIn = true
//                        }) {
//                            Text("Login")
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                        }
//                        .frame(width: 130, height: 28)
//                        .padding(.top, 30)
                        HStack {
                            Button(action: {
                                loginUser()
                            }) {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                            .frame(width: 150, height: 28)
                            .padding(.top, 30)
                            
                            Button(action: {
                                signUpUser()
                            }) {
                                Text("Sign Up")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                            .frame(width: 150, height: 28)
                            .padding(.top, 30)
                        }
                        
                    }
                    .padding(.leading, 100)
                }

                Spacer()
            }
            .padding(.horizontal, 210)
            .padding(.vertical, 120)
            .cornerRadius(20)

            Spacer()

        }
        .edgesIgnoringSafeArea(.all)
        .overlay(
            Group {
                if showAlert {
                    AlertView(message: alertMessage, type: alertType)
                        .opacity(alertOpacity)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            withAnimation(.easeOut(duration: 2)) {
                                alertOpacity = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showAlert = false
                                alertOpacity = 1
                            }
                        }
                        .background()
                }
            }, alignment: .top
        )
    }
    
    
    
    
    func loginUser() {
        // Assume login always succeeds (FOR NOW):
        if (username == "Ben") {
            isLoggedIn = true
            userName = username
        }
        
        guard let url = URL(string: "\(backendBaseURL)/teacher/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["name": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            DispatchQueue.main.async {
                if httpResponse.statusCode == 201 {
                    isLoggedIn = true
                    userName = username
                } else if httpResponse.statusCode == 409 {
                    alertMessage = "Name or Password Wrong"
                    alertType = .warning
                    showAlert = true
                } else {
                    alertMessage = "An unknown error occurred"
                    alertType = .error
                    showAlert = true
                }
                
                if showAlert {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showAlert = false
                    }
                }
            }
        }.resume()
    }
    func signUpUser() {
        guard let url = URL(string: "\(backendBaseURL)/teacher/signup") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["name": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            DispatchQueue.main.async {
                if httpResponse.statusCode == 201 {
                    alertMessage = "Signup successful, please log in"
                    alertType = .success
                    showAlert = true
                } else if httpResponse.statusCode == 409 {
                    alertMessage = "User already exists"
                    alertType = .warning
                    showAlert = true
                } else {
                    alertMessage = "An unknown error occurred"
                    alertType = .error
                    showAlert = true
                }
                
                if showAlert {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showAlert = false
                    }
                }
            }
        }.resume()
    }


}



import SwiftUI

enum AccountType {
    case teacher, learner
}

struct LoginPage: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var selectedAccountType: AccountType? = nil
    @Binding var isLoggedIn: Bool

    var body: some View {
        ZStack {
            // Apply the blur effect here
            BlurView()
                .padding(.horizontal, 250)
                .padding(.vertical, 110)
                .cornerRadius(5)
                
            
            VStack {
                Spacer()

                // Login Form
                HStack(spacing: 20) {
                    // Account Type Selection
                    VStack(alignment: .leading) {
                        Text("Choose Account Type")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.bottom, 40)
                        

                        HStack {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .padding(.horizontal, 8)
                            VStack (alignment: .leading){
                                Text("Teacher")
                                    .fontWeight(.medium)
                                Text("I teach things")
                                    .font(.system(size: 12))
                                    .opacity(0.4)
                                    .fontWeight(.light)
                            }
                            Spacer()
                        }
                        .frame(width: 240, height: 30)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.3))
                        .hoverEffect()
                        .padding(0) // Ensure no padding is applied
                        .cornerRadius(12)
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
                                    .font(.system(size: 12))
                                    .opacity(0.4)
                                    .fontWeight(.light)
                            }
                            Spacer()
                        }
                        .frame(width: 240, height: 30)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.3))
                        .hoverEffect()
                        .padding(0) // Ensure no padding is applied
                        .cornerRadius(12)
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
                            .font(.title)
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

                        
                        Button(action: {
                            isLoggedIn = true
                        }) {
                            Text("Login")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .frame(width: 130, height: 28)
                        .padding(.top, 30)
                        
                        
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
    }
}

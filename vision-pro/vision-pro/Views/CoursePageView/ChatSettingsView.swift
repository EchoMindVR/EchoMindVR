import SwiftUI

struct FrostedGlassView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct SettingsView: View {
    @State private var selectedLearningStyle = "Visual"
    let learningStyles = ["Visual", "Auditory", "Kinesthetic"]
    @State private var otherInstructions = ""
    
    var body: some View {
        ZStack {

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // Action to close settings
                    }) {
                        Image(systemName: "xmark")
                    }
                }
                .padding()
                
                Text("Settings")
                    .font(.title)
                    .padding(.bottom)
                
                Divider()
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("Parameters")
                            .padding(.top)
                        
                        Text("Learning Style")
                            .foregroundStyle(Color.gray)
                            .fontWeight(.light)
                        
                        Picker("Learning Style", selection: $selectedLearningStyle) {
                            ForEach(learningStyles, id: \.self) { style in
                                Text(style).tag(style)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
//                        .padding(.vertical)
                    }
                    .padding(.horizontal, 10)
                    
                    VStack(alignment: .leading) {
                        Text("Teacher")
                            .foregroundStyle(Color.gray)
                            .fontWeight(.light)
                            .padding(.vertical)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<3) { _ in
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    VStack(alignment: .leading) {
                        Text("Other Instructions")
                            .foregroundStyle(Color.gray)
                            .fontWeight(.light)
                            .padding(.vertical)
                        
                        TextField("Enter Your Instructions", text: $otherInstructions)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom)
                    }
                    .padding(.horizontal, 10)
                }
                .background(Color.black.opacity(0.35))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                
                
                Spacer()
                
                Image("visionTrigger")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
                    .padding(.bottom, 35)
            }
            .frame(width: 360) // Fixed width for the settings view
            .background(Color.gray.opacity(0.35)) // Match the background style
            .cornerRadius(20)
            .padding()
        }
    }
}


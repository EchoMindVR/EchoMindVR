import SwiftUI

struct TypingTextView: View {
    let text: String
    @State private var displayedText = ""
    @State private var counter = 0
    @State private var timer: Timer?

    var body: some View {
        Text(displayedText)
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { _ in
                    if counter < text.count {
                        let index = text.index(text.startIndex, offsetBy: counter)
                        displayedText.append(text[index])
                        counter += 1
                    } else {
                        timer?.invalidate()
                    }
                }
            }
            .multilineTextAlignment(.center)
            .font(.system(size: 62))
            .fontWeight(.medium)
            .padding(.horizontal, 200)
    }
}

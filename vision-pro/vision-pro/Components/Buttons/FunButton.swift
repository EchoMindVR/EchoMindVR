// Not much reusability in this codebase at all..

import SwiftUI

struct FunButton: View {
    @Binding var onTap: () -> Void;
    var body: some View {
        Button(action: onTap) {
            Text("Login")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .frame(width: 130, height: 28)
        .padding(.top, 30)
    }
}

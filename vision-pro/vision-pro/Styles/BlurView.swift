import SwiftUI

// Create a BlurView that conforms to UIViewRepresentable
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterialDark
    var cornerRadius: CGFloat = 30

   func makeUIView(context: Context) -> UIVisualEffectView {
       let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
       // Apply corner radius to UIVisualEffectView
       view.layer.cornerRadius = cornerRadius
       // Enable clipping
       view.clipsToBounds = true
       return view
   }

   func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
       uiView.effect = UIBlurEffect(style: style)
       uiView.layer.cornerRadius = cornerRadius
   }

}

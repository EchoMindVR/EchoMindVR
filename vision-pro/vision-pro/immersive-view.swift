//
//  ImmersiveView.swift
//  vision-pro
//
//  Created by Benny Wu on 2024-03-30.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity.load(named: "Immersive", in: nil) {
                content.add(immersiveContentEntity)

                if let resource = try? await EnvironmentResource.load(named: "ImageBasedLight", in: Bundle.main) {
                    let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.25)
                    immersiveContentEntity.components.set(iblComponent)
                    immersiveContentEntity.components.set(ImageBasedLightReceiverComponent())
                }

                // Put skybox here.  See example in World project available at
                // https://developer.apple.com/
                if let skyboxTexture = try? TextureResource.load(named: "SkyboxTexture", in: Bundle.main) {
                    content.scene.skybox = Skybox(texture: skyboxTexture)
                }

                content.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
                content.view.isUserInteractionEnabled = true

                // animation, figure out later
                // let animation = AnimationResource.generate(for: immersiveContentEntity)
                // immersiveContentEntity.playAnimation(animation.repeat(duration: .infinity), transitionDuration: 1.0, startsPaused: false)
            }
        }
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let realityView = gestureRecognizer.view as? RealityView else { return }
        let tapLocation = gestureRecognizer.location(in: realityView)

        if let entity = realityView.entity(at: tapLocation) {
            // do things here
            print("Tapped entity: \(entity.name ?? "Unnamed Entity")")
        }
    }
}

struct ImmersiveView_Previews: PreviewProvider {
    static var previews: some View {
        ImmersiveView()
    }
}

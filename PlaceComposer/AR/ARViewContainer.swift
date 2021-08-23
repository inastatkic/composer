// Created by Ina Statkic in 2021.

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject private var virtualData: VirtualData
    
    let arView = ARView(frame: .zero)
    
    func makeUIView(context: Context) -> ARView {
        
        arView.environment.sceneUnderstanding.options = []
        arView.environment.sceneUnderstanding.options.insert(
            [.receivesLighting, .occlusion, .physics])
        
        // MARK: - Configuration
                
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .meshWithClassification
        configuration.planeDetection.insert([.horizontal, .vertical])
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)

        // MARK: - Experience
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        // MARK: - Interaction
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        arView.addGestureRecognizer(tapGesture)
        
        // MARK: - Render
        
        arView.renderOptions.insert(.disableMotionBlur)
        arView.renderOptions.remove(.disableDepthOfField)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        virtualData.virtualObject?.loadAsync()
    }
    
    // MARK: - Coordinator
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var arViewContainer: ARViewContainer
        
        init(_ arViewContainer: ARViewContainer) {
            self.arViewContainer = arViewContainer
        }
        
        // MARK: - Actions
        
        @objc func handleTap(sender: UITapGestureRecognizer) {
            let touchPoint = sender.location(in: arViewContainer.arView)
            // Ray-cast intersected with the real-world surfaces
            // Ray-cast allowing estimated plane with any alignment takes the mesh into account
            if let result = arViewContainer.arView.raycast(from: touchPoint, allowing: .estimatedPlane, alignment: .any).first {
                // Intersection point of the ray with the real-world surface.
                let resultAnchor = AnchorEntity(world: result.worldTransform.position)
                // Place virtual object into real-world space
                if let virtualObject = arViewContainer.virtualData.virtualObject?.entity {
                    place(virtualObject, at: resultAnchor, in: arViewContainer.arView)
                }
            }
        }
        
        private func place(_ entity: ModelEntity, at anchor: AnchorEntity, in arView: ARView) {
            entity.generateCollisionShapes(recursive: true)
            arView.installGestures([.translation, .rotation], for: entity)
            anchor.addChild(entity)
            arView.scene.addAnchor(anchor)
        }
        
    }
    
}

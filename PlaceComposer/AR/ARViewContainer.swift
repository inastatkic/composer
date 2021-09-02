// Created by Ina Statkic in 2021.

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var virtualContent: VirtualContent
    
    let arView = ARViewExperience(frame: .zero)
    
    func makeUIView(context: Context) -> ARViewExperience {

        arView.configure()

        // MARK: - Experience
        
        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
//        arView.scene.anchors.append(boxAnchor)
        
        // MARK: - Interaction
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        arView.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress))
        longPressGesture.allowableMovement = 100
        arView.addGestureRecognizer(longPressGesture)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARViewExperience, context: Context) {
        virtualContent.virtualObject?.loadModelAsync()
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
                if let virtualObject = arViewContainer.virtualContent.virtualObject?.entity {
                    place(virtualObject, at: resultAnchor, in: arViewContainer.arView)
                }
                
            }
        }
        
        @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
            let touchPoint = sender.location(in: arViewContainer.arView)
            // Entity under touch point
            guard let entity = arViewContainer.arView.entity(at: touchPoint) else { return }
            if entity.anchor != nil {

//                let fileManager = FileManager.default
//                guard let documentUrl = fileManager.documentsURL?.appendingPathComponent(entity.name) else { return }
//                let virtualObject = VirtualObject(url: documentUrl)
//                arViewContainer.virtualData.virtualObject = virtualObject
                // TODO: Select Virtual Object
            }
            
        }
        
        private func place(_ entity: ModelEntity, at anchor: AnchorEntity, in arView: ARView) {
//            let entity = entity.clone(recursive: true)
            entity.generateCollisionShapes(recursive: true)
            arView.installGestures([.translation, .rotation], for: entity)
            anchor.addChild(entity)
            arView.scene.addAnchor(anchor)
        }
        
    }
    
}

// Created by Ina Statkic in 2021.

import ARKit
import RealityKit

class ARViewExperience: ARView {
    
    var arView: ARView { return self }
    
    func configure() {
        configureWorldTracking()
    }
    
    private func configureWorldTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .meshWithClassification
        configuration.planeDetection.insert([.horizontal, .vertical])
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
        arView.renderOptions.insert(.disableMotionBlur)
        arView.renderOptions.remove(.disableDepthOfField)
        arView.environment.sceneUnderstanding.options.insert([.collision, .physics, .receivesLighting, .occlusion])
    }
}

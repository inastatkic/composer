// Created by Ina Statkic in 2021.

import Foundation
import RealityKit

extension MeshResource.Contents {
    func forEachPart() {
        for instance in self.instances {
            guard let model = self.models[instance.model] else { continue }
            for part in model.parts {
                print(part.id)
            }
        }
    }
    
    func forEachVertex(_ callback: (SIMD3<Float>) -> Void) {
        for instance in self.instances {
            guard let model = self.models[instance.model] else { continue }
            let instaceToModel = instance.transform
            for part in model.parts {
                for position in part.positions {
                    let vertex = instaceToModel * SIMD4<Float>(position, 1.0)
                    callback([vertex.x, vertex.y, vertex.z])
                }
            }
        }
    }
}

extension MeshResource {
    // Inspect mesh
    func meshRadii(for mesh: MeshResource, numberSlices: Int) {
        var radiusForSlice: [Float] = .init(repeating: 0, count: numberSlices)
        let (minY, maxY) = (mesh.bounds.min.y, mesh.bounds.max.y)
        mesh.contents.forEachVertex { modelPosition in
            let normalizedY = (modelPosition.y - minY) / (maxY - minY)
            let sliceY = min(Int(normalizedY * Float(numberSlices)), numberSlices - 1)
            let radius = length(SIMD2<Float>(modelPosition.z, modelPosition.z))
            radiusForSlice[sliceY] = max(radiusForSlice[sliceY], radius)
        }
        print(radiusForSlice)
    }
}

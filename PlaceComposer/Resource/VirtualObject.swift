// Created by Ina Statkic in 2021.

import Foundation
import Combine
import RealityKit

final class VirtualObject {
    var entity: ModelEntity? {
        didSet {
            if let entity = entity, let materials = entity.model?.materials {
                expectedMaterialCount = entity.model!.mesh.expectedMaterialCount
                for material in materials {
                    let m = material as? PhysicallyBasedMaterial
                    swatches.append(Swatch(baseColor: m!.baseColor))
                    mattes.append(m!.roughness.scale)
                    shinies.append(m!.metallic.scale)
                }
            }
        }
    }
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    init(url: URL, entity: ModelEntity) {
        self.url = url
        self.entity = entity
    }
    
    var swatches: [Swatch] = []
    var mattes: [Float] = []
    var shinies: [Float] = []
    var expectedMaterialCount = 0
    
    // MARK: - Load model
    
    private var loadRequest: AnyCancellable?
    private var streams = [Combine.AnyCancellable]()
    
    enum FileType {
        case uzdz, reality
    }
    
    func loadModelAsync() {
        loadRequest = Entity.loadModelAsync(contentsOf: url).sink { loadCompletion in
                if case let .failure(error) = loadCompletion {
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { modelEntity in
                self.entity = modelEntity
                self.entity?.name = self.url.lastPathComponent
            }
    }
    
}

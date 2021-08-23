// Created by Ina Statkic in 2021.

import Foundation
import Combine
import RealityKit


final class VirtualObject {
    var entity: ModelEntity?
    let url: URL
    
    init(url: URL) {
        self.url = url
    }   
    
    private var loadRequest: AnyCancellable?
    
    func loadAsync() {
        loadRequest = Entity.loadModelAsync(contentsOf: url)
            .sink { loadCompletion in
                if case let .failure(error) = loadCompletion {
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { modelEntity in
                self.entity = modelEntity
            }
    }

}

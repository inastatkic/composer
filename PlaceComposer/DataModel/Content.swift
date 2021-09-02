// Created by Ina Statkic in 2021.

import Combine

final class VirtualContent: ObservableObject {
    @Published var virtualObject: VirtualObject?
    @Published var compositions: [Composition] = []
}


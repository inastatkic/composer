// Created by Ina Statkic in 2021.

import SwiftUI

final class VirtualData: ObservableObject {
    @Published var virtualObject: VirtualObject?
    @Published var compositions: [Composition] = []
}


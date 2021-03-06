// Created by Ina Statkic in 2021.

import SwiftUI

struct CompositionView: View {
    var composition: Composition
    
    var body: some View {
        composition.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
    }
}

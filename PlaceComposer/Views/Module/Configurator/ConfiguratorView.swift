// Created by Ina Statkic in 2021.

import SwiftUI
import RealityKit

struct Configuration {
    var colors: [Color] = []
    var mattes: [Float] = []
    var shinies: [Float] = []
    var pbrs: [PhysicallyBasedMaterial] = []
}

struct ConfiguratorView: View {
    @EnvironmentObject var virtualData: VirtualContent
    @State private var configuration = Configuration()
    
    var body: some View {
        if let virtualObject = virtualData.virtualObject {
            ForEach(virtualObject.swatches.numbered(), id: \.number) { number, swatch in
                HStack(alignment: .center) {
                    if number < configuration.mattes.count {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Matte").font(.caption)
                            Slider(value: $configuration.mattes[number])
                        }
                    }
                    if number < configuration.shinies.count {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Shiny").font(.caption)
                            Slider(value: $configuration.shinies[number])
                        }
                    }
                    if number < configuration.colors.count {
                        VStack(spacing: 3) {
                            Text("").font(.caption)
                            ColorPicker("",
                                        selection: $configuration.colors[number],
                                        supportsOpacity: false)
                                .frame(width: 28)
                        }
                    }
                }
                .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                .onAppear {
                    configuration.colors = virtualObject.swatches.map {
                        Color($0.baseColor.tint)
                    }
                    configuration.mattes = virtualObject.mattes
                    configuration.shinies = virtualObject.shinies
                    configuration.pbrs = Array(repeating: PhysicallyBasedMaterial(), count: virtualObject.expectedMaterialCount)
                }
                .onChange(of: configuration.mattes) { newState in
                    if number < configuration.mattes.count && number < configuration.pbrs.count {
                        configuration.pbrs[number].roughness = PhysicallyBasedMaterial.Roughness(floatLiteral: newState[number])
                        virtualObject.entity?.model?.materials[number] = configuration.pbrs[number]
                    }
                }
                .onChange(of: configuration.shinies) { newState in
                    if number < configuration.shinies.count && number < configuration.pbrs.count {
                        configuration.pbrs[number].metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: newState[number])
                        virtualObject.entity?.model?.materials[number] = configuration.pbrs[number]
                    }
                }
                .onChange(of: configuration.colors) { newState in
                    if number < configuration.colors.count && number < configuration.pbrs.count {
                        configuration.pbrs[number].baseColor = PhysicallyBasedMaterial.BaseColor(tint: UIColor(newState[number]))
                        virtualObject.entity?.model?.materials[number] = configuration.pbrs[number]
                    }
                }
                .onDisappear {
                    configuration = Configuration()
                }
            }
        }
    }
}

struct SwatchView_Previews: PreviewProvider {
    static var previews: some View {
        ConfiguratorView()
    }
}

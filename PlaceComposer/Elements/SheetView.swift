// Created by Ina Statkic in 2021.

import SwiftUI

struct SheetView<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._isPresented = isPresented
    }
    
    var body: some View {
        GeometryReader { geometry in
            if isPresented == true {
                VStack(spacing: 0) {
                    ScrollView { content.padding() }
                }
                .frame(width: geometry.size.width, alignment: .top)
                .background(.thinMaterial)
                .cornerRadius(15)
            }
        }
    }
}

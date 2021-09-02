// Created by Ina Statkic in 2021.

import SwiftUI

struct ContentView : View {
    @State private var showCompositions: Bool = false
    @State private var configure: Bool = false
    
    var body: some View {
        ZStack {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)
            VStack {
                Spacer()
                SheetView(isPresented: $configure) {
                    ConfiguratorView()
                }
                .frame(height: 120)
                .padding()
                Button { configure.toggle()
                } label: {
                    Image(systemName: "cube")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }
                Button { showCompositions.toggle()
                    configure = false
                } label: {
                    Image(systemName: "circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.white)
                        .padding()
                }.sheet(isPresented: $showCompositions) {
                    CompositionsView()
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

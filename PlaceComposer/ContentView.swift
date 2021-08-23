// Created by Ina Statkic in 2021.

import SwiftUI

struct ContentView : View {
    @State private var showCompositions: Bool = false
    
    var body: some View {
        ZStack {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Button {
                    showCompositions.toggle()
                } label: {
                    Image(systemName: "circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.gray)
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

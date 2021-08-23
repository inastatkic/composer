// Created by Ina Statkic in 2021.

import SwiftUI

struct CompositionsView: View {
    @State private var openDocument: Bool = false
    @EnvironmentObject private var virtualData: VirtualData
    
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 90), spacing: 10)]
        
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 10) {
                Button {
                    openDocument.toggle()
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }.sheet(isPresented: $openDocument) {
                    DocumentPicker()
                }
                ForEach(virtualData.compositions) { composition in
                    CompositionView(composition: composition)
                        .onTapGesture {
                            virtualData.virtualObject = nil
                            virtualData.virtualObject = VirtualObject(url: composition.url)
                        }
                }
            }.padding(.vertical)
        }
    }
}

struct CompositionsView_Previews: PreviewProvider {
    static var previews: some View {
        CompositionsView().environmentObject(VirtualData())
    }
}

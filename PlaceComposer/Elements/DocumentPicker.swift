// Created by Ina Statkic in 2021.

import SwiftUI
import RealityKit
import QuickLookThumbnailing
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @EnvironmentObject private var virtualData: VirtualData
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.usdz, .realityFile])
        
        picker.delegate = context.coordinator
    
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
    // MARK: - Coordinator
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var documentPicker: DocumentPicker
        
        init(_ documentPicker: DocumentPicker) {
            self.documentPicker = documentPicker
        }
        
        // MARK: DocumentPicker Delegate
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let fileUrl = urls.first else { return }
            // Start accessing a security-scoped resource.
            guard fileUrl.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return
            }

            // Make sure you release the security-scoped resource when you finish.
            defer { fileUrl.stopAccessingSecurityScopedResource() }
            
            // Use file coordination for reading and writing any of the URL’s content.
            var error: NSError? = nil
            NSFileCoordinator().coordinate(readingItemAt: fileUrl, error: &error) { url in
    
                let fileManager = FileManager.default
                guard let documentsUrl = fileManager.documentsURL?.appendingPathComponent(url.lastPathComponent) else { return }
                    if fileManager.fileExists(atPath: documentsUrl.path) {
                        try? fileManager.removeItem(atPath: documentsUrl.path)
                    }
                    try? fileManager.copyItem(atPath: url.path, toPath: documentsUrl.path)
                    let virtualObject = VirtualObject(url: documentsUrl)
                    documentPicker.virtualData.virtualObject = virtualObject
                
                // Generate Thumbnail Image
                let scale = UIScreen.main.scale
                let request = QLThumbnailGenerator.Request(fileAt: url, size: CGSize(width: 100, height: 100), scale: scale, representationTypes: .all)
                let generator = QLThumbnailGenerator.shared
                generator.generateBestRepresentation(for: request) { thumbnail, error in
                    DispatchQueue.main.async {
                        if let thumbnail = thumbnail {
                            let image = Image(uiImage: thumbnail.uiImage)
                            let composition = Composition(url: documentsUrl, image: image)
                            self.documentPicker.virtualData.compositions.append(composition)
                        } else if let error = error {
                            debugPrint(error.localizedDescription)
                        }
                    }
                }
    
 
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            
        }
    }
    
}

// Created by Ina Statkic in 2021.

import SwiftUI
import QuickLookThumbnailing

struct DocumentPicker: UIViewControllerRepresentable {
    @EnvironmentObject var virtualContent: VirtualContent
    
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
                guard let documentUrl = fileManager.documentsURL?.appendingPathComponent(url.lastPathComponent) else { return }
//                documentUrl.pathExtension

                if fileManager.fileExists(atPath: documentUrl.path) {
                    try? fileManager.removeItem(atPath: documentUrl.path)
                }
                try? fileManager.copyItem(atPath: url.path, toPath: documentUrl.path)
                let virtualObject = VirtualObject(url: documentUrl)
                documentPicker.virtualContent.virtualObject = virtualObject
                
                // Generate Thumbnail Image
                let scale = UIScreen.main.scale
                let request = QLThumbnailGenerator.Request(fileAt: documentUrl, size: CGSize(width: 100, height: 100), scale: scale, representationTypes: .all)
                let generator = QLThumbnailGenerator.shared
                generator.generateBestRepresentation(for: request) { thumbnail, error in
                    DispatchQueue.main.async {
                        if let thumbnail = thumbnail {
                            let image = Image(uiImage: thumbnail.uiImage)
                            let composition = Composition(url: documentUrl, image: image)
                            self.documentPicker.virtualContent.compositions.append(composition)
                        } else if let error = error {
                            debugPrint(error.localizedDescription)
                        }
                    }
                }
    
            }
        }
    }
    
}

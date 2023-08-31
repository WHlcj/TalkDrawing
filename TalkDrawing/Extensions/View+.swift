
import SwiftUI

extension View {
    /// 截图，并保存进手机相册
    func snapshot() {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        let image = renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        saveComics(images: [image])
    }
    
    private func saveComics(images: [UIImage]) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsDirectory.appendingPathComponent("SavedImages")
    
        // Ensure folder exists
        createLocalImagesFolderIfNeeded()
        do {
            for (index, image) in images.enumerated() {
                let timestamp = Date().timeIntervalSince1970

                let fileURL = folderURL.appendingPathComponent("image\(timestamp)_\(index).png")
                if let data = image.pngData() {
                    try data.write(to: fileURL)
                    print("Image saved successful")
                }
            }
        } catch {
            print("Error saving images locally: \(error)")
        }
    }
    
    private func createLocalImagesFolderIfNeeded() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsDirectory.appendingPathComponent("SavedImages")
        
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating local images folder: \(error)")
            }
        }
    }
}

import SwiftUI

class PhotoStorage: ObservableObject {
    static let shared = PhotoStorage()
    
    @Published private(set) var photos: [RestoredPhoto] = []
    private let directory: URL
    
    private init() {
        let fm = FileManager.default
        directory = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("RestoredPhotos")
        try? fm.createDirectory(at: directory, withIntermediateDirectories: true)
        loadPhotos()
    }
    
    func save(image: UIImage) {
        let id = UUID()
        let url = directory.appendingPathComponent("\(id.uuidString).jpg")
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        do {
            try data.write(to: url)
            let photo = RestoredPhoto(id: id, url: url)
            photos.append(photo)
        } catch {
            print("Failed to save image: \(error)")
        }
    }
    
    func delete(_ photo: RestoredPhoto) {
        do {
            try FileManager.default.removeItem(at: photo.url)
        } catch {
            print("Failed to delete image: \(error)")
        }
        photos.removeAll { $0.id == photo.id }
    }
    
    func clear() {
        for photo in photos {
            try? FileManager.default.removeItem(at: photo.url)
        }
        photos.removeAll()
    }
    
    private func loadPhotos() {
        let fm = FileManager.default
        guard let files = try? fm.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil) else { return }
        photos = files.compactMap { url in
            let idString = url.deletingPathExtension().lastPathComponent
            return RestoredPhoto(id: UUID(uuidString: idString) ?? UUID(), url: url)
        }.sorted { $0.id.uuidString < $1.id.uuidString }
    }
}

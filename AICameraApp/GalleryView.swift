import SwiftUI

struct GalleryView: View {
    @ObservedObject var storage = PhotoStorage.shared
    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.adaptive(minimum: 100))]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(storage.photos) { photo in
                        if let image = UIImage(contentsOfFile: photo.url.path) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .contextMenu {
                                    Button("Delete", role: .destructive) {
                                        storage.delete(photo)
                                    }
                                }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Gallery")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !storage.photos.isEmpty {
                        Button("Clear", role: .destructive) {
                            storage.clear()
                        }
                    }
                }
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}

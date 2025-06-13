import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var showCamera = false
    @State private var originalImage: UIImage?
    @State private var restoredImage: UIImage?
    private let restorationModel = PhotoRestorationModel()

    var body: some View {
        NavigationView {
            VStack {
                if let image = restoredImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                } else if let image = originalImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                } else {
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(height: 300)
                        .overlay(Text("No Photo"))
                }

                HStack {
                    Button("Take Photo") {
                        showCamera.toggle()
                    }
                    .padding()

                    if originalImage != nil {
                        Button("Restore Photo") {
                            if let original = originalImage {
                                restoredImage = restorationModel.restore(image: original)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("AI Photo Restorer")
            .sheet(isPresented: $showCamera) {
                ImagePicker(image: $originalImage)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var showImagePicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .camera
    @State private var originalImage: UIImage?
    @State private var restoredImage: UIImage?
    @State private var showShareSheet = false
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
                        pickerSource = .camera
                        showImagePicker.toggle()
                    }
                    .padding()

                    Button("Choose Photo") {
                        pickerSource = .photoLibrary
                        showImagePicker.toggle()
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
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $originalImage, sourceType: pickerSource)
            }
            .sheet(isPresented: $showShareSheet) {
                if let image = restoredImage {
                    ShareSheet(activityItems: [image])
                }
            }
            .toolbar {
                if restoredImage != nil {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            showShareSheet = true
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }

                        Button {
                            saveRestoredImage()
                        } label: {
                            Label("Save", systemImage: "square.and.arrow.down")
                        }
                    }
                }
            }
        }
    }

    private func saveRestoredImage() {
        if let image = restoredImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

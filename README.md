# AICameraApp

An iOS app that lets you capture old family photos and restore them on device using a Core ML model. The app is built with SwiftUI and runs the deep learning model locally so no network connection is required for processing.

## Features
- Capture photos using the device camera.
- Select existing photos from the photo library.
- Run a photo restoration model on the captured image.
- Display the restored image alongside the original.

## Requirements
- Xcode 15 or later.
- iOS 17 SDK.
- A device capable of running Core ML models (e.g. iPhone with A12 Bionic or newer).

## Building
1. Create a new SwiftUI iOS project in Xcode and add the files inside the `AICameraApp` directory.
2. Add a compiled Core ML model named `PhotoRestoration.mlmodel` to the project. Xcode will produce a `.mlmodelc` compiled model that the app expects.
3. Ensure the `Info.plist` contains camera and photo library usage descriptions.
4. Build and run on a physical device.

The sample `PhotoRestorationModel` class expects the model to take an image input and produce an image output. You can replace it with any Core ML model that performs image restoration.

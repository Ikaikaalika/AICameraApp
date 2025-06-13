import CoreML
import UIKit
import Vision

class PhotoRestorationModel {
    private let model: VNCoreMLModel?

    init() {
        if let url = Bundle.main.url(forResource: "PhotoRestoration", withExtension: "mlmodelc") {
            model = try? VNCoreMLModel(for: MLModel(contentsOf: url))
        } else {
            model = nil
        }
    }

    func restore(image: UIImage) -> UIImage? {
        guard let model = model else { return nil }
        guard let cgImage = image.cgImage else { return nil }
        let request = VNCoreMLRequest(model: model)
        request.imageCropAndScaleOption = .scaleFit
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])

        guard let results = request.results as? [VNPixelBufferObservation],
              let first = results.first else {
            return nil
        }

        let ciImage = CIImage(cvPixelBuffer: first.pixelBuffer)
        let context = CIContext()
        if let outputCG = context.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: outputCG)
        }
        return nil
    }
}

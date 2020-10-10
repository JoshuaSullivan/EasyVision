import Foundation
import AVFoundation
import CoreML
import Vision
import Combine

/// The errors that can emerge from the ClassificationService.
///
public enum ClassificationServiceError: Error {
    case unableToClassifyImage
}

/// A protocol describing the public interface of the ClassificationService.
///
public protocol ClassificationServiceProtocol: class {

    /// A publisher that asynchronously emits the results of classifications recieved using the input
    /// of the `classify(image:)` method.
    ///
    /// - Note: This publisher sends on the main thread.
    ///
    var classifications: AnyPublisher<[Classification], ClassificationServiceError> { get }

    /// Provide an image to be classified.
    ///
    /// The result will be emitted by the `classifications` publisher asynchronously.
    ///
    /// - Parameter image: A CVPixelBuffer containing the image to be classified. The pixel buffer will
    ///                    be automatically resized using the `.centerCrop` method if it is not square.
    /// - Parameter orientation: The orientation of the image. It is important to pass this in with live
    ///                          video, or you will get very poor classification results. The current
    ///                          device orientation can be obtained from `UIDevice.current.orientation`.
    ///
    func classify(image: CVPixelBuffer, orientation: CGImagePropertyOrientation)

    /// Limits the number of classification results to only the N with the highest confidence values.
    /// The default value is `nil` which does not limit the number of results.
    ///
    /// Models generally return hundreds of classification results; one for each class it recognizes.
    /// For that reason, it is often helpful to only receive a subset of the most relevant results. You
    /// are much more likely to be interested in a result of "dog" with 72% confidence than a result
    /// of "tree" with 0.002% confidence.
    ///
    var maxResults: Int? { get set }
}

public class ClassificationService: ClassificationServiceProtocol {

    /// Store the Vision Core ML request that wraps our ML model.
    private var request: VNCoreMLRequest!

    // Protocol implementation.
    public var maxResults: Int?

    /// Converts the concrete publisher into an AnyPublisher.
    public var classifications: AnyPublisher<[Classification], ClassificationServiceError> {
        classificationPublisher
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }

    /// The concrete publisher of classification results.
    private let classificationPublisher = PassthroughSubject<[Classification], ClassificationServiceError>()

    /// Initialize the service with a particular CoreML
    public init(model: MLModel) {
        do {
            let visionModel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            }
            request.imageCropAndScaleOption = .centerCrop
            self.request = request
        } catch {
            fatalError("Could not create a vision model.")
        }
    }

    // TODO: This class should be updated to allow for more model types than just classifiers.

    private func processClassifications(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
            // We ignore nil results.
            return
        }
        guard let classificationResults = results as? [VNClassificationObservation] else {
            print("Unable to process results: \(results)")
            return
        }
        let classifications: [Classification]
        if let maxResults = maxResults {
            classifications = classificationResults.prefix(maxResults).map { Classification(label: $0.identifier, confidence: $0.confidence) }
        } else {
            classifications = classificationResults.map { Classification(label: $0.identifier, confidence: $0.confidence) }
        }
        self.classificationPublisher.send(classifications)
    }

    public func classify(image: CVPixelBuffer, orientation: CGImagePropertyOrientation) {
        DispatchQueue.global(qos: .default).async {
            let handler = VNImageRequestHandler(cvPixelBuffer: image, orientation: orientation)
            do {
                try handler.perform([self.request])
            } catch {
                print("Failed to perform classification: \(error.localizedDescription)")
                self.classificationPublisher.send(completion: .failure(.unableToClassifyImage))
            }
        }
    }
}

import Foundation
import AVFoundation
import Combine

public protocol VideoClassificationViewModelProtocol: ObservableObject {

    /// The AVCaptureSession driving live video capture.
    ///
    /// Used to start/stop video capture as well as configuring the `AVCaptureVideoPreviewLayer`.
    ///
    var session: AVCaptureSession { get }

    /// A `@Published` variable containing the current classification result.
    ///
    var currentClassification: Classification? { get }

    /// A wrapper for the `currentClassification` property that exposes it as a Publisher for UIKit.
    var classificationPublisher: AnyPublisher<Classification?, Never> { get }

    func startVideoCapture()

    func stopVideoCapture()
}

public class VideoClassificationViewModel: VideoClassificationViewModelProtocol {

    public var session: AVCaptureSession { cameraService.session }

    private let cameraService: CameraServiceProtocol

    private let classificationService: ClassificationServiceProtocol

    @Published public var currentClassification: Classification?

    public var classificationPublisher: AnyPublisher<Classification?, Never> {
        return $currentClassification.eraseToAnyPublisher()
    }

    private var cameraSubscription: AnyCancellable?
    private var classificationSubscription: AnyCancellable?

    public init(cameraService:CameraServiceProtocol, classificationService: ClassificationServiceProtocol) {
        self.cameraService = cameraService
        self.classificationService = classificationService

        setupPipeline()
    }

    private func setupPipeline() {

        // Set up the camera service. We'll limit the identification rate to 2/sec to reduce energy use.

        cameraSubscription = cameraService.pixelBufferOutput
            .throttle(for: 0.5, scheduler: DispatchQueue.main, latest: true)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.currentClassification = nil
                },
                receiveValue: { [weak self] pixelBuffer in
                    self?.classificationService.classify(image: pixelBuffer)
                }
            )

        // Set up the classification service.

        classificationService.maxResults = 1
        classificationSubscription = classificationService.classifications
            .sink(receiveCompletion: { [weak self] completion in
                // This only completes on error, so we'll just nil out the classification.
                self?.currentClassification = nil
            },
            receiveValue: { [weak self] classifications in
                self?.currentClassification = classifications.first
            })

    }

    public func startVideoCapture() {
        cameraService.startVideoCapture()
    }

    public func stopVideoCapture() {
        cameraService.stopVideoCapture()
    }
}

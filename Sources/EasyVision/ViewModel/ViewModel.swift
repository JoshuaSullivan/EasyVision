import UIKit
import AVFoundation
import Combine

// MARK: - SwiftUI

/// The public interface of the view model for SwiftUI views.
///
/// This version inherits from `ObservableObject` and exposes the classification results in the form
/// of an `@Published` property.
///
public protocol SwiftUIViewModelProtocol : ObservableObject {
    /// The AVCaptureSession driving live video capture.
    ///
    /// Used to start/stop video capture as well as configuring the `AVCaptureVideoPreviewLayer`.
    ///
    var session: AVCaptureSession { get }

    /// A `@Published` variable containing the current classification result.
    ///
    var currentClassification: Classification? { get }

    /// Start live video capture.
    ///
    func startVideoCapture()

    /// Stop live video capture.
    ///
    func stopVideoCapture()
}

/// The SwiftUI implementation of the View Model.
///
public class SwiftUIViewModel: CoreViewModel, SwiftUIViewModelProtocol {
    override public init(cameraService:CameraServiceProtocol, classificationService: ClassificationServiceProtocol) {
        super.init(cameraService: cameraService, classificationService: classificationService)
    }
}

// MARK: - UIKit

/// The public interface of the view model for UIKit classes.
///
/// This version does not inherit from ObservableObject, which is not a thing in UIKit. It also
/// exposes the classification results as a publisher rather than an `@Published` variable.
///
public protocol UIKitViewModelProtocol {
    /// The AVCaptureSession driving live video capture.
    ///
    /// Used to start/stop video capture as well as configuring the `AVCaptureVideoPreviewLayer`.
    ///
    var session: AVCaptureSession { get }

    /// A publisher that sends the latest classification result.
    ///
    var classificationPublisher: AnyPublisher<Classification?, Never> { get }

    /// Start live video capture.
    ///
    func startVideoCapture()

    /// Stop live video capture.
    ///
    func stopVideoCapture()
}

/// The UIKit implementation of the View Model.
///
public class UIKitViewModel: CoreViewModel, UIKitViewModelProtocol {
    override public init(cameraService:CameraServiceProtocol, classificationService: ClassificationServiceProtocol) {
        super.init(cameraService: cameraService, classificationService: classificationService)
    }
}

// MARK: - Core

/// This class underpins both the SwiftUI and UIKit versions of the ViewModel.
///
/// This class should never be instantiated directly. Instead, instantiate one of `SwiftUIViewModel` or
/// `UIKitViewModel` depending on the context you are using it in.
///
public class CoreViewModel {

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
                    guard let self = self else { return }
                    let orientation = self.cameraService.orientation
                    self.classificationService.classify(image: pixelBuffer, orientation: orientation)
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

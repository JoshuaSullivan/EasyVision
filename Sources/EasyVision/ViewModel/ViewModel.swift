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

    /// Returns a preview view for displaying live video.
    var videoPreview: VideoPreview { get }

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
public class SwiftUIViewModel: ViewModelCore, SwiftUIViewModelProtocol {

    public var videoPreview: VideoPreview

    private var connection: AVCaptureConnection?

    /// Initializes an instance of `SwiftUIViewModel`.
    ///
    /// - Parameter cameraService: An object conforming to `CameraServiceProtocol`
    /// - Parameter classificationService: An object conforming to `ClassificationServiceProtocol`
    ///
    override public init(cameraService:CameraServiceProtocol, classificationService: ClassificationServiceProtocol) {

        // Instantiate the VideoPreviewView which underpins the VideoPreview.
        let preview = VideoPreviewView(frame: .zero)
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.videoPreviewLayer.videoGravity = .resizeAspectFill
        preview.videoPreviewLayer.session = cameraService.session

        // Store a reference to the connection so that the orientation can be updated.
        connection = preview.videoPreviewLayer.connection

        // Instantiate the videoPreview
        videoPreview = VideoPreview(preview: preview)

        super.init(cameraService: cameraService, classificationService: classificationService)
    }

    override func updatePreviewOrientation(to orientation: Orientation) {
        guard
            let connection = connection,
            connection.isVideoOrientationSupported
        else { return }

        connection.videoOrientation = orientation.avOrientation
    }
}

// MARK: - UIKit

/// The public interface of the view model for UIKit classes.
///
/// This version does not inherit from ObservableObject, which is not a thing in UIKit. It also
/// exposes the classification results as a publisher rather than an `@Published` variable.
///
public protocol UIKitViewModelProtocol {

    /// Returns a preview view for displaying live video.
    var previewView: VideoPreviewView { get }

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
public class UIKitViewModel: ViewModelCore, UIKitViewModelProtocol {

    public lazy var previewView: VideoPreviewView = {
        let view = VideoPreviewView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }()

    override public init(cameraService:CameraServiceProtocol, classificationService: ClassificationServiceProtocol) {
        super.init(cameraService: cameraService, classificationService: classificationService)
    }

    override func updatePreviewOrientation(to orientation: Orientation) {
        guard
            let connection = previewView.videoPreviewLayer.connection,
            connection.isVideoOrientationSupported
        else { return }

        connection.videoOrientation = orientation.avOrientation
    }
}

// MARK: - Core

/// This class underpins both the SwiftUI and UIKit versions of the ViewModel.
///
/// This class should never be instantiated directly. Instead, instantiate one of `SwiftUIViewModel` or
/// `UIKitViewModel` depending on the context you are using it in.
///
public class ViewModelCore {

    /// The capture session which drives the live video.
    public var session: AVCaptureSession { cameraService.session }

    /// The camera service.
    private let cameraService: CameraServiceProtocol

    /// The classification service.
    private let classificationService: ClassificationServiceProtocol

    /// A published var for the latest classification.
    @Published public var currentClassification: Classification?

    /// Wraps the `currentClassification` publisher.
    public var classificationPublisher: AnyPublisher<Classification?, Never> {
        return $currentClassification.eraseToAnyPublisher()
    }

    /// Store the last observed orientation.
    private var orientation: Orientation = .portrait

    private var cameraSubscription: AnyCancellable?
    private var orientationSubscription: AnyCancellable?
    private var classificationSubscription: AnyCancellable?

    fileprivate init(cameraService:CameraServiceProtocol, classificationService: ClassificationServiceProtocol) {
        self.cameraService = cameraService
        self.classificationService = classificationService

        setupPipeline()
    }

    /// Links the camera service to the classification service and then links the classification result
    /// to a publisher for consumption by the UI.
    ///
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
                    self.classificationService.classify(image: pixelBuffer, orientation: self.orientation.cgOrientation)
                }
            )

        orientationSubscription = cameraService.orientation
            .sink { [weak self] orientation in
                self?.set(orientation: orientation)
            }

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

    /// Set the orientation based on device orientation changes.
    private func set(orientation: Orientation) {
        self.orientation = orientation
        updatePreviewOrientation(to: orientation)
    }

    /// Update the video preview to match the new device orientation.
    func updatePreviewOrientation(to orientation: Orientation) {
        // Nothing in this implementation. The child classes will override it and
        // implement their own solutions.
    }

    /// Start video capture in the camera service.
    public func startVideoCapture() {
        cameraService.startVideoCapture()
    }

    /// Stop video capture in the camera service.
    public func stopVideoCapture() {
        cameraService.stopVideoCapture()
    }

}

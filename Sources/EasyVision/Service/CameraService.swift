import UIKit
import AVFoundation
import Combine

/// The types of errors the CameraService can emit.
///
public enum CameraServiceError: Error {
    case failedToCapturePhoto
    case failedToProducePixelBuffer
}

/// The public interface to the CameraService.
///
public protocol CameraServiceProtocol: class {

    /// The underlying AVCaptureSession. Useful for setting up video preview layers.
    var session: AVCaptureSession { get }

    /// A publisher that will emit captured photos when the capture button is tapped.
    var imageOutput: AnyPublisher<UIImage, CameraServiceError> { get }

    /// A publisher that will emit any pixel buffers received from the AVCaptureSession.
    ///
    /// - Note: This publisher will emit pixel buffers as quickly as the camera produces them.
    ///         If your downstream use for the buffer cannot handle 60Hz input, it is recommend
    ///         you make use of the `throttle(for:scheduler:latest:)` publisher to slow its output.
    ///
    /// - Warning: This publisher sends on a background thread. You may need to use the `.receive(on:)`
    ///            publisher to move the stream to the main thread if you're affecting the view hierarchy.
    ///
    var pixelBufferOutput: AnyPublisher<CVPixelBuffer, CameraServiceError> { get }

    /// Start live video capture.
    func startVideoCapture()

    /// Stop live video capture.
    func stopVideoCapture()

    /// Take a photo.
    ///
    /// The result will be emitted by the `imageOutput` publisher.
    ///
    func takePhoto()
}

/// The camera service provides a simple interface for starting and stopping the live preview
/// of the camera as well as capturing photos.
///
/// - Note: You should not attempt to instantiate more than one `CameraService` at a time.
///         AVFoundation doesn't like multiple objects attempting to configure the input.
///
public class CameraService: NSObject, CameraServiceProtocol {

    public var imageOutput: AnyPublisher<UIImage, CameraServiceError> {
        return imagePublisher
            .share()
            .eraseToAnyPublisher()
    }

    /// This implementation throttles the output of the pixel buffer so that we don't burn the battery trying to do
    /// classifications 60 times per second.
    ///
    public var pixelBufferOutput: AnyPublisher<CVPixelBuffer, CameraServiceError> {
        return pixelBufferPublisher
            .share()
            .eraseToAnyPublisher()
    }

    private(set) public var session = AVCaptureSession()

    /// Keep a reference to the photo output so we can trigger a photo capture.
    private var photoOutput = AVCapturePhotoOutput()

    /// Keep a reference to the pixel buffer output so we can disable that independently, should we need to.
    private var pixelOutput = AVCaptureVideoDataOutput()

    /// The underlying publisher for the `imageOutput` property.
    private let imagePublisher = PassthroughSubject<UIImage, CameraServiceError>()

    /// The underlying publisher for the `pixelBufferOutput` property.
    private let pixelBufferPublisher = PassthroughSubject<CVPixelBuffer, CameraServiceError>()

    /// A private dispatch queue to handle incoming pixel buffers.
    private let sampleQueue = DispatchQueue(label: "camera-sample-queue", qos: .default, attributes: [], autoreleaseFrequency: .inherit, target: nil)

    /// Create an instance of the CameraService.
    ///
    public override init() {

        super.init()

        // Use the discovery session API to reliably find a camera to use.
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        guard let inputDevice = discoverySession.devices.first else {
            assertionFailure("Could not find any suitable cameras.")
            return
        }

        // Set up the AVCaptureSession.
        session.beginConfiguration()

        // Since there are several exit points from this method, I'll use defer to ensure this
        // important command is always run last.
        defer { session.commitConfiguration() }

        // Check to see if we can add the video input to the session, then add it.
        guard
            let videoInput = try? AVCaptureDeviceInput(device: inputDevice),
            session.canAddInput(videoInput)
        else {
            assertionFailure("Could not add video input.")
            return
        }
        session.addInput(videoInput)

        // Check to see if we can add the photo output to the session, then add it.
        guard session.canAddOutput(photoOutput) else {
            assertionFailure("Could not add photo output.")
            return
        }
        session.addOutput(photoOutput)

        // Configure the pixel buffer output.
        pixelOutput.alwaysDiscardsLateVideoFrames = true
        pixelOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        ]
        pixelOutput.setSampleBufferDelegate(self, queue: sampleQueue)

        // Add it to the session.
        guard session.canAddOutput(pixelOutput) else {
            assertionFailure("Could not add pixel buffer output.")
            return
        }
        session.addOutput(pixelOutput)
    }

// MARK: - CameraServiceProtocol

    // Protocol implementation.
    public func startVideoCapture() {
        session.startRunning()
    }

    // Protocol implementation.
    public func stopVideoCapture() {
        session.stopRunning()
    }

    // Protocol implementation.
    public func takePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraService: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        // Attempt to create a UIImage from the AVCapturePhoto
        guard
            let fileData = photo.fileDataRepresentation(),
            let image = UIImage(data: fileData)
        else {
            assertionFailure("Could not create UIImage from capture data.")
            return
        }

        // Publish it.
        imagePublisher.send(image)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        pixelBufferPublisher.send(pixelBuffer)
    }
}

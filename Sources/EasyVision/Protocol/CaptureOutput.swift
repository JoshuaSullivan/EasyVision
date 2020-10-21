import AVFoundation

/// An empty protocol to type-erase the outputs to a capture session.
public protocol CaptureOutput {}

// Add conformance to AVCaptureOutput
extension AVCaptureOutput: CaptureOutput {}

public protocol CapturePhotoOutput: CaptureOutput {
    func capturePhoto(with settings: AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate)
}

extension AVCapturePhotoOutput: CapturePhotoOutput {}

public protocol CaptureDataOutput: CaptureOutput {
    var alwaysDiscardsLateVideoFrames: Bool { get set }
    var videoSettings: [String : Any]! { get set }
    func setSampleBufferDelegate(
        _ sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?,
        queue sampleBufferCallbackQueue: DispatchQueue?
    )
}

extension AVCaptureVideoDataOutput: CaptureDataOutput {}

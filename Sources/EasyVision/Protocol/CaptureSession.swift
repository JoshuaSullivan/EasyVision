import Foundation
import AVFoundation

/// A wrapper for AVCaptureSession so that it can be mocked.
///
public protocol CaptureSession {
    func beginConfiguration()
    func commitConfiguration()
    func canAddInput(_ input: AVCaptureInput) -> Bool
    func addInput(_ input: AVCaptureInput)
    func canAddOutput(_ output: AVCaptureOutput) -> Bool
    func addOutput(_ output: AVCaptureOutput)
    func startRunning()
    func stopRunning()

    /// We need a means for recovering the underlying AVSession (or a new one in the case of a mock) for
    /// the configuration of the video preview layer.
    var avSession: AVCaptureSession { get }
}

/// Add CaptureSession conformance to AVCaptureSession
extension AVCaptureSession: CaptureSession {
    public var avSession: AVCaptureSession {
        return self
    }
}

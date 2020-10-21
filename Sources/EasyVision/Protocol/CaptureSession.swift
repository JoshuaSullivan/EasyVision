import Foundation
import AVFoundation

/// A wrapper for AVCaptureSession so that it can be mocked.
///
public protocol CaptureSession {
    func beginConfiguration()
    func commitConfiguration()
    func add(input: CaptureInput) throws
    func add(output: CaptureOutput) throws
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

    public func add(input: CaptureInput) throws {
        guard
            let avInput = input as? AVCaptureInput,
            self.canAddInput(avInput)
        else {
            throw CaptureError.unableToAddInput
        }
        self.addInput(avInput)
    }

    public func add(output: CaptureOutput) throws {
        guard
            let avOutput = output as? AVCaptureOutput,
            self.canAddOutput(avOutput)
        else {
            throw CaptureError.unableToAddOutput
        }
        self.addOutput(avOutput)
    }
}



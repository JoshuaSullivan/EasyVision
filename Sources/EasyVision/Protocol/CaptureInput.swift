import AVFoundation

/// An empty protocol to type-erase the inputs to a capture session.
public protocol CaptureInput {}

// Add conformance to AVCaptureInput.
extension AVCaptureInput: CaptureInput {}

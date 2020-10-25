import AVFoundation

/// An empty protocol to type-erase the inputs to a capture session.
public protocol CaptureInput: class {}

// Add conformance to AVCaptureInput.
extension AVCaptureInput: CaptureInput {}

/// An empty protocol to type-erase the inputs to a capture session.
public protocol CaptureDeviceInput: class {}

extension AVCaptureDeviceInput: CaptureDeviceInput {}

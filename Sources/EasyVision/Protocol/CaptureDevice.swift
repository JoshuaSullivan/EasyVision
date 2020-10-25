import AVFoundation

/// Obscures the device type such that mocks can be used.
public protocol CaptureDevice: class {}

/// Conform to CaptureDevice
extension AVCaptureDevice: CaptureDevice {}

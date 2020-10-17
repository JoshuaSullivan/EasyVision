import AVFoundation

/// A wrapper for AVCaptureDevice.DiscoverySession so that it can be mocked.
public protocol DiscoverySession {
    var devices: [AVCaptureDevice] { get }
}

/// Add DiscoverySession conformance to AVCaptureDevice.DiscoverySession
extension AVCaptureDevice.DiscoverySession: DiscoverySession {}


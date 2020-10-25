import AVFoundation

/// A wrapper for AVCaptureDevice.DiscoverySession so that it can be mocked.
public protocol DiscoverySession {
    var discoveredDevices: [CaptureDevice] { get }
}

/// Add DiscoverySession conformance to AVCaptureDevice.DiscoverySession
extension AVCaptureDevice.DiscoverySession: DiscoverySession {
    public var discoveredDevices: [CaptureDevice] { devices }
}


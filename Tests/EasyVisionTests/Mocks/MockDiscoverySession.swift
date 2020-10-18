import AVFoundation
import EasyVision

class MockDiscoverySession: DiscoverySession {
    /// A log of calls to this object.
    var actions: [String] = []

    /// Allow us to control the results of the discovery session.
    var mockDevices: [AVCaptureDevice] = []

    var devices: [AVCaptureDevice] {
        actions.append("devices")
        return mockDevices
    }
}

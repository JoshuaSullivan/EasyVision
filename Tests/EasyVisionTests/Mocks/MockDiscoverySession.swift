import AVFoundation
import EasyVision

class MockDiscoverySession: DiscoverySession {
    /// A log of calls to this object.
    var actions: [String] = []

    /// Allow us to control the results of the discovery session.
    var mockDevices: [CaptureDevice] = []

    var discoveredDevices: [CaptureDevice] {
        actions.append("devices")
        return mockDevices
    }
}

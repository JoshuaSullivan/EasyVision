import AVFoundation
import EasyVision

final class MockDiscoverySession: DiscoverySession {

    enum Action {
        case discoveredDevices
    }

    /// A log of calls to this object.
    var actions: [Action] = []

    /// Allow us to control the results of the discovery session.
    var mockDevices: [CaptureDevice] = []

    var discoveredDevices: [CaptureDevice] {
        actions.append(.discoveredDevices)
        return mockDevices
    }
}

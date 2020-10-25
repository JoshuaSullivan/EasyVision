import UIKit
import EasyVision

final class MockDevice: Device {

    enum Action {
        case beginGeneratingDeviceOrientationNotifications
        case endGeneratingDeviceOrientationNotifications
        case orientation
    }

    /// A log of calls to this object.
    var actions: [Action] = []

    /// Allows us to control which orientation is returned.
    var mockOrientation: UIDeviceOrientation = .portrait

    func beginGeneratingDeviceOrientationNotifications() {
        actions.append(.beginGeneratingDeviceOrientationNotifications)
    }

    func endGeneratingDeviceOrientationNotifications() {
        actions.append(.endGeneratingDeviceOrientationNotifications)
    }

    var orientation: UIDeviceOrientation {
        actions.append(.orientation)
        return mockOrientation
    }
}

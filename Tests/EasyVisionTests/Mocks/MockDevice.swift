import UIKit
import EasyVision

class MockDevice: Device {

    /// A log of calls to this object.
    var actions: [String] = []

    /// Allows us to control which orientation is returned.
    var mockOrientation: UIDeviceOrientation = .portrait

    func beginGeneratingDeviceOrientationNotifications() {
        actions.append("beginGeneratingDeviceOrientationNotifications")
    }

    func endGeneratingDeviceOrientationNotifications() {
        actions.append("endGeneratingDeviceOrientationNotifications")
    }

    var orientation: UIDeviceOrientation {
        actions.append("orientation")
        return mockOrientation
    }
}

import UIKit

/// A wrapper for UIDevice so that it can be mocked.
///
public protocol Device {
    var orientation: UIDeviceOrientation { get }

    func beginGeneratingDeviceOrientationNotifications()
    func endGeneratingDeviceOrientationNotifications()
}

extension UIDevice: Device {}

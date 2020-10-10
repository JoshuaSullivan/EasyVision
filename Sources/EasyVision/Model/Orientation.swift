import AVFoundation
import CoreGraphics
import CoreImage
import UIKit

/// A general-purpose interchange object for the various orientation systems different Apple frameworks use.
///
public enum Orientation: String, Equatable {
    /// Device is upright with the home button/indicator on the bottom.
    case portrait

    /// Device is rotated to the right in landscape with the home button/indicator on the left side.
    case landscapeRight

    /// Device is rotated to the left in landscape with the home button/indicator on the right side.
    case landscapeLeft

    /// Device is rotated upsidedown with the home button/indicator on the top.
    case upsideDown

// MARK: - UIImage.Orientation

    /// Convert the `Orientation` into a case of `UIImage.Orientation`.
    ///
    public var uiOrientation: UIImage.Orientation {
        switch self {
        case .portrait: return .up
        case .landscapeRight: return .left
        case .landscapeLeft: return .right
        case .upsideDown: return .up
        }
    }

    /// Initialize the `Orientation` with a `UIImage.Orientation` case.
    ///
    public init(uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .portrait
        case .left: self = .landscapeRight
        case .right: self = .landscapeLeft
        case .down, .upMirrored: self = .upsideDown
        default: self = .portrait
        }
    }

// MARK: - CGImagePropertyOrientation

    /// Get the `CGImagePropertyOrientation` of the `Orientation`.
    ///
    public var cgOrientation: CGImagePropertyOrientation {
        switch self {
        case .portrait: return .up
        case .landscapeRight: return .left
        case .landscapeLeft: return .right
        case .upsideDown: return .upMirrored
        }
    }

    /// Init the `Orientation` with a `CGImagePropertyOrientation` case.
    ///
    public init(cgOrientation: CGImagePropertyOrientation) {
        switch cgOrientation {
        case .up: self = .portrait
        case .left: self = .landscapeRight
        case .right: self = .landscapeLeft
        case .upMirrored: self = .upsideDown
        default: self = .portrait
        }
    }

// MARK: - UIDeviceOrientation

    /// Convert the `Orientation` into a case of `UIDeviceOrientation`.
    ///
    /// `UIDeviceOrientation` has a strange nomenclature that seems to flip `right` and `left` orientations
    /// the opposite way from all of the other orientation types.
    ///
    public var deviceOrientation: UIDeviceOrientation {
        switch self {
        case .portrait: return .portrait
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .upsideDown: return .portraitUpsideDown
        }
    }

    /// Initialize an `Orientation` from a `UIDeviceOrientation` case.
    ///
    public init(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .landscapeRight: self = .landscapeRight
        case .landscapeLeft: self = .landscapeLeft
        case .portraitUpsideDown: self = .upsideDown
        default: self = .portrait
        }
    }

// MARK: - AVCaptureVideoOrientation

    /// Convert the `Orientation` into a case of `AVCaptureVideoOrientation`.
    ///
    public var avOrientation: AVCaptureVideoOrientation {
        switch self {
        case .portrait: return .portrait
        case .landscapeRight: return .landscapeLeft
        case .landscapeLeft: return .landscapeRight
        case .upsideDown: return .portraitUpsideDown
        }
    }

    /// Initialize an `Orientation` from an `AVCaptureVideoOrientation` case.
    ///
    public init(avOrientation: AVCaptureVideoOrientation) {
        switch avOrientation {
        case .portrait: self = .portrait
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        case .portraitUpsideDown: self = .upsideDown
        default: self = .portrait
        }
    }
}

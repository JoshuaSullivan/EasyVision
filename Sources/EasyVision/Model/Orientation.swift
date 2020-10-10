import AVFoundation
import CoreGraphics
import CoreImage
import UIKit

/// A general-purpose interchange object for the various orientation systems different Apple frameworks use.
///
public enum Orientation: String, Equatable {
    /// Device is upright with the home button/indicator on the bottom.
    case portrait

    /// Device is in landscape with the home button/indicator on the left side.
    case landscapeLeft

    /// Device is in landscape with the home button/indicator on the right side.
    case landscapeRight

    /// Device is upsidedown with the home button/indicator on the top.
    case upsideDown

// MARK: - UIImage.Orientation

    public var uiOrientation: UIImage.Orientation {
        switch self {
        case .portrait: return .up
        case .landscapeLeft: return .left
        case .landscapeRight: return .right
        case .upsideDown: return .up
        }
    }

    public init(uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .portrait
        case .left: self = .landscapeLeft
        case .right: self = .landscapeRight
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
        case .landscapeLeft: return .left
        case .landscapeRight: return .right
        case .upsideDown: return .upMirrored
        }
    }

    /// Init the `Orientation` with a `CGImagePropertyOrientation` case.
    ///
    public init(cgOrientation: CGImagePropertyOrientation) {
        switch cgOrientation {
        case .up: self = .portrait
        case .left: self = .landscapeLeft
        case .right: self = .landscapeRight
        case .upMirrored: self = .upsideDown
        default: self = .portrait
        }
    }

// MARK: - UIDeviceOrientation

    public var deviceOrientation: UIDeviceOrientation {
        switch self {
        case .portrait: return .portrait
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        case .upsideDown: return .portraitUpsideDown
        }
    }

    public init(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .landscapeRight: self = .landscapeLeft
        case .landscapeLeft: self = .landscapeRight
        case .portraitUpsideDown: self = .upsideDown
        default: self = .portrait
        }
    }

// MARK: - AVCaptureVideoOrientation

    public var avOrientation: AVCaptureVideoOrientation {
        switch self {
        case .portrait: return .portrait
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        case .upsideDown: return .portraitUpsideDown
        }
    }

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

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
    case portraitUpsideDown

// MARK: - CGImagePropertyOrientation

    /// Get the `CGImagePropertyOrientation` of the `Orientation`.
    ///
    public var cgOrientation: CGImagePropertyOrientation {
        switch self {
        case .portrait: return .up
        case .landscapeLeft: return .left
        case .landscapeRight: return .right
        case .portraitUpsideDown: return .upMirrored
        }
    }

    /// Init the `Orientation` with a `CGImagePropertyOrientation` case.
    ///
    public init(cgOrientation: CGImagePropertyOrientation) {
        switch cgOrientation {
        case .up: self = .portrait
        case .left: self = .landscapeLeft
        case .right: self = .landscapeRight
        case .upMirrored: self = .portraitUpsideDown
        default: self = .portrait
        }
    }

// MARK: - UIDeviceOrientation

    public var deviceOrientation: UIDeviceOrientation {
        switch self {
        case .portrait: return .portrait
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        case .portraitUpsideDown: return .portraitUpsideDown
        }
    }

    public init(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .landscapeRight: self = .landscapeRight
        case .landscapeLeft: self = .landscapeLeft
        case .portraitUpsideDown: self = .portraitUpsideDown
        default: self = .portrait
        }
    }

// MARK: - AVCaptureVideoOrientation

    public var avOrientation: AVCaptureVideoOrientation {
        switch self {
        case .portrait: return .portrait
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        case .portraitUpsideDown: return .portraitUpsideDown
        }
    }

    public init(avOrientation: AVCaptureVideoOrientation) {
        switch avOrientation {
        case .portrait: self = .portrait
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        case .portraitUpsideDown: self = .portraitUpsideDown
        default: self = .portrait
        }
    }
}

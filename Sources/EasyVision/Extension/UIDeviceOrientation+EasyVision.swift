import AVFoundation
import UIKit

public extension UIDeviceOrientation {

    /// Convert the device orientation into a video orientation.
    var videoOrientation: AVCaptureVideoOrientation {
        switch self {
        case .faceDown, .faceUp, .portrait: return .portrait
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        case .portraitUpsideDown: return .portraitUpsideDown
        default: return .portrait
        }
    }

    /// Convert the device orientation into the proper orientation for sending pixel buffers to Vision.
    ///
    /// From: [Recognizing Objects in Live Capture](https://developer.apple.com/documentation/vision/recognizing_objects_in_live_capture)
    ///
    var visionOrientation: CGImagePropertyOrientation {
        switch self {
        case .portraitUpsideDown: return .left
        case .landscapeLeft: return .upMirrored
        case .landscapeRight: return .down
        case .portrait: return .up
        default: return .up
        }
    }
}

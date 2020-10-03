import UIKit
import AVFoundation
import SwiftUI

/// This simple view class makes it easy to add an `AVCaptureVideoPreviewLayer`
/// via storyboards or SwiftUI.
///
public class VideoPreviewView: UIView {

    public override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    /// Convenience wrapper to get layer as it's a statically known type.
    public var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

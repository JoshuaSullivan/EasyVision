import SwiftUI
import AVFoundation

/// This wraps the VideoPreviewView, which provides an AVFoundation video preview layer.
///
/// - Note: This view cannot be previewed because the `AVCaptureVideoPreviewLayer` is incompatible with
///         the preview system.
///
public struct VideoPreview: UIViewRepresentable {

    /// The instance of VideoPreviewView that this view wraps.
    let preview: VideoPreviewView

    public func makeUIView(context: Context) -> VideoPreviewView {
        return preview
    }

    public func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        // Nothing at the moment.
    }
}

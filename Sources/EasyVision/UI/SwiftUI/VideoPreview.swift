import SwiftUI
import AVFoundation

/// This wraps the VideoPreviewView, which provides an AVFoundation video preview layer.
///
public struct VideoPreview: UIViewRepresentable {

    let session: AVCaptureSession

    public func makeUIView(context: Context) -> VideoPreviewView {
        let preview = VideoPreviewView(frame: .zero)
        preview.videoPreviewLayer.session = session
        return preview
    }

    public func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        // Nothing, yet.
    }
}

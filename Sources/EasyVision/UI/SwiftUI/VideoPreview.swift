import SwiftUI
import AVFoundation

/// This wraps the VideoPreviewView, which provides an AVFoundation video preview layer.
///
public struct VideoPreview: UIViewRepresentable {

    let session: AVCaptureSession

    let preview: VideoPreviewView = VideoPreviewView(frame: .zero)

    public func makeUIView(context: Context) -> VideoPreviewView {
        preview.videoPreviewLayer.session = session
        return preview
    }

    public func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        // Nothing, yet.
    }
}

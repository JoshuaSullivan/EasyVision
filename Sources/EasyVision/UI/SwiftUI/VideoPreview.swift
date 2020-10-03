import SwiftUI
import AVFoundation

/// This wraps the VideoPreviewView, which provides an AVFoundation video preview layer.
///
struct VideoPreview: UIViewRepresentable {

    @EnvironmentObject var captureSession: CaptureSession

    func makeUIView(context: Context) -> VideoPreviewView {
        let preview = VideoPreviewView(frame: .zero)
        preview.videoPreviewLayer.session = captureSession.session
        return preview
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        // Nothing, yet.
    }
}

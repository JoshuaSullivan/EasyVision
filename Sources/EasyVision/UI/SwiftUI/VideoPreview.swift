import SwiftUI
import AVFoundation

/// This wraps the VideoPreviewView, which provides an AVFoundation video preview layer.
///
public struct VideoPreview: UIViewRepresentable {

    let session: AVCaptureSession

    let preview: VideoPreviewView = {
        let preview = VideoPreviewView(frame: .zero)
        preview.translatesAutoresizingMaskIntoConstraints = false
        return preview
    }

    public func makeUIView(context: Context) -> VideoPreviewView {
        preview.videoPreviewLayer.session = session
        print("connection: \(preview.videoPreviewLayer.connection)")
        preview.videoPreviewLayer.videoGravity = .resizeAspectFill
        return preview
    }

    public func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        // Nothing, yet.
        print("VideoPreview.updateUIView")
    }
}

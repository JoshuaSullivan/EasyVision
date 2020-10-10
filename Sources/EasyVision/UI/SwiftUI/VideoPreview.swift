import SwiftUI
import AVFoundation

/// This wraps the VideoPreviewView, which provides an AVFoundation video preview layer.
///
public struct VideoPreview: UIViewRepresentable {

    let preview: VideoPreviewView

    public func makeUIView(context: Context) -> VideoPreviewView {
        return preview
    }

    public func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        // Nothing, yet.
        print("VideoPreview.updateUIView")
    }
}

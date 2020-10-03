import AVFoundation
import Combine

class CaptureSession: ObservableObject {
    @Published var session: AVCaptureSession = AVCaptureSession()

    init(session: AVCaptureSession) {
        self.session = session
    }
}

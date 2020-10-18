import AVFoundation
import EasyVision

class MockCaptureSession: CaptureSession {

    /// A log of method calls to this class.
    var actions: [String] = []

    /// Allows us to control the success or failure of canAddInput and canAddOutput.
    var canAddResult = true

    func beginConfiguration() {
        actions.append("beginConfiguration")
    }

    func commitConfiguration() {
        actions.append("commitConfiguration")
    }

    func canAddInput(_ input: AVCaptureInput) -> Bool {
        actions.append("canAddInput")
        return canAddResult
    }

    func addInput(_ input: AVCaptureInput) {
        actions.append("addInput")
    }

    func canAddOutput(_ output: AVCaptureOutput) -> Bool {
        actions.append("canAddOutput")
        return canAddResult
    }

    func addOutput(_ output: AVCaptureOutput) {
        actions.append("addOutput")
    }

    func startRunning() {
        actions.append("startRunning")
    }

    func stopRunning() {
        actions.append("stopRunning")
    }

    var avSession: AVCaptureSession {
        actions.append("avSession")
        return AVCaptureSession()
    }
}

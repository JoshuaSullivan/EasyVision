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

    func add(input: CaptureInput) throws {
        actions.append("add(input:)")
    }

    func add(output: CaptureOutput) throws {
        actions.append("add(output:)")
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

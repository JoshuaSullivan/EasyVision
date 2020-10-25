import AVFoundation
import EasyVision

final class MockCaptureSession: CaptureSession {

    enum Action {
        case beginConfiguration
        case commitConfiguration
        case addInput
        case addOuput
        case startRunning
        case stopRunning
        case avSession
    }

    /// A log of method calls to this class.
    var actions: [Action] = []

    /// Allows us to control the success or failure of canAddInput and canAddOutput.
    var canAddResult = true

    func beginConfiguration() {
        actions.append(.beginConfiguration)
    }

    func commitConfiguration() {
        actions.append(.commitConfiguration)
    }

    func add(input: CaptureInput) throws {
        actions.append(.addInput)
    }

    func add(output: CaptureOutput) throws {
        actions.append(.addOuput)
    }

    func startRunning() {
        actions.append(.startRunning)
    }

    func stopRunning() {
        actions.append(.stopRunning)
    }

    var avSession: AVCaptureSession {
        actions.append(.avSession)
        return AVCaptureSession()
    }
}

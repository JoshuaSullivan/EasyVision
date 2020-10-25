import AVFoundation
import EasyVision

final class MockCaptureInputHelper: CaptureInputHelperProtocol {

    enum Action {
        case inputForDevice
    }
    public var actions: [Action] = []

    func input(for device: CaptureDevice) throws -> CaptureInput {
        actions.append(.inputForDevice)
        return MockCaptureInput()
    }
}

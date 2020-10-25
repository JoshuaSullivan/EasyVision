import AVFoundation
import EasyVision

struct MockCaptureInputHelper: CaptureInputHelperProtocol {
    func input(for device: CaptureDevice) throws -> CaptureInput {
        MockCaptureInput()
    }
}

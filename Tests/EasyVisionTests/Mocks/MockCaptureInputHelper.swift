import AVFoundation
import EasyVision

struct MockCaptureInputHelper: CaptureInputHelperProtocol {
    func input(for device: AVCaptureDevice) throws -> CaptureInput {
        MockCaptureInput()
    }
}

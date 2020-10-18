import AVFoundation
import EasyVision

struct MockCaptureInputHelper: CaptureInputHelperProtocol {
    func input(for device: AVCaptureDevice) throws -> AVCaptureDeviceInput {
        let input = MockAVCaptureDeviceInput(mockDevice: device)
        return input
    }
}

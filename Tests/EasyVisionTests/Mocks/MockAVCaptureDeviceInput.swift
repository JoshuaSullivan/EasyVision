import AVFoundation

final class MockAVCaptureDeviceInput: AVCaptureDeviceInput {

    @objc dynamic private convenience init(mock: String) { fatalError() }

    convenience init(mockDevice: AVCaptureDevice) {
        do {
            try self.init(device: mockDevice)
        } catch {
            print(error)
            fatalError()
        }
    }

    private class func mock() -> MockAVCaptureDeviceInput {
        let input = MockAVCaptureDeviceInput(mock: "mock")
        return input
    }

    static func createMock() -> MockAVCaptureDeviceInput {
        Swizzler(self).injectNSObjectInit(into: #selector(MockAVCaptureDeviceInput.init(mock:)))
        return mock()
    }
}

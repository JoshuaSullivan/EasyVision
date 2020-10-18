import XCTest
import AVFoundation
@testable import EasyVision

class CameraServiceTests: XCTestCase {

    var captureSession: MockCaptureSession!
    var device: MockDevice!
    var discoverySession: MockDiscoverySession!
    var inputHelper: MockCaptureInputHelper!
    var subject: CameraService!

    override func setUpWithError() throws {
        captureSession = MockCaptureSession()
        device = MockDevice()
        discoverySession = MockDiscoverySession()
        inputHelper = MockCaptureInputHelper()
    }

    private func createSubject() {
        subject = CameraService(
            discoverySession: discoverySession,
            captureSession: captureSession,
            device: device,
            inputHelper: inputHelper
        )
    }

    func testStartVideoCapture() {
        discoverySession.mockDevices = [MockAVCaptureDevice.createMock()!]
        createSubject()
        subject.startVideoCapture()
        XCTAssert(true)
    }
}

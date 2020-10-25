import XCTest
import AVFoundation
@testable import EasyVision

class CameraServiceTests: XCTestCase {

    var captureSession: MockCaptureSession!
    var device: MockDevice!
    var discoverySession: MockDiscoverySession!
    var inputHelper: MockCaptureInputHelper!
    var outputHelper: MockCaptureOutputHelper!
    var subject: CameraService!

    override func setUpWithError() throws {
        captureSession = MockCaptureSession()
        device = MockDevice()
        discoverySession = MockDiscoverySession()
        inputHelper = MockCaptureInputHelper()
        outputHelper = MockCaptureOutputHelper()
    }

    private func createSubject() {
        subject = CameraService(
            discoverySession: discoverySession,
            captureSession: captureSession,
            device: device,
            inputHelper: inputHelper,
            outputHelper: outputHelper
        )
    }

    /// Test that the CameraService configures itself properly on init.
    func testInit() {
        let captureDevice = MockCaptureDevice()
        discoverySession.mockDevices = [captureDevice]
        createSubject()

        // Test that the discovery session was called to get devices.
        XCTAssertEqual(discoverySession.actions.first, .discoveredDevices)

        // Test that the inputs and outputs were created via the helpers.
        XCTAssertEqual(inputHelper.actions.first, .inputForDevice)
        XCTAssertEqual(outputHelper.actions, [.pixelBufferOutput, .photoOutput])

        // Test that the capture session started and ended configuration and that the inputs and outputs were added.
        XCTAssertEqual(captureSession.actions, [.beginConfiguration, .addInput, .addOuput, .addOuput, .commitConfiguration])

        // Test that the pixel buffer output was configured.
        XCTAssertEqual(outputHelper.buffer.actions, [.setAlwaysDiscardsLateVideoFrames, .setVideoSettings, .setSampleBufferDelegate])
    }

    /// Test that the CameraService correctly starts and stops video capture.
    func testStartStopVideoCapture() {
        let captureDevice = MockCaptureDevice()
        discoverySession.mockDevices = [captureDevice]
        createSubject()

        subject.startVideoCapture()

        // Test that the camera service calls the device to start orientation notifications.
        XCTAssertEqual(device.actions.last, .beginGeneratingDeviceOrientationNotifications)
        // Test that the camera service calls the capture session to start running.
        XCTAssertEqual(captureSession.actions.last, .startRunning)

        subject.stopVideoCapture()

        // Test that the camera service calls the device to stop orientation notifications.
        XCTAssertEqual(device.actions.last, .endGeneratingDeviceOrientationNotifications)
        // Test that the camera service calls the capture session to stop running.
        XCTAssertEqual(captureSession.actions.last, .stopRunning)
    }

    // TODO: Implement pixel buffer publish tests.
}

import XCTest
import AVFoundation
@testable import EasyVision

class UIDeviceOrientationTests: XCTestCase {
    func testVideoOrientation() {
        XCTAssertEqual(UIDeviceOrientation.portrait.videoOrientation, AVCaptureVideoOrientation.portrait)
        XCTAssertEqual(UIDeviceOrientation.landscapeRight.videoOrientation, AVCaptureVideoOrientation.landscapeLeft)
        XCTAssertEqual(UIDeviceOrientation.landscapeLeft.videoOrientation, AVCaptureVideoOrientation.landscapeRight)
        XCTAssertEqual(UIDeviceOrientation.portraitUpsideDown.videoOrientation, AVCaptureVideoOrientation.portraitUpsideDown)
        XCTAssertEqual(UIDeviceOrientation.faceDown.videoOrientation, AVCaptureVideoOrientation.portrait)
        XCTAssertEqual(UIDeviceOrientation.faceUp.videoOrientation, AVCaptureVideoOrientation.portrait)
        XCTAssertEqual(UIDeviceOrientation.unknown.videoOrientation, AVCaptureVideoOrientation.portrait)
    }

    func testVisionOrientation() {
        XCTAssertEqual(UIDeviceOrientation.portrait.visionOrientation, CGImagePropertyOrientation.up)
        XCTAssertEqual(UIDeviceOrientation.landscapeRight.visionOrientation, CGImagePropertyOrientation.down)
        XCTAssertEqual(UIDeviceOrientation.landscapeLeft.visionOrientation, CGImagePropertyOrientation.upMirrored)
        XCTAssertEqual(UIDeviceOrientation.portraitUpsideDown.visionOrientation, CGImagePropertyOrientation.left)
        XCTAssertEqual(UIDeviceOrientation.faceDown.visionOrientation, CGImagePropertyOrientation.up)
        XCTAssertEqual(UIDeviceOrientation.faceUp.visionOrientation, CGImagePropertyOrientation.up)
        XCTAssertEqual(UIDeviceOrientation.unknown.visionOrientation, CGImagePropertyOrientation.up)
    }
}

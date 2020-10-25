import AVFoundation
import EasyVision

class MockCaptureOutput: CaptureOutput {}

final class MockCapturePhotoOutput: CapturePhotoOutput {

    enum Action {
        case capturePhoto
    }

    var actions: [Action] = []

    func capturePhoto(with settings: AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate) {
        actions.append(.capturePhoto)
    }
}

final class MockCapturePixelDataOutput: CaptureDataOutput {

    enum Action {
        case setAlwaysDiscardsLateVideoFrames
        case getAlwaysDiscardsLateVideoFrames
        case setVideoSettings
        case getVideoSettings
        case setSampleBufferDelegate
    }

    var actions: [Action] = []

    var alwaysDiscardsLateVideoFrames: Bool {
        get {
            actions.append(.getAlwaysDiscardsLateVideoFrames)
            return true
        }
        set {
            actions.append(.setAlwaysDiscardsLateVideoFrames)
        }
    }

    var videoSettings: [String : Any]! {
        get {
            actions.append(.getVideoSettings)
            return [:]
        }
        set {
            actions.append(.setVideoSettings)
        }
    }

    func setSampleBufferDelegate(_ sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?, queue: DispatchQueue?) {
        actions.append(.setSampleBufferDelegate)
    }
}

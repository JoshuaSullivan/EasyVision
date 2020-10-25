import EasyVision

final class MockCaptureOutputHelper: CaptureOutputHelperProtocol {

    enum Action {
        case photoOutput
        case pixelBufferOutput
    }

    var photo = MockCapturePhotoOutput()

    var buffer = MockCapturePixelDataOutput()

    var actions: [Action] = []

    var photoOutput: CapturePhotoOutput {
        actions.append(.photoOutput)
        return photo
    }

    var pixelBufferOutput: CaptureDataOutput {
        actions.append(.pixelBufferOutput)
        return buffer
    }
}

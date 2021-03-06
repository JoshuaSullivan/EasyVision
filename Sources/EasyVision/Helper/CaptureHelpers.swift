import AVFoundation

enum CaptureHelperError: Error {
    case inputNotAVCaptureDevice
}

/// This protcol allows us to mock device input creation for testing purposes.
///
public protocol CaptureInputHelperProtocol {

    /// Attempt to create an `AVCaptureDeviceInput` for the provided `AVCaptureDevice`.
    ///
    /// We are not using a static method because that makes substitution for mocking purposes difficult.
    ///
    /// - Parameter device: The `AVCaptureDevice` to create the input with.
    ///
    func input(for device: CaptureDevice) throws -> CaptureInput
}

public struct CaptureInputHelper: CaptureInputHelperProtocol {

    /// A public initializer that does nothing.
    public init() {}

    public func input(for device: CaptureDevice) throws -> CaptureInput {
        guard let avDevice = device as? AVCaptureDevice else {
            throw CaptureHelperError.inputNotAVCaptureDevice
        }
        return try AVCaptureDeviceInput(device: avDevice)
    }
}

public protocol CaptureOutputHelperProtocol {
    var photoOutput: CapturePhotoOutput { get }
    var pixelBufferOutput: CaptureDataOutput { get }
}

public struct CaptureOutputHelper: CaptureOutputHelperProtocol {
    public init() {}

    public var photoOutput: CapturePhotoOutput {
        let photo = AVCapturePhotoOutput()
        return photo
    }

    public var pixelBufferOutput: CaptureDataOutput {
        let data = AVCaptureVideoDataOutput()
        return data
    }
}

import AVFoundation

/// This protcol allows us to mock device input creation for testing purposes.
///
public protocol CaptureInputHelperProtocol {

    /// Attempt to create an `AVCaptureDeviceInput` for the provided `AVCaptureDevice`.
    ///
    /// We are not using a static method because that makes substitution for mocking purposes difficult.
    ///
    /// - Parameter device: The `AVCaptureDevice` to create the input with.
    ///
    func input(for device: AVCaptureDevice) throws -> AVCaptureDeviceInput
}

//
public struct CaptureInputHelper: CaptureInputHelperProtocol {

    /// A public initializer that does nothing.
    public init() {}

    public func input(for device: AVCaptureDevice) throws -> AVCaptureDeviceInput {
        try AVCaptureDeviceInput(device: device)
    }
}

import AVFoundation

final class MockAVCaptureDevice: AVCaptureDevice {

    var actions: [String] = []

    override var uniqueID: String { "com.apple.avfoundation.avcapturedevice.built-in_video:0" }

    override var modelID: String { "com.apple.avfoundation.avcapturedevice.built-in_video:0" }

    override var manufacturer: String { "Apple Inc." }

    override var localizedName: String { "Back Camera" }

    override var isConnected: Bool { true }

    override var isVirtualDevice: Bool { false }

    override var deviceType: AVCaptureDevice.DeviceType { .builtInWideAngleCamera }

    override var constituentDevices: [AVCaptureDevice] { [] }

    override var lensAperture: Float { 1.8 }

    override func hasMediaType(_ mediaType: AVMediaType) -> Bool { true }

    override func supportsSessionPreset(_ preset: AVCaptureSession.Preset) -> Bool { true }

    override var formats: [AVCaptureDevice.Format] { [] }

    override var exposureDuration: CMTime { CMTime(value: 1, timescale: 30) }

    override var exposureTargetOffset: Float { 0.0 }

    override var exposureTargetBias: Float { 0.0 }

    override var minExposureTargetBias: Float { -8.0 }

    override var maxExposureTargetBias: Float { 8.0 }

    override var activeMaxExposureDuration: CMTime {
        get { CMTime(value: 1, timescale: 30) }
        set {}
    }

    override var activeDepthDataFormat: AVCaptureDevice.Format? {
        get { nil }
        set {}
    }

    override var activeDepthDataMinFrameDuration: CMTime {
        get { CMTime(value: 0, timescale: 0) }
        set {}
    }

    override var minAvailableVideoZoomFactor: CGFloat { 1.0 }

    override var maxAvailableVideoZoomFactor: CGFloat { 16.0 }

    

    @objc dynamic private convenience init(mock: String) { fatalError() }

    override var position: AVCaptureDevice.Position {
        actions.append("get(position)")
        return .back
    }

    override var focusMode: AVCaptureDevice.FocusMode {
        get {
            actions.append("get(focusMode)")
            return.autoFocus
        }
        set {
            actions.append("set(focusMode)")
        }
    }

    override var exposureMode: AVCaptureDevice.ExposureMode {
        get {
            actions.append("get(exposureMode)")
            return .autoExpose
        }
        set {
            actions.append("set(exposureMode)")
        }
    }

    override var whiteBalanceMode: AVCaptureDevice.WhiteBalanceMode {
        get {
            actions.append("get(whiteBalanceMode)")
            return .autoWhiteBalance
        }
        set {
            actions.append("set(whiteBalanceMode)")
        }
    }

    override func lockForConfiguration() throws {
        actions.append("lockForConfiguration")
    }

    override func unlockForConfiguration() {
        actions.append("unlockForConfiguration")
    }

    override func isFocusModeSupported(_ focusMode: AVCaptureDevice.FocusMode) -> Bool {
        actions.append("isFocusModeSupported")
        return true
    }

    override func isExposureModeSupported(_ exposureMode: AVCaptureDevice.ExposureMode) -> Bool {
        actions.append("isExposureModeSupported")
        return true
    }

    override func isWhiteBalanceModeSupported(_ whiteBalanceMode: AVCaptureDevice.WhiteBalanceMode) -> Bool {
        actions.append("isWhiteBalanceModeSupported")
        return true
    }



    private class func mock() -> MockAVCaptureDevice? {
        MockAVCaptureDevice(mock: "mock")
    }

    static func createMock() -> MockAVCaptureDevice? {
        Swizzler(self).injectNSObjectInit(into: #selector(MockAVCaptureDevice.init(mock:)))
        return mock()
    }
}

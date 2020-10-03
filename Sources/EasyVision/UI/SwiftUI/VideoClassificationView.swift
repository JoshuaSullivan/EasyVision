import SwiftUI
import AVFoundation
import Combine

public struct VideoClassificationView<ViewModel: VideoClassificationViewModelProtocol>: View {

    @ObservedObject public var viewModel: ViewModel

    public var body: some View {
        ZStack(alignment: .bottom) {
            VideoPreview()

        }
    }
}

public struct VideoClassificationView_Previews: PreviewProvider {
    private static let viewModel = VideoClassificationViewModel(
        cameraService: CameraService(),
        classificationService: ClassificationService(model: MockModel())
    )

    public static var previews: some View {
        VideoClassificationView(viewModel: viewModel)
    }
}

import SwiftUI
import AVFoundation
import Combine

public struct VideoClassificationView<ViewModel: VideoClassificationViewModelProtocol>: View {

    @ObservedObject public var viewModel: ViewModel

    public var body: some View {
        ZStack(alignment: .bottom) {
            VideoPreview()
            viewModel.currentClassification.map { classification in
                ClassificationLabel(classification: classification)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 8))
            }
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

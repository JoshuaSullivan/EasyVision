import SwiftUI
import AVFoundation
import Combine

public struct VideoClassificationView<ViewModel: SwiftUIViewModelProtocol>: View {

    @ObservedObject public var viewModel: ViewModel

    public var body: some View {
        ZStack(alignment: .bottom) {
            VideoPreview(session: viewModel.session)
            viewModel.currentClassification.map { classification in
                ClassificationLabel(classification: classification)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 40, trailing: 8))
            }
        }
        .onAppear { viewModel.startVideoCapture() }
        .onDisappear { viewModel.stopVideoCapture() }
    }

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

public struct VideoClassificationView_Previews: PreviewProvider {
    private static let viewModel = SwiftUIViewModel(
        cameraService: CameraService(),
        classificationService: ClassificationService(model: MockModel())
    )

    public static var previews: some View {
        VideoClassificationView(viewModel: viewModel)
    }
}

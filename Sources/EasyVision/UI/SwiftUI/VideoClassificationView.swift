import SwiftUI
import AVFoundation
import Combine

/// The `VideoClassificationView` provides a live video preview as well as a label
/// showing the classification output of the MLModel.
///
/// - Note: This View does not have a preview, as the underlying VideoPreview cannot be previewed.
///
public struct VideoClassificationView<ViewModel: SwiftUIViewModelProtocol>: View {

    /// The view model which handles obtaining classification results.
    @ObservedObject public var viewModel: ViewModel

    public var body: some View {
        ZStack(alignment: .bottom) {
            viewModel.videoPreview
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

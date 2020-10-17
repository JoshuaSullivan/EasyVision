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

// Interesting: The use of if-let in function builders is a Swift 5.3 feature,
//              not anything to do with iOS 14 or the updated SwiftUI. Therefore,
//              we can use it even on code targeting iOS 13. Neat!

            if let classification = viewModel.currentClassification {
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

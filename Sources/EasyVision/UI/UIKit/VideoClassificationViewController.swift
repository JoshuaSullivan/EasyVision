import UIKit
import AVFoundation
import Combine

/// Provides a complete interface for displaying a live video preview and the associated ML classification.
public class VideoClassificationViewController: UIViewController {

    /// The view model provides both the video preview layer as well as a publisher for
    /// classification results from the ML model.
    public var viewModel: UIKitViewModelProtocol? {
        didSet {
            // Hide the label if the model is set to nil.
            guard let vm = viewModel else {
                hideLabel()
                return
            }

            // Subscribe to the classification pubisher.
            classificationSubscription = vm.classificationPublisher.sink { [weak self] classification in
                self?.set(classification: classification)
            }

            // Get the video preview and add it to the view hierarchy.
            let preview = vm.previewView
            view.insertSubview(preview, at: 0)
            view.topAnchor.constraint(equalTo: preview.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: preview.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: preview.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: preview.trailingAnchor).isActive = true
        }
    }

    /// The `ClassificationLabelView` used to dispay classification results.
    @IBOutlet public weak var labelView: ClassificationLabelView?

    /// Storage for the classification subscription.
    private var classificationSubscription: AnyCancellable?

    public override func viewDidLoad() {
        super.viewDidLoad()

        // If no label view was created by Interface Builder, create one now.
        if labelView == nil {
            let labelView = ClassificationLabelView()
            view.addSubview(labelView)

            labelView.translatesAutoresizingMaskIntoConstraints = false
            labelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            labelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            labelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
            self.labelView = labelView
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Start video capture when the view arrives on-screen.
        viewModel?.startVideoCapture()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Pause video capture when the view leaves the screen.
        viewModel?.stopVideoCapture()
    }

    /// Display the details of a classification.
    ///
    /// - Parameter classification: The `Classification` to display. If a `nil` value is passed,
    ///                             then the label will be hidden.
    ///
    public func set(classification: Classification?) {
        // Hide the label if a nil is passed.
        guard let classification = classification else {
            hideLabel()
            return
        }

        // Show the label with the classification.
        showLabel(with: classification)
    }

    /// Ensure that the label is visible and send the `Classification` to it.
    private func showLabel(with classification: Classification) {
        labelView?.isHidden = false
        labelView?.update(with: classification)
    }

    /// Hide the classification label.
    private func hideLabel() {
        labelView?.isHidden = true
    }
}

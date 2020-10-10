import UIKit
import AVFoundation
import Combine

public class VideoClassificationViewController: UIViewController {

    public var viewModel: UIKitViewModelProtocol? {
        didSet {
            guard let vm = viewModel else {
                hideLabel()
                return
            }
            classificationSubscription = vm.classificationPublisher.sink { [weak self] classification in
                self?.set(classification: classification)
            }
            let preview = vm.previewView
            view.insertSubview(preview, at: 0)
            view.topAnchor.constraint(equalTo: preview.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: preview.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: preview.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: preview.trailingAnchor).isActive = true
        }
    }

    @IBOutlet public weak var labelView: ClassificationLabelView?

    private var classificationSubscription: AnyCancellable?

    public override func viewDidLoad() {
        super.viewDidLoad()

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

        viewModel?.startVideoCapture()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel?.stopVideoCapture()
    }

    public func set(classification: Classification?) {
        guard let classification = classification else {
            hideLabel()
            return
        }
        showLabel(with: classification)
    }

    private func showLabel(with classification: Classification) {
        labelView?.isHidden = false
        labelView?.update(with: classification)
    }

    private func hideLabel() {
        labelView?.isHidden = true
    }
}

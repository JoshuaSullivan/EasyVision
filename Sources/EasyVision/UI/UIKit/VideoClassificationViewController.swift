import UIKit
import AVFoundation
import Combine

public class VideoClassificationViewController<ViewModel: VideoClassificationViewModelProtocol>: UIViewController {

    public var viewModel: ViewModel? {
        didSet {
            guard let vm = viewModel else {
                hideLabel()
                return
            }
            classificationSubscription = vm.classificationPublisher.sink { [weak self] classification in
                self?.set(classification: classification)
            }
            previewLayer.session = vm.session
        }
    }

    private lazy var previewLayer = AVCaptureVideoPreviewLayer()

    @IBOutlet public weak var labelView: ClassificationLabelView?

    private var classificationSubscription: AnyCancellable?

    public override func viewDidLoad() {
        super.viewDidLoad()

        if labelView == nil {
            let labelView = ClassificationLabelView()
            view.addSubview(labelView)

            labelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            labelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16).isActive = true
            labelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
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

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
            previewLayer?.session = vm.session
        }
    }

    public var session: AVCaptureSession? {
        didSet {
            previewLayer?.removeFromSuperlayer()
            guard let session = session else { return }
            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer.videoGravity = .resizeAspectFill
            layer.frame = self.view.layer.bounds
            self.view.layer.addSublayer(layer)
            previewLayer = layer
        }
    }

    public lazy var labelView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [featureLabel, confidenceLabel])
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.spacing = 16.0
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true

        return view
    }()

    public lazy var featureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var confidenceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public var previewLayer: AVCaptureVideoPreviewLayer?

    private var classificationSubscription: AnyCancellable?

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(labelView)

        labelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        labelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16).isActive = true
        labelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
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
        featureLabel.text = classification.label
        confidenceLabel.text = String(format: "%0.1f%", arguments: [classification.confidence * 100.0])
        labelView.isHidden = false
    }

    private func hideLabel() {
        labelView.isHidden = true
    }
}

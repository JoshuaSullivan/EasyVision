import UIKit

public class ClassificationLabelView: UIView {

    @IBOutlet public weak var featureLabel: UILabel?
    @IBOutlet public weak var confidenceLabel: UILabel?

    private lazy var defaultFeatureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var defaultConfidenceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public init() {
        super.init(frame: .zero)

        setupViews()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {
        let stack = UIStackView(arrangedSubviews: [defaultFeatureLabel, defaultConfidenceLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .firstBaseline
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.layer.cornerRadius = 8

        self.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true

    }

    public func update(with classification: Classification) {
        featureLabel?.text = classification.label
        confidenceLabel?.text = String(format: "%0.1f%", arguments: [classification.confidence])
    }
}

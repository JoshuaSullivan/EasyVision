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
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .subheadline).monospacedDigitFont
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

        if featureLabel == nil && confidenceLabel == nil {
            setupViews()
        }
    }

    private func setupViews() {
        let feature = defaultFeatureLabel
        let confidence = defaultConfidenceLabel
        let stack = UIStackView(arrangedSubviews: [feature, confidence])
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

        self.featureLabel = feature
        self.confidenceLabel = confidence
    }

    public func update(with classification: Classification) {
        featureLabel?.text = classification.label
        confidenceLabel?.text = String(format: "%0.1f%%", arguments: [classification.confidence * 100.0])
    }
}

import UIKit

public class ClassificationLabelView: UIView {

    /// Displays the name of the classification.
    @IBOutlet public weak var featureLabel: UILabel?

    /// Displays the confidence of the classification.
    @IBOutlet public weak var confidenceLabel: UILabel?

    /// A feature label to use if one is not set via Interface Builder.
    private lazy var defaultFeatureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// A confidence label to use if one is not set via Interface Builder.
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

    /// Create a `ClassificationLabelView` from code.
    public init() {
        super.init(frame: .zero)

        setupViews()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        // If no labels are present, create them.
        if featureLabel == nil && confidenceLabel == nil {
            setupViews()
        }
    }

    /// Create the labels if no interface was provided by Interface Builder.
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

    /// Display the details of a `Classification`.
    public func update(with classification: Classification) {
        featureLabel?.text = classification.label
        confidenceLabel?.text = String(format: "%0.1f%%", arguments: [classification.confidence * 100.0])
    }
}

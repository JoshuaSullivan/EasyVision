import Foundation

/// Encapsulates information about a single classification result.
///
public struct Classification: Equatable, Comparable, Identifiable {

    /// The classification label associated with the classification.
    public let label: String

    /// A scalar value representing the confidence that the label is present in the image.
    ///
    /// Values will fall in the range 0.0 - 1.0
    ///
    public let confidence: Float

    // MARK: - Comparable

    public static func < (lhs: Classification, rhs: Classification) -> Bool { lhs.confidence < rhs.confidence }

    // MARK: - Identifiable

    public var id: String { label }
}

public extension Classification {
    static var loading = Classification(label: "Loading…", confidence: 1.0)
}

import Vision

extension VNObservation: Comparable {
    public static func < (lhs: VNObservation, rhs: VNObservation) -> Bool {
        lhs.confidence < rhs.confidence
    }
}

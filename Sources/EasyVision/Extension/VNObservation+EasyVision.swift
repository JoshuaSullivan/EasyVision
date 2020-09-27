import Vision

extension VNObservation: Comparable {
    static func < (lhs: VNObservation, rhs: VNObservation) -> Bool {
        lhs.confidence < rhs.confidence
    }
}

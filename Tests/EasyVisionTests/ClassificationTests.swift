import XCTest
@testable import EasyVision

final class ClassificationTests: XCTestCase {

    func testComparison() {
        let cl1 = Classification(label: "One", confidence: 0.1)
        let cl2 = Classification(label: "Two", confidence: 0.2)
        let cl3 = Classification(label: "Three", confidence: 0.3)

        let test = [cl2, cl3, cl1].sorted()

        XCTAssertEqual(test, [cl1, cl2, cl3])
    }

    func testIdentity() {
        let classification = Classification(label: "Test Label", confidence: 0.5)
        XCTAssertEqual(classification.id, "Test Label")
    }
}

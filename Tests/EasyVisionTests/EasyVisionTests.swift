import XCTest
@testable import EasyVision

final class EasyVisionTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EasyVision().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

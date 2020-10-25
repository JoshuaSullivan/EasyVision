import XCTest
import Combine
@testable import EasyVision

final class ClassificatonServiceTests: XCTest {

    var model: MockMLModel!
    var subject: ClassificationService!
    var subscription: AnyCancellable?
    var classifications: [Classification]!
    var image: CIImage!

    override func setUpWithError() throws {
        model = MockMLModel()
        subject = ClassificationService(model: model)
        classifications = []
        image = CIImage(color: .blue).cropped(to: CGRect(x: 0, y: 0, width: 640, height: 480))
    }

    func testClassify() {
        subscription = subject.classifications.sink(
            receiveCompletion: { result in
                XCTFail("The `classifications` publisher completed with an error.")
            },
            receiveValue: { classifications in
                self.classifications = classifications
            })
        let valueExpectation = XCTestExpectation(description: "Wait for a value to be received from the classification service.")
        subject.classify(image: image, orientation: .up)
        let result = XCTWaiter().wait(for: [valueExpectation], timeout: 1.0)
        XCTAssertEqual(result, .completed)
    }
}

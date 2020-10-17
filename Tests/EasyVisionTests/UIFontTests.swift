import XCTest
@testable import EasyVision

class UIFontTests: XCTestCase {

    typealias FeatureDictionary = [UIFontDescriptor.FeatureKey : AnyObject]

    func testMonospacedDigits() {
        let startingFont = UIFont.systemFont(ofSize: 15.0)
        let monoFont = startingFont.monospacedDigitFont
        let features = (monoFont.fontDescriptor.fontAttributes[UIFontDescriptor.AttributeName.featureSettings] as! [FeatureDictionary]).first!
        XCTAssertEqual(features[UIFontDescriptor.FeatureKey.featureIdentifier] as? Int, kNumberSpacingType)
        XCTAssertEqual(features[UIFontDescriptor.FeatureKey.typeIdentifier] as? Int, kMonospacedNumbersSelector)
    }
}

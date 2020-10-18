import Foundation

/// Swizzle the i
/// From: https://nshint.github.io/blog/2019/04/08/testing-the-camera-on-the-simulator/
///
struct Swizzler {
    private let klass: AnyClass

    init(_ klass: AnyClass) {
        self.klass = klass
    }

    func injectNSObjectInit(into selector: Selector) {
        guard
            let original = class_getInstanceMethod(klass, selector),
            let swizzled = class_getInstanceMethod(klass, #selector(NSObject.init))
        else {
            assertionFailure("Unable to get either the original or swizzled methods.")
            return
        }
        method_setImplementation(original, method_getImplementation(swizzled))
    }
}

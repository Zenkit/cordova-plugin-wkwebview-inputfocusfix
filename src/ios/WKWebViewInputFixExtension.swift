import Foundation
import WebKit

typealias OldClosureType = @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Any?) -> Void
typealias NewClosureType = @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void

var _keyboardDisplayRequiresUserAction = true
extension WKWebView {
    var keyboardDisplayRequiresUserAction: Bool? {
        get {
            return _keyboardDisplayRequiresUserAction
        }
        set {
            let value = newValue ?? true
            if value != _keyboardDisplayRequiresUserAction {
                _keyboardDisplayRequiresUserAction = value
                setKeyboardRequiresUserInteraction(value)
            }
        }
    }

    func setKeyboardRequiresUserInteraction(_ value: Bool) {
        guard let WKContentView: AnyClass = NSClassFromString("WKContentView") else {
            print("keyboardDisplayRequiresUserAction extension: Cannot find the WKContentView class")
            return
        }

        // For iOS >=10
        let sel_10: Selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:userObject:")
        if let method = class_getInstanceMethod(WKContentView, sel_10) {
            let originalImp: IMP = method_getImplementation(method)
            let original: OldClosureType = unsafeBitCast(originalImp, to: OldClosureType.self)
            let block: @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Any?) -> Void = { me, arg0, _, arg2, arg3 in
                original(me, sel_10, arg0, !value, arg2, arg3)
            }
            let imp: IMP = imp_implementationWithBlock(block)
            method_setImplementation(method, imp)
            return
        }

        // For iOS >=11.3
        let sel_11_3: Selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:changingActivityState:userObject:")
        if let method = class_getInstanceMethod(WKContentView, sel_11_3) {
            setImplementationWithNewClosureType(method, sel_11_3, value)
            return
        }

        // For iOS >=12.2
        let sel_12_2: Selector = sel_getUid("_elementDidFocus:userIsInteracting:blurPreviousNode:changingActivityState:userObject:")
        if let method = class_getInstanceMethod(WKContentView, sel_12_2) {
            setImplementationWithNewClosureType(method, sel_12_2, value)
            return
        }

        // For iOS >=13.0
        let sel_13_0: Selector = sel_getUid("_elementDidFocus:userIsInteracting:blurPreviousNode:activityStateChanges:userObject:")
        if let method = class_getInstanceMethod(WKContentView, sel_13_0) {
            setImplementationWithNewClosureType(method, sel_13_0, value)
            return
        }
    }

    func setImplementationWithNewClosureType(_ method: Method, _ selector: Selector, _ value: Bool) {
        let originalImp: IMP = method_getImplementation(method)
        let original: NewClosureType = unsafeBitCast(originalImp, to: NewClosureType.self)
        let block: @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void = { me, arg0, _, arg2, arg3, arg4 in
            original(me, selector, arg0, !value, arg2, arg3, arg4)
        }
        let imp: IMP = imp_implementationWithBlock(block)
        method_setImplementation(method, imp)
    }
}

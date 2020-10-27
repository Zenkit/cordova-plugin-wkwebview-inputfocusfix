import Foundation
import WebKit

@objc(WKWebViewInputFixPlugin)
public class WKWebViewInputFixPlugin: CDVPlugin {
    override public func pluginInitialize() {
        if let wkWebView = webView as? WKWebView {
            let key = "KeyboardDisplayRequiresUserAction"
            let setting = commandDelegate.settings[key.lowercased()] as? NSString
            wkWebView.keyboardDisplayRequiresUserAction = setting?.boolValue
        }
    }
}

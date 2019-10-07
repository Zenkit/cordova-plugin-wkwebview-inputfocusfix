# CDVWKWebViewEngine InputFocusFix

> Cordova plugin for fixing auto focus issue of html elements on WKWebView

This plugin adds support for the `KeyboardDisplayRequiresUserAction` setting when using the `CDVWKWebViewEngine`, by swizzling of the `WKContentView`.
_This plugin works for iOS 13.0, 12.2, 11.x and 10.x_

## Installation

Install the plugin by running:

```sh
cordova plugin add github:zenkit/cordova-plugin-wkwebview-inputfocusfix#v1.0.5
```

## Why the fork?

The [original plugin](https://github.com/onderceylan/cordova-plugin-wkwebview-inputfocusfix) was archived because it shouldn't be needed anymore.
But this seems only to be true when using the `cordova-plugin-ionic-webview` and it is still needed when using the `cordova-plugin-wkwebview-engine` because it will not be [fixed]((https://issues.apache.org/jira/browse/CB-12037?focusedCommentId=16538144&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-16538144).

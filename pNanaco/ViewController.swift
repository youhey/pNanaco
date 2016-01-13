//
//  ViewController.swift
//  pNanaco
//
//  Created by 池田 洋平 on 2016/01/10.
//  Copyright © 2016年 IKEDA Youhey. All rights reserved.
//

import UIKit
import WebKit

/// 画面上部に設けるマージン高さ
let screenMarginTop: CGFloat = CGFloat(20)

/**
    ポータル nanaco のメイン View コントローラ
 */
class ViewController: UIViewController, WKNavigationDelegate {

    /// 内部ブラウザ
    var browser: WKWebView!

    /// ポータル nanaco のデータ
    let nanaco: Nanaco = Nanaco()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()

        view.addSubview(self.browser)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadRequest(self.nanaco.loginUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
        ポータル nanaco を初期化
     */
    func setup() {
        self.nanaco.loadUserConfig()

        let jsSrc: String = self.buildAutomationJavaScript()

        let userScript: WKUserScript =  WKUserScript(source: jsSrc, injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: true)

        self.browser = self.createWebView(userScript)
        self.browser.navigationDelegate = self
    }

    /**
        ポータル nanaco を初期化

        - parameter userScript: WebView で読み込む JavaScript
     */
    func createWebView(userScript: WKUserScript) -> WKWebView {
        let bound: CGRect = UIScreen.mainScreen().bounds
        let width: CGFloat = bound.size.width
        let height: CGFloat = bound.size.height
        let frame: CGRect = CGRectMake(0, screenMarginTop, width, height - screenMarginTop)

        let userController: WKUserContentController = WKUserContentController()
        userController.addUserScript(userScript)

        let conf: WKWebViewConfiguration = WKWebViewConfiguration()
        conf.userContentController = userController

        let webView: WKWebView = WKWebView(frame: frame, configuration: conf)

        webView.autoresizingMask = [
            .FlexibleLeftMargin,
            .FlexibleTopMargin,
            .FlexibleRightMargin,
            .FlexibleBottomMargin,
            .FlexibleWidth,
            .FlexibleHeight
        ]
        webView.clipsToBounds = true
        webView.allowsBackForwardNavigationGestures = false

        return webView
    }

    /**
        ブラウザ上の自動化処理を実装した JavaScript を組み立て

        - returns: JavaScript
     */
    func buildAutomationJavaScript() -> String {
        let defaultJSURL: String = NSBundle.mainBundle().pathForResource("default", ofType: "js")!
        let inputJSURL: String = NSBundle.mainBundle().pathForResource("autoinput", ofType: "js")!
        let loginJSURL: String = NSBundle.mainBundle().pathForResource("autologin", ofType: "js")!

        let autoInputVars: Dictionary<String,String> = [
            "@nanacoId": self.nanaco.nanacoId,
            "@securityNumber": self.nanaco.securityNumber,
            "@loginPassword": self.nanaco.loginPassword,
            "@chargePassword": self.nanaco.chargePassword,
        ]
        let autoLoginVars: Dictionary<String,String> = [
            "@autoLogin": String(self.nanaco.autoLogin)
        ]

        var src: String = ""
        
        do {
            let defaultJS: String = try String(contentsOfFile: defaultJSURL, encoding: NSUTF8StringEncoding)
            src = src + defaultJS
        } catch {
            // ignore
        }

        // @todo ページを識別して必要時だけ実行してもいい気はする
        do {
            var autoInputJS: String = try String(contentsOfFile: inputJSURL, encoding: NSUTF8StringEncoding)
            for (key, value) in autoInputVars {
                autoInputJS = autoInputJS.stringByReplacingOccurrencesOfString(key, withString: value);
            }
            src = src + autoInputJS
        } catch {
            // ignore
        }

        // @todo ページを識別して必要時だけ実行してもいい気はする
        do {
            var autoLoginJS: String = try String(contentsOfFile: loginJSURL, encoding: NSUTF8StringEncoding)
            for (key, value) in autoLoginVars {
                autoLoginJS = autoLoginJS.stringByReplacingOccurrencesOfString(key, withString: value);
            }
            src = src + autoLoginJS
        } catch {
            // ignore
        }

        return src;
    }

    /**
        内部ブラウザで nanaco の 会員メニュー Web サイトにアクセス
     
        - parameter url: 起動するURL
     */
    func loadRequest(url: String) {
        let query: NSURL = NSURL(string: url)!
        let request: NSURLRequest = NSURLRequest(URL: query)
        self.browser?.loadRequest(request)
    }

    #if DEBUG

    ///  ページの読み込み完了
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!)
    {
        var currentHost: String = ""
        var currentPath: String = ""
        var currentQuery: Dictionary<String, String> = Dictionary<String, String>()

        let host: String? = self.browser?.URL?.path
        if (host != nil) {
            currentHost = host!
        }

        let path: String? = self.browser?.URL?.path
        if (path != nil) {
            currentPath = path!
        }

        let query: Dictionary<String, String>? = parseQueryString(self.browser?.URL)
        if (query != nil) {
            currentQuery = query!
        }

        NSLog("host: " + currentHost)
        NSLog("path: " + currentPath)
        NSLog("query: " + currentQuery.debugDescription)
    }

    /**
        NSURL からクエリストリングの辞書を生成

        - parameter url: 取り出したい NSURL
        - returns: クエリストリングの辞書
    */
    func parseQueryString(url: NSURL?) ->  Dictionary<String, String>? {
        if (url == nil) {
            return nil
        }

        let components: NSURLComponents? = NSURLComponents(string: (url?.absoluteString)!)

        var dict: Dictionary<String, String> =  Dictionary<String, String>()
        
        for (var i = 0; i < components?.queryItems?.count; i++) {
            let item = (components?.queryItems?[i])! as NSURLQueryItem
            dict[item.name] = item.value
        }
        
        return dict
    }

    #endif

}

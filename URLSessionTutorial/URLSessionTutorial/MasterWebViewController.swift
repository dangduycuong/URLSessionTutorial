//
//  MasterWebViewController.swift
//  URLSessionTutorial
//
//  Created by Dang Duy Cuong on 1/14/21.
//  Copyright © 2021 Dang Duy Cuong. All rights reserved.
//

import UIKit
import WebKit

class MasterWebViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        setRightBarButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: {
            self.loadAddress()
        })
    }
    
    func setRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onClickedReload))
        
        let bar = UIBarButtonItem(image: #imageLiteral(resourceName: "rwdevcon-bg"), style: .plain, target: self, action: #selector(onClickedReload))
        navigationItem.rightBarButtonItem = bar
    }
    
    func webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo) {
        print("print contextMenuDidEndForElement")
    }
    
    func webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo) {
        print("print contextMenuWillPresentForElement")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("print runJavaScriptAlertPanelWithMessage")
    }
    
    func webView(_ webView: WKWebView, contextMenuForElement elementInfo: WKContextMenuElementInfo, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
        print("print contextMenuForElement")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("print runJavaScriptConfirmPanelWithMessage")
    }
    
//    func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
//        print("print contextMenuConfigurationForElement")
//    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("print createWebViewWith")
        return webView
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("runJavaScriptTextInputPanelWithPrompt")
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print("webViewDidClose")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
        showLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish  navigation: WKNavigation!) {
        let url = webView.url?.absoluteString
        print("---Hitted URL--->\(url!)") // here you are getting URL
        hideLoading()
    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoading()
        print("didFail")
    }
    
    func loadAddress() {
        let url = "https://google.com"
//        let url = """
//        https://www.google.com/maps/dir//\(latitude),\(longitude)/@\(latitude),\(longitude)z/data=!4m2!4m1!3e0
//        """
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    
    @objc func onClickedReload(_ sender: Any) {
        loadAddress()
    }
    
    // MARK: Actions
    
}

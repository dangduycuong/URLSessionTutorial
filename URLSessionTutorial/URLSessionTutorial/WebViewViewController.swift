//
//  WebViewViewController.swift
//  URLSessionTutorial
//
//  Created by Dang Duy Cuong on 1/14/21.
//  Copyright © 2021 Dang Duy Cuong. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadAddress()
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
        let url = "https://www.youtube.com/watch?v=liHYSE1aI3E"
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

}

//
//  ViewController.swift
//  designHuddleTest
//
//  Created by Rodrigo Bueno Tomiosso on 20/12/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupLayout()
        super.viewDidAppear(animated)
    }
    
    private func setupLayout() {
        self.viewDidLayoutSubviews()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.bounces = false
    }
    
    private func setupWebView() {
        let contentController = WKUserContentController()

        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.userContentController = contentController
        webView = WKWebView( frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = false
        webView.navigationDelegate = self
        webView.configuration.dataDetectorTypes = [.phoneNumber]

        view.addSubview(self.webView)
    }
    
    private func load() {
        let urlString = "https://design.avenue8.com/editor?token=419b86c7bcf8dce473e08b8ed9f6f49c57552d9b&project_id=c8cges34jjwg028h8pyg"
        guard let url = URL(string: urlString) else { fatalError("url not valid") }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust));
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message received \(message.name)")
    }
            
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.targetFrame?.isMainFrame != false else {
           decisionHandler(.allow)
           return
         }
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        print("Will load url: \n \(url.absoluteString)")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail Navigation \(error.localizedDescription)")
    }

}

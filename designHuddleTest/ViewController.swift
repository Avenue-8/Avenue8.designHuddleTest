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
        
        WebIntegration.allCases.forEach { action in
            contentController.add(self, name: action.rawValue)
        }
        
        view.addSubview(self.webView)
    }
    
    private func load() {
        let urlString = "https://staging.avenue8.com/account/home/tools?mbd=true&agentId=133&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Im1hcmN1cy5zYW5hdGFuQGF2ZW51ZTguY29tIiwic3ViIjoxMzMsImlhdCI6MTY0MDAyODcxNywiZXhwIjoxNjQwMTE1MTE3fQ.AcxofyfxXOhfpBnnOffTg6Q4uV9Fc92YrO5mvX3_PFs"
        guard let url = URL(string: urlString) else { fatalError("url not valid") }
        webView.load(URLRequest(url: url))
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message received \(message.name)")
    }
            
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
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


enum WebIntegration: String {
    case facebook = "facebook"
    case instagram = "instagram"
    case download = "download"
    case processPDF = "PDF"
    case processCSV = "CSV"
    case meMarketingRequest = "meMarketingRequest"
    case exit = "exit"
    case hideBackButton = "hideBackButton"
    case enableBackButton = "enableBackButton"
    case presentActionSheet = "presentActionSheet"
    case backHome = "backHome"
    case share = "share"
    case processZIP = "ZIP"
    case toggleSidebar = "toggleSidebar"
    case showAppMenu = "showAppMenu"

    static var allCases: [WebIntegration] {
        return [
            .facebook,
            .instagram,
            .download,
            .processPDF,
            .processCSV,
            .meMarketingRequest,
            .exit,
            .hideBackButton,
            .enableBackButton,
            .presentActionSheet,
            .backHome,
            .share,
            .processZIP,
            .toggleSidebar,
            .showAppMenu,
            ]
    }

}

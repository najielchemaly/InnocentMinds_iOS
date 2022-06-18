//
//  PayFeeViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/17/19.
//  Copyright © 2019 infosys. All rights reserved.
//

import UIKit
import WebKit

class PayFeeViewController: BaseViewController {
    @IBOutlet weak var labelPayFee: UILabel!
    @IBOutlet weak var parentView: UIView!
    
    var webView: WKWebView!
    
    let paymentUrl = "http://13.74.16.246/payment/"
    let paymentEndpoit = "payment/"
    var invoiceNumner = ""
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController();
        contentController.add(self, name: "PaymentSuccess")
        webConfiguration.userContentController = contentController
        webView = WKWebView(frame: parentView.frame, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.addSubview(webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let url = URL(string: "\(paymentUrl)\(paymentEndpoit)\(invoiceNumner)") else {
            return
        }
        webView.load(URLRequest(url: url))
                
        self.showLoader(backgroundColor: .black)
    }
    
    @IBAction func buttonCloseAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PayFeeViewController: WKUIDelegate, WKNavigationDelegate {
    func webViewDidClose(_ webView: WKWebView) {
        print("Closed")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoader()
        
        guard let url = webView.url else {
            return
        }
        let callback = url.absoluteString.replacingOccurrences(of: paymentUrl, with: "")
        switch callback {
        case "PaymentSuccess":
            self.showAlert(message: Localization.string(key: "PaymentSuccess"), style: .alert, dismissVC: true)
        case "PaymentFailure":
            self.showAlert(message: Localization.string(key: "PaymentFailure"), style: .alert)
        default:
            break
        }
    }
}

extension PayFeeViewController: WKScriptMessageHandler {
    func userContentController(
        _ userContentController:
        WKUserContentController,
        didReceive message: WKScriptMessage) {
        if message.name == "PaymentSuccess",
        let dict = message.body as? NSDictionary {
            print(dict)
        }
    }
}

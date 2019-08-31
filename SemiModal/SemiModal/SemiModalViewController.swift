//
//  SemiModalViewController.swift
//  SemiModal
//
//  Created by Michael Laurents on 2019/08/31.
//  Copyright © 2019 Michael Laurents. All rights reserved.
//

import UIKit
import WebKit

class SemiModalViewController: UIViewController, WKNavigationDelegate{
    
    let wkWebView = WKWebView()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        wkWebView.frame = view.frame
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        
        let urlRequest = URLRequest(url:URL(string:"https://wire-hub.herokuapp.com/")!)
        wkWebView.load(urlRequest)
        view.addSubview(wkWebView)
        // Do any additional setup after loading the view.
        //self.view.backgroundColor = UIColor.orange
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SemiModalViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        
        return nil
    }
    
}

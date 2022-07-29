//
//  DetailViewController.swift
//  project7
//
//  Created by Mohamed Fawzi on 6/17/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailItem = detailItem else { return }
        let html = """
                    <html>
                    <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style> body { font-size: 100%; } </style>
                    </head>
                    <body>
                    <h2 style="color:Tomato;"><b>\(detailItem.title)</b></h2>
                    <p style="color:DodgerBlue; font-size:110%;">\(detailItem.body)</p>
                    </body>
                    </html>
                   """
        webView.loadHTMLString(html, baseURL: nil)

        
    }
    


}

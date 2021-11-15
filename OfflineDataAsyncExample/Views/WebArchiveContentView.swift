//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import SwiftUI
import WebKit

struct WebArchiveContentView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadFileURL(url, allowingReadAccessTo: url)
    }
}

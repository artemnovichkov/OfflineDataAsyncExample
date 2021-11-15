//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import WebKit

final class WebDataManager: NSObject {
    
    enum DataError: Error {
        case noImageData
    }
    
    enum DataType: String,  CaseIterable {
        case snapshot = "Snapshot"
        case pdf = "PDF"
        case webArchive = "Web Archive"
    }
    
    private var type: DataType = .webArchive
    private var continuation: CheckedContinuation<Data, Error>?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()

    @MainActor
    func createData(url: URL, type: DataType) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            self.type = type
            self.webView.load(.init(url: url))
        }
    }
}

extension WebDataManager: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        switch type {
        case .snapshot:
            let config = WKSnapshotConfiguration()
            config.rect = .init(origin: .zero, size: webView.scrollView.contentSize)
            webView.takeSnapshot(with: config) { [weak self] image, error in
                if let error = error {
                    self?.continuation?.resume(throwing: error)
                    return
                }
                guard let pngData = image?.pngData() else {
                    self?.continuation?.resume(throwing: DataError.noImageData)
                    return
                }
                self?.continuation?.resume(returning: pngData)
            }
        case .pdf:
            let config = WKPDFConfiguration()
            config.rect = .init(origin: .zero, size: webView.scrollView.contentSize)
            webView.createPDF(configuration: config) { [weak self] result in
                self?.continuation?.resume(with: result)
            }
        case .webArchive:
            webView.createWebArchiveData { [weak self] result in
                self?.continuation?.resume(with: result)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.continuation?.resume(throwing: error)
    }
}

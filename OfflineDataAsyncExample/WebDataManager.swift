//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import WebKit

@MainActor
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
    private var continuation: CheckedContinuation<Void, Error>?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()

    func createData(url: URL, type: DataType) async throws -> Data {
        try await load(url)
        switch type {
        case .snapshot:
            let config = WKSnapshotConfiguration()
            config.rect = .init(origin: .zero, size: webView.scrollView.contentSize)
            let image = try await webView.takeSnapshot(configuration: config)
            guard let pngData = image.pngData() else {
                throw DataError.noImageData
            }
            return pngData
        case .pdf:
            let config = WKPDFConfiguration()
            config.rect = .init(origin: .zero, size: webView.scrollView.contentSize)
            return try await webView.pdf(configuration: config)
        case .webArchive:
            return try await webView.webArchiveData()
        }
    }

    //MARK: - Private

    private func load(_ url: URL) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            self.webView.load(.init(url: url))
        }
    }
}

extension WebDataManager: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        continuation?.resume(returning: ())
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        continuation?.resume(throwing: error)
    }
}

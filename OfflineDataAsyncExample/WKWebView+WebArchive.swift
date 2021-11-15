//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import WebKit

extension WKWebView {

    func webArchiveData() async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            createWebArchiveData { result in
                continuation.resume(with: result)
            }
        }
    }
}

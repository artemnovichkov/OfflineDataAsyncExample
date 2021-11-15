//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//
import SwiftUI

enum Sheet: View, Identifiable {
    
    case webarchive(URL)
    case pdf(URL)
    case png(URL)
    
    var id: String {
        switch self {
        case .webarchive:
            return "webarchive"
        case .pdf:
            return "pdf"
        case .png:
            return "png"
        }
    }
    
    var body: some View {
        ModalView {
            switch self {
            case .webarchive(let url):
                WebArchiveContentView(url: url)
            case .pdf(let url):
                PDFContentView(url: url)
            case .png(let url):
                SnapshotContentView(url: url)
            }
        }
    }
}

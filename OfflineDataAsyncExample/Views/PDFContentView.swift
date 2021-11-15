//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import SwiftUI
import PDFKit

struct PDFContentView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.document = PDFDocument(url: url)
        return view
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
    }
}

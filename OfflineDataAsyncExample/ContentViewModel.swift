//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import SwiftUI

@MainActor
final class ContentViewModel {
    
    //MARK: - Button Data
    
    struct ButtonData: Identifiable {
        let title: String
        let url: URL
        let sheet: Sheet
        
        var id: String {
            url.absoluteString
        }
        
        init(title: String, sheet: Sheet) {
            self.title = title
            self.sheet = sheet
            switch sheet {
            case .png(let url):
                self.url = url
            case .pdf(let url):
                self.url = url
            case .webarchive(let url):
                self.url = url
            }
        }
    }
    
    var buttonsData: [ButtonData] {
        [.init(title: "Open Snapshot", sheet: .png(pngURL)),
         .init(title: "Open PDF", sheet: .pdf(pdfURL)),
         .init(title: "Open WebArchive", sheet: .webarchive(webarchiveURL))]
    }
    
    //MARK: - Managers
    
    private lazy var webDataManager: WebDataManager = .init()
    private lazy var fileManager: FileManager = .default
    
    //MARK: - URLs
    
    private var documentsURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var webarchiveURL: URL {
        documentsURL
            .appendingPathComponent("data")
            .appendingPathExtension("webarchive")
    }
    
    private var pdfURL: URL {
        documentsURL
            .appendingPathComponent("data")
            .appendingPathExtension("pdf")
    }
    
    private var pngURL: URL {
        documentsURL
            .appendingPathComponent("data")
            .appendingPathExtension("png")
    }
    
    //MARK: - Lifecycle
    
    func createData(url: URL, type: WebDataManager.DataType) async throws {
        let data = try await webDataManager.createData(url: url, type: type)
        self.fileManager.createFile(atPath: self.path(for: type),
                                    contents: data,
                                    attributes: nil)
    }
    
    func fileExists(for data: ButtonData) -> Bool {
        fileManager.fileExists(atPath: data.url.path)
    }
    
    //MARK: - Private
    
    private func path(for type: WebDataManager.DataType) -> String {
        switch type {
        case .webArchive:
            return webarchiveURL.path
        case .pdf:
            return pdfURL.path
        case .snapshot:
            return pngURL.path
        }
    }
}

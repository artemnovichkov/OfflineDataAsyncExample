//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//
import SwiftUI

struct SnapshotContentView: View {
    
    let url: URL
    
    var body: some View {
        if let image = UIImage(contentsOfFile: url.path) {
            ScrollView {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
        else {
            Text("Fail to load image")
        }
    }
}

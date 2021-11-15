//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import SwiftUI

extension URL: Identifiable {
    
    public var id: String {
        absoluteString
    }
}

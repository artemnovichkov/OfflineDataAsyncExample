//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import SwiftUI

extension URL: @retroactive Identifiable {
    
    public var id: String {
        absoluteString
    }
}

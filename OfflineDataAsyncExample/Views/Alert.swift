//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import SwiftUI

enum Alert: Identifiable {
    
    case success(String)
    case wrongURL
    case error(Error)
    
    var id: String {
        switch self {
        case .success:
            return "success"
        case .wrongURL:
            return "wrongURL"
        case .error:
            return "error"
        }
    }
    
    var alert: SwiftUI.Alert {
        .init(title: Text(title),
              message: Text(message),
              dismissButton: .default(Text("OK")))
    }
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .wrongURL, .error:
            return "Error"
        }
    }
    
    var message: String {
        switch self {
        case .success(let message):
            return message
        case .wrongURL:
            return "Fail to get URL"
        case .error(let error):
            return error.localizedDescription
        }
    }
}

//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import SwiftUI

@main
struct OfflineDataAsyncExampleApp: App {
    var body: some Scene {
        UITextField.appearance().clearButtonMode = .whileEditing
        return WindowGroup {
            ContentView()
        }
    }
}

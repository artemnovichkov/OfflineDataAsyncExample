//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import SwiftUI

struct ModalView<Content>: View where Content: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            #if targetEnvironment(macCatalyst)
            HStack() {
                Spacer()
                Button(action: close) {
                    SFSymbol.xmark
                }
            }
            .padding()
            #endif
            content
        }
    }
    
    //MARK: - Private
    
    private func close() {
        presentationMode.wrappedValue.dismiss()
    }
}

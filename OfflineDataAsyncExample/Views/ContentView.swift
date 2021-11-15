//
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//
import SwiftUI

struct ContentView: View {
    
    //MARK: - States
    
    @State private var text: String = "https://www.artemnovichkov.com"
    @State private var alert: Alert?
    @State private var actionSheetIsPresented = false
    @State private var sheet: Sheet?
    @State private var isLoading = false
    
    //MARK: - ViewModel
    
    private let viewModel: ContentViewModel = .init()
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            ProgressView("Loading...")
                .opacity(isLoading ? 1 : 0)
            VStack(spacing: 16) {
                TextField("", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack(spacing: 32, content: buttons)
            }
            .padding()
            .opacity(isLoading ? 0 : 1)
            .alert(item: $alert) { $0.alert }
            .actionSheet(isPresented: $actionSheetIsPresented, content: actionSheet)
            .sheet(item: $sheet) { $0 }
        }
    }
    
    @ViewBuilder
    private func buttons() -> some View {
        Button("Save") {
            actionSheetIsPresented = true
        }
        .disabled(URL(string: text) == nil)
        ForEach(viewModel.buttonsData) { data in
            Button(action: {
                sheet = data.sheet
            }, label: {
                Text(data.title)
                    .multilineTextAlignment(.center)
            })
            .disabled(viewModel.fileExists(for: data) == false)
        }
    }
    
    private func actionSheet() -> ActionSheet {
        var buttons: [ActionSheet.Button] = WebDataManager.DataType.allCases.map { type in
            .default(Text(type.rawValue)) {
                save(with: type)
            }
        }
        buttons.append(.cancel())
        return ActionSheet(title: Text("Select a type"), message: nil, buttons: buttons)
    }
    
    //MARK: - Private
    
    private func save(with type: WebDataManager.DataType) {
        guard let url = URL(string: text) else {
            alert = .wrongURL
            return
        }
        Task {
            do {
                isLoading = true
                try await viewModel.createData(url: url, type: type)
                isLoading = false
                alert = .success("\(type.rawValue) is saved successfully")
            }
            catch {
                alert = .error(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

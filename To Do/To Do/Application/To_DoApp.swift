import SwiftUI

@main
struct To_DoApp: App {
    
    @State var viewModel = ViewModelAuth()
    
    var body: some Scene {
        WindowGroup {
            ViewMain(viewModel: viewModel)
        }
    }
}

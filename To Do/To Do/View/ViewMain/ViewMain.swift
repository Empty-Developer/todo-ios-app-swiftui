import SwiftUI

struct ViewMain: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello World")
                .urbanistFont(fontType: .black, size: 30)
        }
        .padding()
    }
}

#Preview {
    ViewMain()
}

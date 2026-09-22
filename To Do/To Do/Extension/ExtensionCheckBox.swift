import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: configuration.isOn
                      ? "checkmark.square.fill"
                      : "square")
                    .font(.system(size: 24))
                
                configuration.label
            }
        }
        .buttonStyle(.plain)
    }
}

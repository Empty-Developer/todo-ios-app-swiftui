import SwiftUI

struct FontModifier: ViewModifier {
    var fontType: UrbanistModel
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(.custom(fontType.rawValue, size: size))
    }
}

extension Text {
    func urbanistFont(fontType: UrbanistModel = .medium, size: CGFloat = 14) -> some View {
        self.modifier(FontModifier(fontType: fontType, size: size))
    }
}

extension TextField {
    func urbanistFont(fontType: UrbanistModel = .medium, size: CGFloat = 14) -> some View {
        self.modifier(FontModifier(fontType: fontType, size: size))
    }
}

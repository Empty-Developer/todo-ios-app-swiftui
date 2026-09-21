import SwiftUI

struct ViewMain: View {
    var body: some View {
        VStack {
            // MARK: Header bar
            HStack {
                Text("To do app")
                    .urbanistFont(fontType: .semiBold, size: 17)
                
                Spacer()
                
                Text("Add item")
                    .urbanistFont(fontType: .semiBold, size: 14)
                Image(.iconPlus)
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            .backgroundStyle(.appLighWhite)
            Spacer()
            
            // MARK: Center Content
            Image(.mainImg)
            Text("No to do item here. \n Create one!")
                .urbanistFont(fontType: .semiBold, size: 15)
                .multilineTextAlignment(.center)
                .foregroundStyle(.appGray)
            
            Button{
                // code
            } label: {
                Text("Add a to do")
                    .urbanistFont(fontType: .semiBold, size: 14)
                    .foregroundStyle(.white)
            }
            .frame(width: 220, height: 48)
            .background(Color.appBlack, in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous)
            )
            .padding(40)
            
            Spacer()
                
        }
        .backgroundStyle(.appWhite)
        .padding()
    }
}

#Preview {
    ViewMain()
}

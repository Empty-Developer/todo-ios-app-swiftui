import SwiftUI

struct ViewMain: View {
    @State var isNextSuccess = false
    
    // TODO:
    // 1) create component item
    // 2) create function for delete main component for item
    // 3) create Stak forEch for items
    
    var body: some View {
        NavigationStack{
            VStack {
                // MARK: Header bar
                HStack {
                    Text("To do app")
                        .urbanistFont(fontType: .semiBold, size: 17)
                        .foregroundStyle(.appBlack)
                    
                    Spacer()
                    
                    NavigationLink {
                        ViewAddedItem()
                    } label: {
                        Text("Add item")
                            .urbanistFont(fontType: .semiBold, size: 14)
                            .foregroundStyle(.appBlack)
                        Image(.iconPlus)
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    
                    
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, maxHeight: 89)
                .padding(.top, 51)
                .background(Color.appLighWhite)
                

                Spacer()
                
                // MARK: Center Content
                VStack {
                    Image(.mainImg)
                    Text("No to do item here.\nCreate one!")
                        .urbanistFont(fontType: .semiBold, size: 15)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.appGray)
                        .frame(width: 141, height: 48)
                    
                    NavigationLink {
                        ViewAddedItem()
                    } label: {
                        Text("Add a to do")
                            .urbanistFont(fontType: .semiBold, size: 14)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 220, height: 48)
                    .background(Color.appBlack, in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous)
                    )
                    .padding(.top, 40)
                }
                
                Spacer()
                    
            }
            .ignoresSafeArea(edges: .top)
            .background(Color.appWhite)
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ViewMain()
}

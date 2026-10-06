import SwiftUI

struct ViewMain: View {
    @State var isNextSuccess = false
    @State var doesClose = false
    @State var titleTextItem = "Item..."
    @State var selectSearch = ""
    
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
                
                
                // MARK: Search Component
                VStack {
                    HStack {
                        Image(.search)
                            .resizable()
                            .frame(width: 23, height: 23)
                        TextField("Search here", text: $selectSearch)
                            .urbanistFont(fontType: .medium, size: 13)
//                            .foregroundStyle(Color.appGray)
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("Sort by date")
                                .urbanistFont(fontType: .medium, size: 13)
                                .foregroundStyle(Color.appGray)
                        }
                        .padding(.vertical, 24)
                    }
                    .padding(.horizontal, 24)
                    
                }
                .border(width: 1, edges: [.bottom], color: .appWhiteBlue)
                
                // MARK: Item Component And Search Component
                VStack {
                    HStack {
                        Toggle("\(titleTextItem)", isOn: $doesClose)
                            .urbanistFont(fontType: .semiBold, size: 18)
                            .toggleStyle(CheckboxToggleStyle())
                        
                        Spacer()
                        
                        Button{
                            // code
                        } label: {
                            Image(.more2Line)
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                        
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 1)

                    // MARK: Data Type
                    HStack {
                        Text("data...")
                            .urbanistFont(fontType: .bold, size: 13)
                            .foregroundStyle(.appGray)
                            .padding(.bottom, 16)
                        Spacer()
                    }
                    .padding(.horizontal, 60)
                }
                .border(width: 1, edges: [.bottom], color: .appWhiteBlue)
//
                Spacer()
                
                // MARK: Center Content
//                VStack {
//                    Image(.mainImg)
//                    Text("No to do item here.\nCreate one!")
//                        .urbanistFont(fontType: .semiBold, size: 15)
//                        .multilineTextAlignment(.center)
//                        .foregroundStyle(.appGray)
//                        .frame(width: 141, height: 48)
//                    
//                    NavigationLink {
//                        ViewAddedItem()
//                    } label: {
//                        Text("Add a to do")
//                            .urbanistFont(fontType: .semiBold, size: 14)
//                            .foregroundStyle(.white)
//                    }
//                    .frame(width: 220, height: 48)
//                    .background(Color.appBlack, in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous)
//                    )
//                    .padding(.top, 40)
//                }
//                
//                Spacer()
//                    
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

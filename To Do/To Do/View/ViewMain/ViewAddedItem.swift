import SwiftUI

struct ViewAddedItem: View {
    // TODO:
    // 1) create save protocol for "Add" button
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectTitle: String = ""
    @State private var selectDataInput: Date?
    
    var body: some View {
        VStack {
            // MARK: Header bar
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(.arrowLeft)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                Text("Add a new item")
                    .urbanistFont(fontType: .semiBold, size: 17)
                    .foregroundStyle(.appBlack)
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 89)
            .padding(.top, 51)
            .background(Color.appLighWhite)
            
            VStack {
                HStack {
                    Text("Title")
                    Spacer()
                }
                
                HStack {
                    TextField("Do something great", text: $selectTitle)
                        .urbanistFont(fontType: .regular, size: 16)
                        .foregroundStyle(Color.appBlack)
                }
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(Color.appLighWhite, in: RoundedRectangle(cornerSize: CGSize(width: 6, height: 6)))
                .overlay(
                    RoundedRectangle(cornerSize: CGSize(width: 6, height: 6))
                        .stroke(Color.appWhiteBlue, lineWidth: 1)
                )
                .padding(.bottom, 24)
                
                HStack {
                    Text("Due date")
                    Spacer()
                }
                
                HStack {
                    DataPickerTextField(placeholder: "Select Data", date: self.$selectDataInput)
                    
                }
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(Color.appLighWhite, in: RoundedRectangle(cornerSize: CGSize(width: 6, height: 6)))
                .overlay(
                    RoundedRectangle(cornerSize: CGSize(width: 6, height: 6))
                        .stroke(Color.appWhiteBlue, lineWidth: 1)
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            Spacer()
            
            // MARK: Button
            VStack {
                
                Button{
                    // code
                } label: {
                    Text("Add")
                        .urbanistFont(fontType: .semiBold, size: 14)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.appBlack, in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous)
                )
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 35)
                
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.appWhite)
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.light)
    }
}

#Preview {
    ViewAddedItem()
}

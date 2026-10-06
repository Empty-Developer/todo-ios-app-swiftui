import SwiftUI

struct ViewAuth: View {
    @State private var passwordText: String = ""
    
    var body: some View {
        VStack {
            
            
            VStack {
                HStack {
                    Text("Email Address")
                    Spacer()
                }
                
                HStack {
                    Image(.iconPlus)
                        .resizable()
                        .frame(width: 18, height: 18)
                    TextField("emailAdess.gmail.com", text: $passwordText)
                    Button{
                        // code
                    } label: {
                        Image(.iconPlus)
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    
                }
                
                HStack {
                    Text("Password")
                    Spacer()
                }
                
                HStack {
                    Image(.iconPlus)
                        .resizable()
                        .frame(width: 18, height: 18)
                    TextField("password...", text: $passwordText)
                    Button{
                        // code
                    } label: {
                        Image(.iconPlus)
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    
                }
                
                VStack {
                    // line
                }
            }
            
            HStack {
                Text("Are your don’t have account?")
                Spacer()
            }
            
            VStack {
                
                Button{
                    // code
                } label: {
                    Text("Login")
                        .urbanistFont(fontType: .semiBold, size: 14)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.appBlack, in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous)
                )
                .padding(.horizontal, 24)
            }
        }
        
    }
}

#Preview {
    ViewAuth()
}

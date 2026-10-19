import SwiftUI
import Combine

struct ViewAuth: View {

    @Bindable var viewModel: ViewModelAuth
    
    var body: some View {
        VStack {
            // MARK: Email Input
            VStack {
                Text(viewModel.isSignOn ? "Log In" : "Sign Up")
                    .urbanistFont(fontType: .bold, size: 26)
                    .foregroundStyle(.appBlack)
                VStack {
                    HStack {
                        Text("Email Address")
                            .urbanistFont(fontType: .medium, size: 13)
                            .foregroundStyle(.appGray)
                        
                        Spacer()
                    }
                    // MARK: TextField Email
                    HStack {
                        Image(.mail)
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        TextField("email...", text: $viewModel.user.email)
                    }
                }
                .castomStyle()
                
                // MARK: Password Input
                VStack {
                    HStack {
                        Text("Password")
                            .urbanistFont(fontType: .medium, size: 13)
                            .foregroundStyle(.appGray)
                        
                        Spacer()
                    }
                    // MARK: TextField Password
                    HStack {
                        Image(.lock)
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        TextField("password...", text: viewModel.pointClosePassword)
                            
                        
                        Button{
                            viewModel.isOpen.toggle()
                        } label: {
                            Image(uiImage: viewModel.isEyeCheck)
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        
                    }
                }
                .castomStyle()
                
            }
            
            HStack {
                Button {
                    viewModel.isSignOn.toggle()
                } label: {
                    Text(viewModel.isSignOn ? "Don’t have an account? Sign Up" : "Already have an account? Log In")
                        .urbanistFont(fontType: .semiBold, size: 13)
                        .foregroundStyle(.appBlack)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 15)
            
            
            VStack {
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                ButtonView(isDisabled: viewModel.isButtonDisabled, isSign: viewModel.isSignOn) {
                    viewModel.submit() 
                    
                    
                }
                
            }
        }
        .preferredColorScheme(.light)
        
    }
    
}

#Preview {
    ViewAuth(viewModel: ViewModelAuth())
}


struct VStackViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 15)
            .border(width: 1, edges: [.bottom], color: .appWhiteBlue)
            .padding(.horizontal, 24)
    }
}

extension View {
    func castomStyle() -> some View {
        modifier(VStackViewModifier())
    }
}

struct ButtonView: View {
    let isDisabled: Bool
    let isSign: Bool
    let action: () -> Void
    
    var body: some View {
        Button{
            action()
        } label: {
            Text(isSign ? "Log In" : "Sign Up")
                .urbanistFont(fontType: .semiBold, size: 14)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: 48)
        .background(isDisabled ? .appWhiteGray : .appBlack, in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous)
        )
        .padding(.horizontal, 24)
        .disabled(isDisabled)
    }
}

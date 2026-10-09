import SwiftUI
import Combine

struct ViewAuth: View {

    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var openEye: UIImage = .eye
    @State private var closeEye: UIImage = .eyeInvisible
    @State private var isOpen: Bool = true
    
    @State private var previousCount: Int = 0

    @State private var isSignOn: Bool = true
    
    private var isButtonDisabled: Bool {
        email.isEmpty || password.isEmpty
    }
    
    private var isEyeCheck: UIImage {
        if isOpen == true {
            return openEye
        } else {
            return closeEye
        }
    }
    
    private var pointClosePassword: Binding<String>{
        Binding<String>(
            get: {
                if isOpen {
                    return password
                } else {
                    return String(repeating: "·", count: password.count)
                }
            },
            set: { newValue in
                if isOpen {
                    password = newValue
                } else {
                    if newValue.count < previousCount {
                        if !password.isEmpty {
                            password.removeLast()
                        }
                    } else if newValue.count > previousCount {
                        if let lastChar = newValue.last {
                            password.append(lastChar)
                        }
                    }
                }
                previousCount = password.count
            }
        )
    }
    
    var body: some View {
        VStack {
            // MARK: Email Input
            VStack {
                Text(isSignOn ? "Log In" : "Sign Up")
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
                        
                        TextField("email...", text: $email)
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
                        
                        TextField("password...", text: pointClosePassword)
                            
                        
                        Button{
                            isOpen.toggle()
                        } label: {
                            Image(uiImage: isEyeCheck)
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        
                    }
                }
                .castomStyle()
                
            }
            
            HStack {
                Button {
                    isSignOn.toggle()
                } label: {
                    Text(isSignOn ? "Don’t have an account? Sign Up" : "Already have an account? Log In")
                        .urbanistFont(fontType: .semiBold, size: 13)
                        .foregroundStyle(.appBlack)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 15)
            
            
            VStack {
                
                Button{
                    
                } label: {
                    Text(isSignOn ? "Log In" : "Sign Up")
                        .urbanistFont(fontType: .semiBold, size: 14)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.appBlack, in: RoundedRectangle(cornerSize: CGSize(width: 4, height: 4), style: .continuous)
                )
                .padding(.horizontal, 24)
                .disabled(isButtonDisabled)
            }
        }
        .preferredColorScheme(.light)
        
    }
    
}

#Preview {
    ViewAuth()
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

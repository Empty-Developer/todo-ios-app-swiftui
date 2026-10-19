import SwiftUI
import Observation

@MainActor
@Observable
final class ViewModelAuth {
    
    var user = ModelUser(email: "", password: "")
    var authenticated = false
    var isLoading = false
    var errorMessage: String?
    
    
    var openEye: UIImage = .eye
    var closeEye: UIImage = .eyeInvisible
    var isOpen: Bool = true
    var previousCount: Int = 0

    var isSignOn: Bool = true // true = login, false = registration
    
    private let authService = AuthService()
    
    var isButtonDisabled: Bool {
        user.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || user.password.isEmpty || isLoading
    }
    
    func submit() {
        Task {
            await authenticate()
        }
    }
    
    func authenticate() async {
        guard !isButtonDisabled else {
            return
        }
        
        errorMessage = nil
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            if isSignOn {
                // login
                let response = try await authService.login(user: user)
                print("Login successful, token type:", response.token_type)
            } else {
                // registration
                let created = try await authService.register(user: user)
                print("Registered user id:", created.id, "email:", created.email)
            }
            withAnimation { authenticated = true }
        } catch {
            print("AUTH ERROR:", error)
            errorMessage = error.localizedDescription
        }
    }
    
    var isEyeCheck: UIImage {
        if isOpen == true {
            return openEye
        } else {
            return closeEye
        }
    }
    
    var pointClosePassword: Binding<String>{
        Binding<String>(
            get: {
                if self.isOpen {
                    return self.user.password
                } else {
                    return String(repeating: "·", count: self.user.password.count)
                }
            },
            set: { newValue in
                if self.isOpen {
                    self.user.password = newValue
                } else {
                    if newValue.count < self.previousCount {
                        if !self.user.password.isEmpty {
                            self.user.password.removeLast()
                        }
                    } else if newValue.count > self.previousCount {
                        if let lastChar = newValue.last {
                            self.user.password.append(lastChar)
                        }
                    }
                }
                self.previousCount = self.user.password.count
            }
        )
    }
    
}

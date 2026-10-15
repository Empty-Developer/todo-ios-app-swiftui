import SwiftUI
import Combine
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

    var isSignOn: Bool = true
    
    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    
    var isButtonDisabled: Bool {
        user.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || user.password.isEmpty || isLoading
    }
    
    func logIn() {
        guard !isButtonDisabled else {
            return
        }

        errorMessage = nil
        isLoading = true

        authService.login(user: user)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }

                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }

                    self.isLoading = false
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }

                    // check response
                    print("Login successful")
                    print("Token type:", response.token_type)

                    withAnimation {
                        self.authenticated = true
                    }
                }
            )
            .store(in: &cancellables)
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

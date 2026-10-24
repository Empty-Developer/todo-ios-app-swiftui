import SwiftUI
import Observation

@MainActor
@Observable
final class ViewModelAuth {

    var user = ModelUser(email: "", password: "")
    var authenticated = false
    var isLoading = false
    var errorMessage: String?

    var accessToken: String?

    var openEye: UIImage = .eye
    var closeEye: UIImage = .eyeInvisible
    var isOpen: Bool = true
    var previousCount: Int = 0

    var isSignOn: Bool = true

    private let authService = AuthService()

    // MARK: - Restoring the session upon startup
    init() {
        restoreSession()
    }

    private func restoreSession() {
        guard let saved = TokenStorage.load() else { return }

        if JWT.isExpired(saved) {
            TokenStorage.delete()
            return
        }

        accessToken = saved
        authenticated = true
    }

    var isButtonDisabled: Bool {
        user.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || user.password.isEmpty
        || isLoading
    }

    func submit() {
        Task { await authenticate() }
    }

    func authenticate() async {
        guard !isButtonDisabled else { return }

        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            if isSignOn {
                let response = try await authService.login(user: user)
                store(token: response.access_token)
            } else {
                let created = try await authService.register(user: user)
                print("Registered user id:", created.id, "email:", created.email)

                let response = try await authService.login(user: user)
                store(token: response.access_token)
            }

            withAnimation { authenticated = true }
        } catch {
            print("AUTH ERROR:", error)
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - save token
    private func store(token: String) {
        accessToken = token
        TokenStorage.save(token)
    }

    func logout() {
        accessToken = nil
        authenticated = false
        user.password = ""
        TokenStorage.delete()

        withAnimation { authenticated = false }
    }

    // MARK: - If the server responded with 401
    func handleUnauthorized() {
        logout()
        errorMessage = "Сессия истекла — войдите заново"
    }

    var isEyeCheck: UIImage {
        isOpen ? openEye : closeEye
    }

    var pointClosePassword: Binding<String> {
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

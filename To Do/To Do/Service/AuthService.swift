import Foundation

// MARK: Check Error from backend
enum AuthError: LocalizedError {
    case invalideResponse
    case serverError(Int)
    case emptyResponse
    
    var errorDescription: String? {
        switch self {
        case .invalideResponse:
            return "Incorect respons server!"
        case .serverError(let statusCode):
            return "Error HTTP server \(statusCode)!"
        case .emptyResponse:
            return "Server output empty respons!"
        }
    }
}

// MARK URLSession and check url
final class AuthService {
    private let baseUrl = URL(string: "http://127.0.0.1:8000")!
    
    // MARK: all check response
    private static func validate(_ response: URLResponse, _ data: Data) throws {
        guard let http = response as? HTTPURLResponse else { throw AuthError.invalideResponse }
        guard (200...299).contains(http.statusCode) else { throw AuthError.serverError(http.statusCode) }
        guard !data.isEmpty else { throw AuthError.emptyResponse }
    }
    
    func login(user: ModelUser) async throws -> ModelLoginResponse {
        
        // MARK this moment where I can select respons in server
        let url = baseUrl.appending(path: "login")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var components = URLComponents()
        
        components.queryItems = [
            URLQueryItem(name: "username", value: user.email),
            URLQueryItem(name: "password", value: user.password)
        ]
        request.httpBody = components.percentEncodedQuery?.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try Self.validate(response, data)
        return try JSONDecoder().decode(ModelLoginResponse.self, from: data)
    }
    
    func register(user: ModelUser) async throws -> ModelRegisterResponse {
        let url = baseUrl.appending(path: "users")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = try JSONEncoder().encode(user)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try Self.validate(response, data)
        return try JSONDecoder().decode(ModelRegisterResponse.self, from: data)
    }
}

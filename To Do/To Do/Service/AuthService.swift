import Combine
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
    
    func login(user: ModelUser) -> AnyPublisher<ModelLoginResponse, Error> {
        
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
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse else {
                    throw AuthError.invalideResponse
                }
                
                guard (200...299).contains(response.statusCode) else {
                    throw AuthError.serverError(response.statusCode)
                }
                
                guard !output.data.isEmpty else {
                    throw AuthError.emptyResponse
                }
                
                return output.data
            }
            .decode(type: ModelLoginResponse.self,decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

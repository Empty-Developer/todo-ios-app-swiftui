import Foundation

enum ItemError: LocalizedError {
    case invalideResponse
    case serverError(Int)
    case emptyResponse
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalideResponse:
            return "Incorect respons server!"
        case .serverError(let statusCode):
            return "Error HTTP server \(statusCode)!"
        case .emptyResponse:
            return "Server output empty respons!"
        case .unauthorized:
            return "Sessia out"
        }
    }
}

final class ItemService {
    private let baseUrl = URL(string: "http://127.0.0.1:8000")!

    private func request(path: String, method: String, token: String) -> URLRequest {
        var request = URLRequest(url: baseUrl.appending(path: path))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    @discardableResult
    private func send(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw ItemError.invalideResponse }

        print(request.httpMethod ?? "?", request.url?.path ?? "", "→", http.statusCode)
        print("BODY:", String(data: data, encoding: .utf8) ?? "nil")

        if http.statusCode == 401 { throw ItemError.unauthorized }
        guard (200...299).contains(http.statusCode) else {
            throw ItemError.serverError(http.statusCode)
        }
        return data
    }

    func fetchTodos(token: String) async throws -> [ModelTodoResponse] {
        let data = try await send(request(path: "items", method: "GET", token: token))
        guard !data.isEmpty else { throw ItemError.emptyResponse }
        return try JSONDecoder().decode(ModelItemsResponse.self, from: data).items
    }

    func createTodo(title: String, date: Date, token: String) async throws -> ModelTodoResponse? {
        var req = request(path: "items", method: "POST", token: token)
        req.httpBody = try JSONEncoder().encode(
            ModelCreateItemRequest(title: title, date: ModelTodoResponse.isoString(from: date))
        )

        let data = try await send(req)
        guard !data.isEmpty else { return nil }

        if let item = try? JSONDecoder().decode(ModelTodoResponse.self, from: data) { return item }
        if let wrapped = try? JSONDecoder().decode(ModelItemWrapped.self, from: data) { return wrapped.item }
        return nil
    }

    func updateTodo(id: Int, title: String, date: Date, isCheck: Bool, token: String) async throws -> ModelTodoResponse? {
        var req = request(path: "items/\(id)", method: "PUT", token: token)
        req.httpBody = try JSONEncoder().encode(
            ModelUpdateItemRequest(
                title: title,
                date: ModelTodoResponse.isoString(from: date),
                isCheck: isCheck
            )
        )

        let data = try await send(req)
        guard !data.isEmpty else { return nil }

        if let wrapped = try? JSONDecoder().decode(ModelUpdatedItemResponse.self, from: data) {
            return wrapped.updatedItem
        }
        if let item = try? JSONDecoder().decode(ModelTodoResponse.self, from: data) { return item }
        return nil
    }

    func patchCheck(id: Int, isCheck: Bool, token: String) async throws -> ModelTodoResponse? {
        var req = request(path: "items/\(id)", method: "PATCH", token: token)
        req.httpBody = try JSONEncoder().encode(ModelPatchCheckRequest(isCheck: isCheck))

        let data = try await send(req)
        guard !data.isEmpty else { return nil }

        if let wrapped = try? JSONDecoder().decode(ModelUpdatedItemResponse.self, from: data) {
            return wrapped.updatedItem
        }
        if let item = try? JSONDecoder().decode(ModelTodoResponse.self, from: data) { return item }
        return nil
    }

    func deleteTodo(id: Int, token: String) async throws {
        try await send(request(path: "items/\(id)", method: "DELETE", token: token))
    }
}

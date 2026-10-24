import Foundation

struct ModelTodoResponse: Identifiable, Decodable, Hashable {
    let id: Int
    var title: String
    var date: String
    var isCheck: Bool
    let createdAt: String
    let userId: Int

    enum CodingKeys: String, CodingKey {
        case id, title, date
        case isCheck   = "is_check"
        case createdAt = "created_at"
        case userId    = "user_id"
    }
}

// GET /items → {"items": [...]}
struct ModelItemsResponse: Decodable {
    let items: [ModelTodoResponse]
}

// POST /items → {...}
struct ModelItemWrapped: Decodable {
    let item: ModelTodoResponse
}

// PUT/PATCH /items/{id} → {"updated_item": {...}}
struct ModelUpdatedItemResponse: Decodable {
    let updatedItem: ModelTodoResponse

    enum CodingKeys: String, CodingKey {
        case updatedItem = "updated_item"
    }
}

struct ModelCreateItemRequest: Encodable {
    let title: String
    let date: String
}

struct ModelUpdateItemRequest: Encodable {
    let title: String
    let date: String
    let isCheck: Bool

    enum CodingKeys: String, CodingKey {
        case title, date
        case isCheck = "is_check"
    }
}

struct ModelPatchCheckRequest: Encodable {
    let isCheck: Bool

    enum CodingKeys: String, CodingKey {
        case isCheck = "is_check"
    }
}

extension ModelTodoResponse {
    /// "2026-10-08" -> Date (for sort)
    var dateValue: Date {
        ModelTodoResponse.isoFormatter.date(from: date) ?? .distantFuture
    }

    /// "2026-10-08" -> "8 oct. 2026"
    var displayDate: String {
        guard let parsed = ModelTodoResponse.isoFormatter.date(from: date) else { return date }
        let out = DateFormatter()
        out.locale = Locale(identifier: "en_US")
        out.dateFormat = "d MMM yyyy"
        return out.string(from: parsed)
    }

    static let isoFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static func isoString(from date: Date) -> String {
        isoFormatter.string(from: date)
    }
}

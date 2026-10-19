import Foundation

struct ModelRegisterResponse: Decodable {
    let id: Int
    let email: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
    }
}

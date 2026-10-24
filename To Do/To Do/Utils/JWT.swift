import Foundation

enum JWT {

    /// true — token expired (or dont read and check how expired)
    static func isExpired(_ token: String) -> Bool {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else { return false }

        var payload = String(parts[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        while payload.count % 4 != 0 {
            payload += "="
        }

        guard
            let data = Data(base64Encoded: payload),
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let exp = json["exp"] as? Double
        else {
            // exp нет — dont expired lost
            return false
        }

        return Date(timeIntervalSince1970: exp) <= Date()
    }
}

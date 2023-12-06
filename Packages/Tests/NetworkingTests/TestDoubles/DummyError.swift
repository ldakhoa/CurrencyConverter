import Foundation

struct DummyError: LocalizedError, Equatable, Codable {

    var id = UUID()

    var errorDescription: String? {
        id.uuidString
    }
}

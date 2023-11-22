import Foundation

struct DummyError: LocalizedError, Equatable {

    let id = UUID()

    var errorDescription: String? {
        id.uuidString
    }
}

import Foundation

public extension NSError {
    /// An enum declare the well-known error codes of an `NSError` object.
    enum Code: Int {
        /// The code will return if a request was cancelled.
        case cancelled = -999
    }
}

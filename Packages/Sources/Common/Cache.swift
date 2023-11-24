import Foundation

/// An object that temporarily stores transient key-value pairs that are subject to eviction when resources are low or expired.
public final class Cache<Key: Hashable, Value> {
    // MARK: Init

    public init() {}

    // MARK: Misc

    /// An object that temporarily stores transient key-value pairs that are subject to eviction when resources are low.
    private let storage = NSCache<WrappedKey, WrappedValue>()

    // MARK: Side Effects

    /// Sets the value of the specified key in the cache.
    ///
    /// If the expiration time has passed, it will not insert the new value to the cache storage.
    ///
    /// - Parameters:
    ///   - value: The value to be stored in the cache.
    ///   - key: The key with which to associate the value.
    ///   - expirationDate: A date when the value will expire.
    public func insert(
        _ value: Value,
        forKey key: Key,
        expiredAt expirationDate: Date? = nil
    ) {
        if let expirationDate, expirationDate <= Date() {
            return
        }

        let wrappedValue = WrappedValue(
            value: value,
            expirationDate: expirationDate
        )
        storage.setObject(wrappedValue, forKey: WrappedKey(key: key))
    }

    /// Returns the value associated with a given key.
    /// - Parameter key: The key with which to associate the value.
    /// - Returns: The value associated with `key`, or `nil` if no value is associated with key.
    public func value(forKey key: Key) -> Value? {
        guard let wrappedValue = storage.object(forKey: WrappedKey(key: key)) else {
            return nil
        }

        guard
            let expirationDate = wrappedValue.expirationDate,
            expirationDate < Date()
        else {
            return wrappedValue.value
        }
        removeValue(forKey: key)
        return nil
    }

    /// Removes the value of the specified key in the cache.
    /// - Parameter key: The key with which to associate the value.
    public func removeValue(forKey key: Key) {
        storage.removeObject(forKey: WrappedKey(key: key))
    }
}

extension Cache {
    // MARK: Subscript

    subscript(_ key: Key) -> Value? {
        get {
            value(forKey: key)
        } set {
            guard let value = newValue else { return removeValue(forKey: key) }
            insert(value, forKey: key)
        }
    }
}

extension Cache {
    // MARK: Subtypes

    /// An object that wraps an underlying key to satisfy `NSCache.KeyType` type constraint.
    private final class WrappedKey: NSObject {
        /// The underlying key.
        let key: Key

        /// Initiate an object that wraps an underlying key to satisfy `NSCache.KeyType` type constraint.
        /// - Parameter key: The underlying key.
        init(key: Key) {
            self.key = key
        }

        override var hash: Int {
            key.hashValue
        }

        override func isEqual(_ object: Any?) -> Bool {
            (object as? WrappedKey)?.key == key
        }
    }

    /// An object that wraps an underlying value with the expiration date.
    private final class WrappedValue {
        /// The underlying value.
        let value: Value
        /// A date when the underlying value will expire.
        let expirationDate: Date?

        /// Initate an object that wraps an underlying value with the expiration date.
        /// - Parameters:
        ///   - value: The underlying value.
        ///   - expirationDate: A date when the underlying value will expire.
        init(value: Value, expirationDate: Date? = nil) {
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}

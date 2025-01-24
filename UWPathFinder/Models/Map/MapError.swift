import Foundation

/// Errors that can occur during map operations.
/// These errors represent common failure cases when working with key-value pairs
/// in a map data structure.
enum MapError: LocalizedError {
    /// Indicates an attempt to insert a key that already exists in the map.
    /// Thrown by `put` operations to prevent duplicate keys.
    case keyAlreadyExists
    
    /// Indicates an attempt to access or remove a key that doesn't exist in the map.
    /// Thrown by `get` and `remove` operations when the key isn't found.
    case keyNotFound
    
    /// Provides human-readable descriptions for each error case.
    var errorDescription: String? {
        switch self {
        case .keyAlreadyExists:
            return "Key already exists in the map"
        case .keyNotFound:
            return "Key not found in the map"
        }
    }
}

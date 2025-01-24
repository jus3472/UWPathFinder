import Foundation

/// Protocol defining requirements for a key-value map data structure.
/// This protocol provides the basic operations expected of a map/dictionary,
/// including insertion, retrieval, and removal of key-value pairs.
///
/// Type Parameters:
/// - KeyType: The type of keys used in the map. Must be Hashable.
/// - ValueType: The type of values stored in the map.
protocol MapProtocol {
    /// The type of keys stored in the map.
    /// Must conform to Hashable to enable efficient storage and lookup.
    associatedtype KeyType: Hashable
    
    /// The type of values stored in the map.
    /// Can be any type, as values don't need special requirements.
    associatedtype ValueType
    
    /// Adds a key-value pair to the map.
    /// - Parameters:
    ///   - key: The key to insert
    ///   - value: The value to associate with the key
    /// - Throws: MapError.keyAlreadyExists if the key is already present
    func put(key: KeyType, value: ValueType) throws
    
    /// Checks if a key exists in the map.
    /// - Parameter key: The key to look for
    /// - Returns: true if the key exists, false otherwise
    func containsKey(_ key: KeyType) -> Bool
    
    /// Retrieves the value associated with a key.
    /// - Parameter key: The key to look up
    /// - Returns: The value associated with the key
    /// - Throws: MapError.keyNotFound if the key doesn't exist
    func get(_ key: KeyType) throws -> ValueType
    
    /// Removes a key-value pair from the map.
    /// - Parameter key: The key to remove
    /// - Returns: The value that was associated with the key
    /// - Throws: MapError.keyNotFound if the key doesn't exist
    func remove(_ key: KeyType) throws -> ValueType
    
    /// Removes all key-value pairs from the map.
    /// After this operation, the map will be empty.
    func clear()
    
    /// Gets the number of key-value pairs in the map.
    /// - Returns: The current number of entries in the map
    func getSize() -> Int
    
    /// Gets the current capacity of the map.
    /// - Returns: The size of the underlying storage structure
    /// Note: This is useful for implementations that need to track
    /// capacity for resizing operations.
    func getCapacity() -> Int
}

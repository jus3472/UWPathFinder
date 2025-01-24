import Foundation

/// A custom hash table implementation that conforms to MapProtocol.
/// This hash table uses an array of linked lists to store key-value pairs.
/// Collisions are handled using chaining (linked lists).
///
/// - KeyType: The type of keys stored in the hash table, must conform to `Hashable`.
/// - ValueType: The type of values stored in the hash table.
class HashTable<KeyType: Hashable, ValueType>: MapProtocol {
    
    /// A nested class representing a key-value pair in the hash table.
    private class Pair {
        let key: KeyType
        let value: ValueType
        
        init(key: KeyType, value: ValueType) {
            self.key = key
            self.value = value
        }
    }

    private var table: [[Pair]]  // Array of linked lists to store key-value pairs
    private var count: Int = 0
    private let defaultCapacity = 32

    /// Initializes the hash table with a specified capacity.
    ///
    /// - Parameter capacity: The initial capacity of the hash table.
    init(capacity: Int) {
        self.table = Array(repeating: [], count: capacity)
    }

    /// Initializes the hash table with a default capacity of 32.
    convenience init() {
        self.init(capacity: 32)
    }

    /// Adds a new key-value pair to the map.
    ///
    /// - Parameters:
    ///   - key: The key for the key-value pair.
    ///   - value: The value to be associated with the key.
    /// - Throws: MapError.keyAlreadyExists if the key is already present.
    func put(key: KeyType, value: ValueType) throws {
        guard !containsKey(key) else {
            throw MapError.keyAlreadyExists
        }
        
        if Double(count + 1) / Double(table.count) >= 0.75 {
            resize()
        }

        let index = abs(key.hashValue % table.count)
        table[index].append(Pair(key: key, value: value))
        count += 1
    }

    /// Resizes the hash table by doubling its current capacity and rehashing all key-value pairs.
    private func resize() {
        let newCapacity = table.count * 2
        var newTable: [[Pair]] = Array(repeating: [], count: newCapacity)
        
        for bucket in table {
            for pair in bucket {
                let index = abs(pair.key.hashValue % newCapacity)
                newTable[index].append(pair)
            }
        }
        table = newTable
    }

    /// Checks whether a key is present in the map.
    ///
    /// - Parameter key: The key to check.
    /// - Returns: `true` if the key is present, `false` otherwise.
    func containsKey(_ key: KeyType) -> Bool {
        let index = abs(key.hashValue % table.count)
        return table[index].contains { $0.key == key }
    }

    /// Retrieves the value associated with a key.
    ///
    /// - Parameter key: The key to look up.
    /// - Returns: The value associated with the key.
    /// - Throws: MapError.keyNotFound if the key is not present.
    func get(_ key: KeyType) throws -> ValueType {
        let index = abs(key.hashValue % table.count)
        if let pair = table[index].first(where: { $0.key == key }) {
            return pair.value
        }
        throw MapError.keyNotFound
    }

    /// Removes a key-value pair from the map.
    ///
    /// - Parameter key: The key to remove.
    /// - Returns: The value that was associated with the removed key.
    /// - Throws: MapError.keyNotFound if the key is not present.
    func remove(_ key: KeyType) throws -> ValueType {
        let index = abs(key.hashValue % table.count)
        for (i, pair) in table[index].enumerated() {
            if pair.key == key {
                table[index].remove(at: i)
                count -= 1
                return pair.value
            }
        }
        throw MapError.keyNotFound
    }

    /// Removes all key-value pairs from the map.
    func clear() {
        table = Array(repeating: [], count: table.count)
        count = 0
    }

    /// Returns the number of key-value pairs in the map.
    ///
    /// - Returns: The number of key-value pairs.
    func getSize() -> Int {
        return count
    }

    /// Returns the capacity of the map.
    ///
    /// - Returns: The current capacity.
    func getCapacity() -> Int {
        return table.count
    }
}

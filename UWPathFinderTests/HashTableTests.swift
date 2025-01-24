import XCTest
@testable import UWPathFinder

/// Tests for the HashTable implementation.
/// Verifies the basic operations of the hash table including:
/// - Insertion and retrieval
/// - Key checking
/// - Removal
/// - Clearing
/// - Size and capacity management
final class HashTableTests: XCTestCase {
    
    /// Tests basic put and get operations.
    /// Verifies:
    /// - Successful insertion of a key-value pair
    /// - Correct retrieval of the stored value
    func testPutAndGet() {
        let table = HashTable<String, Int>()
        XCTAssertNoThrow(try table.put(key: "One", value: 1))
        XCTAssertEqual(try table.get("One"), 1)
    }
    
    /// Tests the key existence check functionality.
    /// Verifies:
    /// - Key is found after insertion
    /// - containsKey correctly reports key presence
    func testContainsKey() {
        let table = HashTable<String, Int>()
        XCTAssertNoThrow(try table.put(key: "Two", value: 2))
        XCTAssertTrue(table.containsKey("Two"))
    }
    
    /// Tests the removal of key-value pairs.
    /// Verifies:
    /// - Successful removal of an existing key
    /// - Correct return of the removed value
    func testRemove() {
        let table = HashTable<String, Int>()
        XCTAssertNoThrow(try table.put(key: "Four", value: 4))
        XCTAssertEqual(try table.remove("Four"), 4)
    }
    
    /// Tests the clear operation.
    /// Verifies:
    /// - Multiple items can be added
    /// - Clear operation removes all items
    /// - Size is zero after clearing
    func testClear() {
        let table = HashTable<String, Int>()
        XCTAssertNoThrow(try table.put(key: "Five", value: 5))
        XCTAssertNoThrow(try table.put(key: "Six", value: 6))
        table.clear()
        XCTAssertEqual(table.getSize(), 0)
    }
    
    /// Tests size and capacity management.
    /// Verifies:
    /// - Size correctly reflects number of stored items
    /// - Initial capacity matches default value
    /// - Multiple insertions update size correctly
    func testGetSizeAndCapacity() {
        let table = HashTable<String, Int>()
        XCTAssertNoThrow(try table.put(key: "Seven", value: 7))
        XCTAssertNoThrow(try table.put(key: "Eight", value: 8))
        XCTAssertEqual(table.getSize(), 2)
        XCTAssertEqual(table.getCapacity(), 32)  // Default capacity
    }
}

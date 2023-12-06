import org.junit.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * The HashTableMapTester class contains JUnit test cases for validating the functionality
 * of the HashTableMap class. It includes tests for putting key-value pairs, checking if
 * a key is present, removing key-value pairs, clearing all entries, and getting the size
 * and capacity of the HashTableMap.
 */
public class HashTableMapTester {
    
    // Test case for putting a key-value pair and then getting the value
    @Test
    public void testPutAndGet() {
        HashTableMap<String, Integer> map = new HashTableMap<>();
        map.put("One", 1);
        assertEquals(1, map.get("One"));
    }

    // Test case for checking if a key is present in the HashtableMap
    @Test
    public void testContainsKey() {
        HashTableMap<String, Integer> map = new HashTableMap<>();
        map.put("Two", 2);
        assertTrue(map.containsKey("Two"));
    }

    // Test case for removing a key-value pair from the HashtableMap
    @Test
    public void testRemove() {
        HashTableMap<String, Integer> map = new HashTableMap<>();
        map.put("Four", 4);
        int removedValue = map.remove("Four");
        assertEquals(4, removedValue);
    }

    // Test case for clearing all key-value pairs from the HashtableMap
    @Test
    public void testClear() {
        HashTableMap<String, Integer> map = new HashTableMap<>();
        map.put("Five", 5);
        map.put("Six", 6);
        map.clear();
        assertEquals(0, map.getSize());
    }

    // Test case for getting the size and capacity of the HashtableMap
    @Test
    public void testGetSizeAndCapacity() {
        HashTableMap<String, Integer> map = new HashTableMap<>();
        map.put("Seven", 7);
        map.put("Eight", 8);
        assertEquals(2, map.getSize());
        assertEquals(32, map.getCapacity()); // Default capacity
    }

}
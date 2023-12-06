import java.util.LinkedList;
import java.util.NoSuchElementException;

/**
 * The HashTableMap class implements the MapADT interface to create a custom hash map
 * without using the java.util.HashMap data structure. It uses an array with linked lists
 * inside to store key-value pairs. The index for each pair is determined by a hash function,
 * and collisions are handled by using linked lists. The location of a pair inside the linked
 * list doesn't affect the functionality.
 *
 * @param <KeyType>   The type of keys stored in the hash map.
 * @param <ValueType> The type of values stored in the hash map.
 */
public class HashTableMap<KeyType, ValueType> implements MapADT<KeyType, ValueType> {
    
    @SuppressWarnings("unchecked")
    // table is an array of linkedlists that store Pair objects.
    protected LinkedList<Pair>[] table = (LinkedList<Pair>[]) new LinkedList<?>[DEFAULT_CAPACITY];
    private static final int DEFAULT_CAPACITY = 32;

    // Inner Pair class that just stores one specific key,value pair
    protected class Pair {
        public KeyType key;
        public ValueType value;

        public Pair(KeyType key, ValueType value) {
            this.key = key;
            this.value = value;
        }
    }
    
    // Constructors for main class
    @SuppressWarnings("unchecked")
    public HashTableMap(int capacity) {
        // Initialize the table array with the specified capacity
        table = (LinkedList<Pair>[]) new LinkedList<?>[capacity];
        // Initialize each element of the table array with a new LinkedList<Pair>
        for (int i = 0; i < capacity; i++) {
            table[i] = new LinkedList<>();
        }
    }
    public HashTableMap() { // with default capacity = 32
        for (int i = 0; i < DEFAULT_CAPACITY; i++) {
            table[i] = new LinkedList<>();
        }
    }
    

    /**
     * Adds a new key-value pair to the hash map.
     * Resizes the array if the load factor is greater than or equal to 0.75.
     *
     * @param key   The key of the key-value pair.
     * @param value The value that the key maps to.
     * @throws IllegalArgumentException If the key is already present in the hash map.
     */
    @Override
    public void put(KeyType key, ValueType value) throws IllegalArgumentException {
        if (key == null) {
            throw new NullPointerException("key is null");
        }
        if (containsKey(key)) {
            throw new IllegalArgumentException("key is already in hashtable");
        }
        // The reason we do +1 is to see if it violates the size if we were to add another pair. If it does, do resizeHelper()
        double loadFactor = getSize() + 1;
        if (loadFactor >= (.75 * getCapacity())) {
            resizeHelper();
        }

        int index = Math.abs(key.hashCode() % getCapacity());
        Pair pair = new Pair(key, value);
        table[index].add(pair);
    }

    /**
     * Helper method to resize the array by doubling its current capacity.
     * Rehashes and redistributes existing elements into the new array.
     */
    @SuppressWarnings("unchecked")
    public void resizeHelper() {
        // Resize array by doubling current capacity
        int newCapacity = getCapacity() * 2;
        LinkedList<Pair>[] newTable = (LinkedList<Pair>[]) new LinkedList<?>[newCapacity];
        for (int i = 0; i < newCapacity; i++) {
            newTable[i] = new LinkedList<>();
        }
        // After creating newTable, put old elements into newTable by rehashing
        // Outer loop goes through each linkedlist in table
        // Inner loop goes through every pair inside one linkedlist
        for (int i = 0; i < getCapacity(); i++) {
            for (int j = 0; j < table[i].size(); j++) {
                int index = Math.abs(table[i].get(j).key.hashCode() % newCapacity);
                Pair pair = new Pair(table[i].get(j).key, table[i].get(j).value);
                newTable[index].add(pair);
            }
        }
        table = newTable;
    }

    /**
     * Checks whether a key is present in the hash map.
     *
     * @param key The key to check for.
     * @return True if the key is present, false otherwise.
     */
    @Override
    public boolean containsKey(KeyType key) {
        if (key == null) {
            return false;
        }
        for (int i = 0; i < getCapacity(); i++) {
            for (int j = 0; j < table[i].size(); j++) {
                if (table[i].get(j).key.equals(key)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Returns the value that the key is mapped onto.
     *
     * @param key The key to look up.
     * @return The value that the key maps to.
     * @throws NoSuchElementException If the key is not present in the hash map.
     */
    @Override
    public ValueType get(KeyType key) throws NoSuchElementException {
        if (key == null) {
            throw new NoSuchElementException("key cannot be null");
        }
        for (int i = 0; i < getCapacity(); i++) {
            for (int j = 0; j < table[i].size(); j++) {
                if (table[i].get(j).key.equals(key)) {
                    return table[i].get(j).value;
                }
            }
        }
        throw new NoSuchElementException("key is not in the table");
    }

    /**
     * Removes the mapping for a key from the hash map.
     * Returns the value that the removed key mapped onto.
     *
     * @param key The key to remove.
     * @return The value that the removed key mapped to.
     * @throws NoSuchElementException If the key is not present in the hash map.
     */
    @Override
    public ValueType remove(KeyType key) throws NoSuchElementException {
        if (key == null) {
            throw new NoSuchElementException("key cannot be null");
        }
        for (int i = 0; i < getCapacity(); i++) {
            for (int j = 0; j < table[i].size(); j++) {
                if (table[i].get(j).key.equals(key)) {
                    Pair removedPair = table[i].remove(j);
                    return removedPair.value;
                }
            }
        }
        throw new NoSuchElementException("key is not in the table");
    }

    /**
     * Removes all key-value pairs from the hash map.
     */
    @Override
    public void clear() {
        for (int i = 0; i < getCapacity(); i++) {
            table[i].clear();
        }
    }

    /**
     * Retrieves the number of keys stored in the hash map.
     *
     * @return The number of keys stored in the hash map.
     */
    @Override
    public int getSize() {
        int size = 0;
        for (int i = 0; i < getCapacity(); i++) {
            size += table[i].size();
        }
        return size;
    }

    /**
     * Retrieves the hash map's capacity or the array length.
     *
     * @return The capacity or the array length of the hash map.
     */
    @Override
    public int getCapacity() {
        return table.length;
    }

}
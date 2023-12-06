import static org.junit.Assert.*;
import org.junit.Test;
import java.io.FileNotFoundException;

// 5 JUnit Tests that just test backend
public class BackendTester {

    // Test reading data from a valid file
    @Test
    public void testReadDataFromValidFile() {
        GraphADT<String, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        Backend backend = new Backend(graph);
        try {
            backend.readDataFromFile("campus.dot");
        } catch (FileNotFoundException e) {
            fail("FileNotFoundException should not be thrown: " + e.getMessage());
        }
    }

    // Test reading data from an invalid file
    @Test
    public void testReadDataFromFileWithInvalidFile() {
        GraphADT<String, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        Backend backend = new Backend(graph);
        try {
            backend.readDataFromFile("invalid_data.dot");
            fail("FileNotFoundException should be thrown");
        } catch (FileNotFoundException ignored) {
            // Ignoring exception as it is expected
        }
    }

    // Test reading data from an empty file
    @Test
    public void testReadDataFromFileWithEmptyFile() {
        GraphADT<String, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        Backend backend = new Backend(graph);
        try {
            backend.readDataFromFile("");
            fail("Exception should be thrown");
        } catch (Exception ignored) {
            // Ignoring exception as it is expected
        }
    }

    // Test getting the shortest path between two locations
    @Test
    public void testGetShortestPath() {
        GraphADT<String, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        Backend backend = new Backend(graph);
        try {
            backend.readDataFromFile("campus.dot");
        } catch (FileNotFoundException e) {
            fail("FileNotFoundException should not be thrown: " + e.getMessage());
        }
        // Check that the result is not null
        ShortestPathResultInterface result = backend.getShortestPath("Memorial Union",
                "Science Hall");
        assertNotNull(result);
    }

    // Test getting statistics from the dataset
    @Test
    public void testGetDatasetStats() {
        GraphADT<String, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        Backend backend = new Backend(graph);
        // Check that the statistics string is not null and contains relevant
        // information
        String stats = backend.getDatasetStats();
        // Expects 0 nodes inserted because we haven't inserted any nodes yet
        assertNotNull(stats);
        assertTrue(stats.contains("Nodes"));
        assertTrue(stats.contains("Edges"));
        assertTrue(stats.contains("Walking Time"));
    }

}
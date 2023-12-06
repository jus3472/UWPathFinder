import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Arrays;
import java.util.List;

// 3 JUnit tests that just test DijkstraGraph's methods
public class DijkstraGraphTester {

    // Test shortestPathData() and shortestPathCost() with an example graph
    @Test
    public void testShortestPathExample() {
        DijkstraGraph<Integer, Double> graph = createExampleGraph();
        List<Integer> path = graph.shortestPathData(1, 3);
        double cost = graph.shortestPathCost(1, 3);

        // Verify the results match the expected
        List<Integer> expectedPath = Arrays.asList(1, 2, 3);
        double expectedCost = 5.0;
        assertEquals(expectedPath, path);
        assertEquals(expectedCost, cost, 0.0001);
    }

    // Test shortestPathData() and shortestPathCost() with different start and end
    // nodes
    @Test
    public void testDifferentStartEndNodes() {
        DijkstraGraph<Integer, Double> graph = createExampleGraph();
        List<Integer> path = graph.shortestPathData(2, 3);
        double cost = graph.shortestPathCost(2, 3);

        // Verify the results match the expected
        List<Integer> expectedPath = Arrays.asList(2, 3);
        double expectedCost = 3.0;
        assertEquals(expectedPath, path);
        assertEquals(expectedCost, cost, 0.0001);
    }

    // Test shortestPathData() and shortestPathCost() when there is no path between
    // nodes
    @Test
    public void testNoPathBetweenNodes() {
        DijkstraGraph<Integer, Double> graph = createDisconnectedGraph();
        List<Integer> path = null;
        double cost = Double.NaN;

        // Attempt to find a path between two nodes
        try {
            path = graph.shortestPathData(1, 3);
            cost = graph.shortestPathCost(1, 3);
            fail("Exception should have been thrown.");
        } catch (Exception e) {
            // Exception caught as expected
        }
        // Verify the result indicates no path found
        assertNull(path);
        assertTrue(Double.isNaN(cost));
    }

    // Helper method to create a connected DijkstraGraph
    private DijkstraGraph<Integer, Double> createExampleGraph() {
        DijkstraGraph<Integer, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        graph.insertNode(1);
        graph.insertNode(2);
        graph.insertNode(3);
        graph.insertEdge(1, 2, 2.0);
        graph.insertEdge(2, 3, 3.0);
        graph.insertEdge(1, 3, 6.0);
        return graph;
    }

    // Helper method to create a disconnected DijkstraGraph
    private DijkstraGraph<Integer, Double> createDisconnectedGraph() {
        DijkstraGraph<Integer, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        graph.insertNode(1);
        graph.insertNode(2);
        graph.insertNode(3);
        // Don't add connecting edges to create a disconnected graph
        return graph;
    }

}
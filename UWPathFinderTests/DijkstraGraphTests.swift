import XCTest
@testable import UWPathFinder

/// Tests for DijkstraGraph implementation.
/// Verifies the correct implementation of Dijkstra's shortest path algorithm
/// using both connected and disconnected test graphs.
final class DijkstraGraphTests: XCTestCase {
    
    /// Tests shortest path calculation in a simple connected graph.
    func testShortestPathExample() {
        let graph = createExampleGraph()
        
        do {
            let path = try graph.shortestPathData(from: 1, to: 3)
            let cost = try graph.shortestPathCost(from: 1, to: 3)
            
            XCTAssertEqual(path, [1, 2, 3])
            XCTAssertEqual(cost, 5.0, accuracy: 0.0001)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    /// Tests shortest path between non-start nodes.
    /// Using same graph as testShortestPathExample, but finds path from node 2 to 3.
    /// Expected path: 2 -> 3 (cost: 3.0)
    func testDifferentStartEndNodes() {
        let graph = createExampleGraph()
        
        do {
            let path = try graph.shortestPathData(from: 2, to: 3)
            let cost = try graph.shortestPathCost(from: 2, to: 3)
            
            XCTAssertEqual(path, [2, 3])
            XCTAssertEqual(cost, 3.0, accuracy: 0.0001)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    /// Tests error handling when no path exists between nodes.
    /// Uses a graph with nodes but no edges between them.
    /// Should throw appropriate errors when path finding is attempted.
    func testNoPathBetweenNodes() {
        let graph = createDisconnectedGraph()
        
        XCTAssertThrowsError(try graph.shortestPathData(from: 1, to: 3))
        XCTAssertThrowsError(try graph.shortestPathCost(from: 1, to: 3))
    }
    
    // MARK: - Helper Methods
    
    /// Creates a test graph with three nodes and edges forming a triangle.
    private func createExampleGraph() -> DijkstraGraph<Int, Double> {
        let graph = DijkstraGraph<Int, Double>()
        
        // Insert nodes and handle results
        XCTAssertNoThrow(try graph.insertNode(1))
        XCTAssertNoThrow(try graph.insertNode(2))
        XCTAssertNoThrow(try graph.insertNode(3))
        
        // Insert edges to create a triangle with known shortest paths
        XCTAssertTrue(graph.insertEdge(from: 1, to: 2, weight: 2.0))
        XCTAssertTrue(graph.insertEdge(from: 2, to: 3, weight: 3.0))
        XCTAssertTrue(graph.insertEdge(from: 1, to: 3, weight: 6.0))
        
        return graph
    }
    
    /// Creates a test graph with three disconnected nodes (no edges).
    /// Used to test error handling when no path exists.
    private func createDisconnectedGraph() -> DijkstraGraph<Int, Double> {
        let graph = DijkstraGraph<Int, Double>()
        
        // Insert nodes but no edges
        XCTAssertNoThrow(try graph.insertNode(1))
        XCTAssertNoThrow(try graph.insertNode(2))
        XCTAssertNoThrow(try graph.insertNode(3))
        
        return graph
    }
}

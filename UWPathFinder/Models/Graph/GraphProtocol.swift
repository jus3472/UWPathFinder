import Foundation

/// Protocol defining the requirements for a directed graph with weighted edges.
/// The graph supports basic operations like adding/removing nodes and edges,
/// as well as finding shortest paths between nodes.
protocol GraphProtocol {
    /// The type of data stored in each node. Must be Hashable for dictionary storage.
    associatedtype NodeType: Hashable
    
    /// The type of weight stored on each edge. Must be Numeric for path calculations.
    associatedtype EdgeType: Numeric & Comparable
    
    // MARK: - Node Operations
    
    /// Adds a new node to the graph.
    /// - Parameter data: The data to store in the new node
    /// - Returns: true if node was added, false if it already existed
    func insertNode(_ data: NodeType) throws -> Bool
    
    /// Removes a node and all its edges from the graph.
    /// - Parameter data: The data of the node to remove
    /// - Returns: true if node was removed, false if it wasn't found
    func removeNode(_ data: NodeType) throws -> Bool
    
    /// Checks if a node exists in the graph.
    func containsNode(_ data: NodeType) -> Bool
    
    /// Gets the total number of nodes in the graph.
    func getNodeCount() -> Int
    
    // MARK: - Edge Operations
    
    /// Adds or updates an edge between two nodes.
    /// - Parameters:
    ///   - pred: The predecessor node
    ///   - succ: The successor node
    ///   - weight: The edge weight/cost
    /// - Returns: true if edge was added/updated successfully
    func insertEdge(from pred: NodeType, to succ: NodeType, weight: EdgeType) -> Bool
    
    /// Removes an edge between two nodes.
    /// - Returns: true if edge was removed, false if it didn't exist
    func removeEdge(from pred: NodeType, to succ: NodeType) -> Bool
    
    // Checks if an edge exists between two nodes.
    func containsEdge(from pred: NodeType, to succ: NodeType) -> Bool
    
    /// Gets the weight of an edge between two nodes.
    /// - Throws: GraphError if edge doesn't exist
    func getEdge(from pred: NodeType, to succ: NodeType) throws -> EdgeType
    
    /// Gets the total number of edges in the graph.
    func getEdgeCount() -> Int
    
    // MARK: - Path Finding Operations
    
    /// Finds the sequence of nodes in the shortest path between two points.
    /// - Throws: GraphError if path doesn't exist
    func shortestPathData(from start: NodeType, to end: NodeType) throws -> [NodeType]
    
    /// Gets the individual walking times between consecutive nodes in the shortest path.
    /// - Throws: GraphError if path doesn't exist
    func shortestPathWalkingTimes(from start: NodeType, to end: NodeType) throws -> [Double]
    
    /// Gets the total cost of the shortest path between two nodes.
    /// - Throws: GraphError if path doesn't exist
    func shortestPathCost(from start: NodeType, to end: NodeType) throws -> Double
}

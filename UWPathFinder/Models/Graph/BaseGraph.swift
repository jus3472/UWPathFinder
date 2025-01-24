import Foundation

/// Base implementation of a directed graph with weighted edges.
/// Provides common graph operations but leaves path-finding to subclasses.
open class BaseGraph<NodeType: Hashable, EdgeType: Numeric & Comparable> {
    
    /// Represents a node in the graph, storing data and edge connections.
    public class Node {
        var data: NodeType
        var edgesLeaving: [Edge] = []   // Edges where this node is the predecessor
        var edgesEntering: [Edge] = []  // Edges where this node is the successor
        
        init(data: NodeType) {
            self.data = data
        }
    }
    
    /// Represents a weighted edge between two nodes.
    /// Uses weak references to nodes to avoid retain cycles.
    public class Edge {
        var data: EdgeType
        weak var predecessor: Node?
        weak var successor: Node?
        
        init(data: EdgeType, predecessor: Node, successor: Node) {
            self.data = data
            self.predecessor = predecessor
            self.successor = successor
        }
    }
    
    /// Maps node data to Node objects for quick lookup.
    public var nodes: [NodeType: Node] = [:]
    
    /// Total number of edges in the graph.
    private(set) public var edgeCount = 0
    
    public func insertNode(_ data: NodeType) throws -> Bool {
        guard nodes[data] == nil else { return false }
        nodes[data] = Node(data: data)
        return true
    }
    
    public func removeNode(_ data: NodeType) throws -> Bool {
        guard let node = nodes.removeValue(forKey: data) else { return false }
        for edge in node.edgesLeaving {
            edge.successor?.edgesEntering.removeAll { $0 === edge }
        }
        for edge in node.edgesEntering {
            edge.predecessor?.edgesLeaving.removeAll { $0 === edge }
        }
        return true
    }
    
    public func containsNode(_ data: NodeType) -> Bool {
        return nodes[data] != nil
    }
    
    public func getNodeCount() -> Int {
        return nodes.count
    }
    
    public func insertEdge(from pred: NodeType, to succ: NodeType, weight: EdgeType) -> Bool {
        guard let predNode = nodes[pred], let succNode = nodes[succ] else { return false }
        
        if let existingEdge = getEdgeHelper(pred: pred, succ: succ) {
            existingEdge.data = weight
        } else {
            let newEdge = Edge(data: weight, predecessor: predNode, successor: succNode)
            edgeCount += 1
            predNode.edgesLeaving.append(newEdge)
            succNode.edgesEntering.append(newEdge)
        }
        return true
    }
    
    public func removeEdge(from pred: NodeType, to succ: NodeType) -> Bool {
        guard let edge = getEdgeHelper(pred: pred, succ: succ) else { return false }
        
        edge.predecessor?.edgesLeaving.removeAll { $0 === edge }
        edge.successor?.edgesEntering.removeAll { $0 === edge }
        edgeCount -= 1
        return true
    }
    
    public func containsEdge(from pred: NodeType, to succ: NodeType) -> Bool {
        return getEdgeHelper(pred: pred, succ: succ) != nil
    }
    
    public func getEdge(from pred: NodeType, to succ: NodeType) throws -> EdgeType {
        guard let edge = getEdgeHelper(pred: pred, succ: succ) else {
            throw GraphError.edgeNotFound(pred, succ)
        }
        return edge.data
    }
    
    public func getEdgeCount() -> Int {
        return edgeCount
    }
    
    internal func getEdgeHelper(pred: NodeType, succ: NodeType) -> Edge? {
        guard let predNode = nodes[pred] else { return nil }
        return predNode.edgesLeaving.first { $0.successor?.data == succ }
    }
}

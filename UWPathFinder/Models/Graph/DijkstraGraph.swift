import Foundation
import SwiftPriorityQueue

/// Implementation of Dijkstra's shortest path algorithm.
/// Uses a priority queue to efficiently find shortest paths between nodes.
class DijkstraGraph<NodeType: Hashable, EdgeType: Numeric & Comparable>: BaseGraph<NodeType, EdgeType>, GraphProtocol {
    
    /// Internal class for tracking nodes during path finding.
    /// Implements Comparable to work with priority queue.
    private class SearchNode: Comparable {
        let node: Node
        let cost: Double
        let predecessor: SearchNode?
        
        init(node: Node, cost: Double, predecessor: SearchNode?) {
            self.node = node
            self.cost = cost
            self.predecessor = predecessor
        }
        
        /// Compare nodes by cost (lower cost = higher priority).
        static func < (lhs: SearchNode, rhs: SearchNode) -> Bool {
            return lhs.cost < rhs.cost
        }
        
        /// Nodes are equal if they have same cost and represent same node.
        static func == (lhs: SearchNode, rhs: SearchNode) -> Bool {
            return lhs.cost == rhs.cost && lhs.node.data == rhs.node.data
        }
    }
    
    /// Finds shortest path between two nodes using Dijkstra's algorithm.
    /// - Parameters:
    ///   - start: Starting node data
    ///   - end: Ending node data
    /// - Returns: Array of nodes representing shortest path
    /// - Throws: GraphError if nodes don't exist or no path exists
    func shortestPathData(from start: NodeType, to end: NodeType) throws -> [NodeType] {
        guard let startNode = nodes[start] else {
            throw GraphError.nodeNotFound("\(start)")
        }
        guard nodes[end] != nil else {
            throw GraphError.nodeNotFound("\(end)")
        }
        
        var visited = Set<NodeType>()
        var pq = PriorityQueue<SearchNode>(ascending: true)
        pq.push(SearchNode(node: startNode, cost: 0.0, predecessor: nil))
        
        while let current = pq.pop() {
            let currentNodeVal = current.node.data
            
            if visited.contains(currentNodeVal) { continue }
            visited.insert(currentNodeVal)
            
            if currentNodeVal == end {
                var path: [NodeType] = []
                var currentNode: SearchNode? = current
                while let node = currentNode {
                    path.insert(node.node.data, at: 0)
                    currentNode = node.predecessor
                }
                return path
            }
            
            for edge in current.node.edgesLeaving {
                guard let neighbor = edge.successor else { continue }
                let neighborVal = neighbor.data
                
                if visited.contains(neighborVal) { continue }
                
                let newCost = current.cost + (edge.data as! Double)
                let newNode = SearchNode(node: neighbor, cost: newCost, predecessor: current)
                pq.push(newNode)
            }
        }
        
        throw GraphError.noPathExists(start, end)
    }
    
    /// Calculates total cost of shortest path between two nodes.
    func shortestPathCost(from start: NodeType, to end: NodeType) throws -> Double {
        let path = try shortestPathData(from: start, to: end)
        var total = 0.0
        for i in 0..<(path.count - 1) {
            let weight = try getEdge(from: path[i], to: path[i+1])
            total += Double("\(weight)")!
        }
        return total
    }
    
    /// Gets individual segment costs along shortest path.
    func shortestPathWalkingTimes(from start: NodeType, to end: NodeType) throws -> [Double] {
        let path = try shortestPathData(from: start, to: end)
        var segments = [Double]()
        for i in 0..<(path.count - 1) {
            let weight = try getEdge(from: path[i], to: path[i+1])
            segments.append(Double("\(weight)")!)
        }
        return segments
    }
}

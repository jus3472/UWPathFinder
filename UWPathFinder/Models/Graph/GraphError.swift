import Foundation

/// Errors that can occur during graph operations.
enum GraphError: LocalizedError {
    /// Indicates that a requested node was not found in the graph.
    case nodeNotFound(String)
    
    /// Indicates that no edge exists between the specified nodes.
    case edgeNotFound(Any, Any)
    
    /// Indicates that no path exists between the specified nodes.
    case noPathExists(Any, Any)
    
    var errorDescription: String? {
        switch self {
        case .nodeNotFound(let node):
            return "Node not found: \(node)"
        case .edgeNotFound(let from, let to):
            return "No edge found between \(from) and \(to)"
        case .noPathExists(let from, let to):
            return "No path exists between \(from) and \(to)"
        }
    }
}

import Foundation

/// Protocol defining the core operations for managing campus path data.
/// This protocol provides the contract for loading data, finding shortest paths,
/// and retrieving statistics about the campus graph.
protocol BackendProtocol {
    /// Reads and processes graph data from a DOT file.
    ///
    /// - Parameter filePath: The path to the DOT file containing campus building and path data.
    /// - Throws: An error if the file is not found or cannot be read.
    func readDataFromFile(filePath: String) throws
    
    /// Finds the shortest path between two campus buildings.
    ///
    /// - Parameters:
    ///   - initialBuilding: The name of the starting building.
    ///   - finalBuilding: The name of the destination building.
    /// - Returns: A ShortestPathResult containing path details, or nil if no path exists.
    /// - Throws: An error if there is an issue calculating the path.
    func getShortestPath(from initialBuilding: String, to finalBuilding: String) throws -> ShortestPathResult?
    
    /// Retrieves statistics about the loaded campus data.
    ///
    /// - Returns: A formatted string containing:
    ///   - Number of buildings (nodes)
    ///   - Number of paths (edges)
    ///   - Total walking time across all paths
    func getDatasetStats() -> String
}

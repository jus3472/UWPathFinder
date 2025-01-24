import Foundation

/// Concrete implementation of ShortestPathResultProtocol that stores and provides
/// access to the results of a shortest path calculation between two buildings.
struct ShortestPathResult: ShortestPathResultProtocol {
    /// The ordered sequence of buildings in the path.
    /// Stored privately to ensure immutability.
    private let path: [String]
    
    /// The walking times between consecutive buildings.
    /// Stored privately to ensure immutability.
    private let walkTimes: [Double]
    
    /// The total walking time for the entire path.
    /// Stored privately to ensure immutability.
    private let totalCost: Double
    
    /// Initializes a new shortest path result.
    /// - Parameters:
    ///   - path: Array of building names in order from start to destination
    ///   - walkTimes: Array of walking times between consecutive buildings
    ///   - totalCost: Total walking time for the entire path
    /// Note: The walkTimes array should have exactly one less element than the path array.
    init(path: [String], walkTimes: [Double], totalCost: Double) {
        self.path = path
        self.walkTimes = walkTimes
        self.totalCost = totalCost
    }
    
    /// Gets the sequence of buildings in the path.
    /// - Returns: Array of building names from start to destination.
    func getPath() -> [String] { path }
    
    /// Gets the walking times between consecutive buildings.
    /// - Returns: Array of walking times in seconds.
    func getWalkTimes() -> [Double] { walkTimes }
    
    /// Gets the total walking time for the path.
    /// - Returns: Total time in seconds.
    func getTotalPathCost() -> Double { totalCost }
}

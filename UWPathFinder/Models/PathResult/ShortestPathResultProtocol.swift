import Foundation

/// Protocol defining the requirements for representing the result of a shortest path calculation.
/// This protocol provides methods to access:
/// - The sequence of buildings in the path
/// - Walking times between consecutive buildings
/// - Total walking time for the entire path
protocol ShortestPathResultProtocol {
    /// Retrieves the sequence of buildings in the shortest path.
    /// - Returns: An array of building names in order from start to destination.
    ///           The first element is the starting building and the last is the destination.
    func getPath() -> [String]
    
    /// Retrieves the walking times between consecutive buildings.
    /// - Returns: An array of walking times where each element represents
    ///           the time in seconds to walk between the corresponding buildings in the path.
    ///           The size of this array is always one less than the path array.
    func getWalkTimes() -> [Double]
    
    /// Retrieves the total walking time for the entire path.
    /// - Returns: The total time in seconds to walk from the start to the destination building.
    ///           This should equal the sum of all walking times.
    func getTotalPathCost() -> Double
}

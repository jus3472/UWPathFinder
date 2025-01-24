import Foundation
import Combine

/// View model responsible for managing campus path data and calculations.
/// Uses a generic graph implementation conforming to GraphProtocol for:
/// - Loading and parsing the campus DOT file
/// - Finding shortest paths between buildings
/// - Calculating campus statistics
class PathFinderViewModel<G: GraphProtocol>: ObservableObject where G.NodeType == String, G.EdgeType == Double {
    // MARK: - Published Properties
    
    /// Indicates whether campus data has been successfully loaded
    @Published private(set) var isFileLoaded = false
    
    /// Current statistics about the loaded dataset
    @Published private(set) var datasetStats = ""
    
    /// Most recent error encountered during operations
    @Published private(set) var lastError: Error?
    
    // MARK: - Private Properties
    
    /// The underlying graph data structure
    private var graph: G
    
    /// Cached total walking time from DOT file
    private var totalWalkingTimeFromDotFile: Double = 0.0
    
    // MARK: - Initialization
    
    /// Initializes the view model with a graph implementation.
    ///
    /// - Parameter graph: The graph data structure to use for path calculations.
    init(graph: G) {
        self.graph = graph
    }
    
    // MARK: - Public Methods
    
    /// Reads and processes the campus.dot file.
    ///
    /// - Parameter filePath: Must be exactly "campus.dot".
    /// - Throws: Error if file is not found or cannot be processed.
    func readDataFromFile(filePath: String) throws {
        guard filePath == "campus.dot" else {
            throw NSError(domain: "PathFinderError",
                         code: 404,
                         userInfo: [NSLocalizedDescriptionKey: "File must be 'campus.dot'"])
        }
        
        guard let dotURL = Bundle.main.url(forResource: "campus", withExtension: "dot") else {
            throw NSError(domain: "PathFinderError",
                         code: 404,
                         userInfo: [NSLocalizedDescriptionKey: "Could not locate 'campus.dot' in the app bundle."])
        }
        
        let fileContents = try String(contentsOf: dotURL, encoding: .utf8)
        processFileContents(fileContents)
        isFileLoaded = true
        datasetStats = getDatasetStats()
    }
    
    /// Finds the shortest path between two buildings.
    ///
    /// - Parameters:
    ///   - start: Name of the starting building
    ///   - end: Name of the destination building
    /// - Returns: ShortestPathResult containing path details, or nil if no path exists
    /// - Throws: Error if path calculation fails
    func getShortestPath(from start: String, to end: String) throws -> ShortestPathResult? {
        do {
            let pathData = try graph.shortestPathData(from: start, to: end)
            let walkingTimes = try graph.shortestPathWalkingTimes(from: start, to: end)
            let pathCost = try graph.shortestPathCost(from: start, to: end)
            
            return ShortestPathResult(
                path: pathData,
                walkTimes: walkingTimes,
                totalCost: pathCost
            )
        } catch {
            print("Error finding shortest path: \(error)")
            return nil
        }
    }
    
    /// Retrieves current statistics about the loaded campus data.
    ///
    /// - Returns: Formatted string containing node count, edge count, and total walking time.
    func getDatasetStats() -> String {
        let numNodes = graph.getNodeCount()
        let numEdges = graph.getEdgeCount()
        
        return """
        Number of Buildings (Nodes): \(numNodes)
        Number of Paths (Edges): \(numEdges)
        Total Walking Time: \(String(format: "%.2f", totalWalkingTimeFromDotFile)) seconds
        """
    }
    
    // MARK: - Private Methods
    
    /// Processes the contents of the DOT file.
    ///
    /// - Parameter contents: Raw string contents of the DOT file
    private func processFileContents(_ contents: String) {
        let lines = contents.split(separator: "\n")
        for line in lines where line.contains("--") {
            processEdge(String(line))
        }
        calculateTotalWalkingTime(from: contents)
    }
    
    /// Processes a single edge line from the DOT file.
    /// Format: "Building A" -- "Building B" [seconds=123.4];
    ///
    /// - Parameter edgeLine: Single line containing edge information
    private func processEdge(_ edgeLine: String) {
        let parts = edgeLine.split(separator: "--", maxSplits: 1, omittingEmptySubsequences: true)
        guard parts.count == 2 else { return }
        
        let building1 = parts[0]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\"", with: "")
        
        let building2AndData = parts[1]
            .split(separator: "[", maxSplits: 1, omittingEmptySubsequences: true)
        guard building2AndData.count == 2 else { return }
        
        let building2 = building2AndData[0]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\"", with: "")
        
        let secondsString = building2AndData[1]
            .components(separatedBy: "=")[1]
            .replacingOccurrences(of: "[^\\d.]", with: "", options: .regularExpression)
        
        guard let seconds = Double(secondsString) else { return }
        
        _ = try? graph.insertNode(building1)
        _ = try? graph.insertNode(building2)
        _ = graph.insertEdge(from: building1, to: building2, weight: seconds)
        _ = graph.insertEdge(from: building2, to: building1, weight: seconds)
    }
    
    /// Calculates total walking time by summing all edge weights.
    /// Uses regex to extract and sum seconds values from the DOT file.
    ///
    /// - Parameter contents: Raw string contents of the DOT file
    private func calculateTotalWalkingTime(from contents: String) {
        let pattern = #""[^"]+" -- "[^"]+" \[seconds=([\d.]+)\];"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            totalWalkingTimeFromDotFile = 0.0
            return
        }
        
        let fullText = contents as NSString
        let matches = regex.matches(in: contents, range: NSRange(location: 0, length: fullText.length))
        
        totalWalkingTimeFromDotFile = matches.reduce(0.0) { total, match in
            let captureRange = match.range(at: 1)
            if captureRange.location != NSNotFound,
               let val = Double(fullText.substring(with: captureRange)) {
                return total + val
            }
            return total
        }
    }
}

import XCTest
@testable import UWPathFinder

/// Tests for the PathFinderViewModel class.
/// Verifies the core functionality of campus data management:
/// - File loading
/// - Path finding
/// - Statistics calculation
final class PathFinderViewModelTests: XCTestCase {
    
    /// Tests that valid campus.dot file can be loaded successfully.
    func testReadDataFromValidFile() {
        let graph = DijkstraGraph<String, Double>()
        let viewModel = PathFinderViewModel(graph: graph)
        
        XCTAssertNoThrow(try viewModel.readDataFromFile(filePath: "campus.dot"))
    }
    
    /// Tests that loading an invalid file throws an error.
    func testReadDataFromFileWithInvalidFile() {
        let graph = DijkstraGraph<String, Double>()
        let viewModel = PathFinderViewModel(graph: graph)
        
        XCTAssertThrowsError(try viewModel.readDataFromFile(filePath: "invalid_data.dot"))
    }
    
    /// Tests that loading an empty file path throws an error.
    func testReadDataFromFileWithEmptyFile() {
        let graph = DijkstraGraph<String, Double>()
        let viewModel = PathFinderViewModel(graph: graph)
        
        XCTAssertThrowsError(try viewModel.readDataFromFile(filePath: ""))
    }
    
    /// Tests that shortest path can be found between two valid buildings.
    func testGetShortestPath() {
        let graph = DijkstraGraph<String, Double>()
        let viewModel = PathFinderViewModel(graph: graph)
        
        XCTAssertNoThrow(try viewModel.readDataFromFile(filePath: "campus.dot"))
        
        let result = try? viewModel.getShortestPath(from: "Memorial Union", to: "Science Hall")
        XCTAssertNotNil(result)
    }
    
    /// Tests that dataset statistics are properly formatted and contain expected information.
    func testGetDatasetStats() {
        let graph = DijkstraGraph<String, Double>()
        let viewModel = PathFinderViewModel(graph: graph)
        
        let stats = viewModel.getDatasetStats()
        XCTAssertNotNil(stats)
        XCTAssertTrue(stats.contains("Buildings"))
        XCTAssertTrue(stats.contains("Paths"))
        XCTAssertTrue(stats.contains("Walking Time"))
    }
}

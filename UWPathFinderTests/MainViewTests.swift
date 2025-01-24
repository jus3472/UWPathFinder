import XCTest
@testable import UWPathFinder

/// Tests for the main view components of the UW Path Finder app.
/// Verifies the proper initialization and functionality of:
/// - Initial state
/// - File loading
/// - Stats viewing
/// - Path finding
final class MainViewTests: XCTestCase {
    
    /// Tests that the view model starts in the correct initial state
    /// with no file loaded.
    func testInitialState() {
        let graph = DijkstraGraph<String, Double>()
        let viewModel = PathFinderViewModel(graph: graph)
        XCTAssertFalse(viewModel.isFileLoaded)
    }
    
    /// Tests that a valid campus.dot file can be loaded successfully
    /// and updates the file loaded state.
    func testLoadValidFile() {
        let graph = DijkstraGraph<String, Double>()
        let viewModel = PathFinderViewModel(graph: graph)
        XCTAssertNoThrow(try viewModel.readDataFromFile(filePath: "campus.dot"))
        XCTAssertTrue(viewModel.isFileLoaded)
    }
    
    /// Tests the LoadFileView initialization and file loading functionality.
    /// Verifies:
    /// - Initial unloaded state
    /// - Successful file loading
    /// - State update after loading
    func testLoadFileView() {
        let graph = DijkstraGraph<String, Double>()
        let viewModel = PathFinderViewModel(graph: graph)
        _ = LoadFileView(viewModel: viewModel)
        
        // Test initial state
        XCTAssertFalse(viewModel.isFileLoaded)
        
        // Test file loading
        XCTAssertNoThrow(try viewModel.readDataFromFile(filePath: "campus.dot"))
        XCTAssertTrue(viewModel.isFileLoaded)
    }
    
    /// Tests the StatsView functionality.
    /// Verifies that statistics are properly loaded and displayed
    /// after loading the campus data.
    func testStatsView() {
        let graph = DijkstraGraph<String, Double>()
        let viewModel = PathFinderViewModel(graph: graph)
        _ = StatsView(viewModel: viewModel)
        
        // Load data first
        XCTAssertNoThrow(try viewModel.readDataFromFile(filePath: "campus.dot"))
        
        // Test that stats are not empty
        XCTAssertFalse(viewModel.datasetStats.isEmpty)
    }
    
    /// Tests the PathFinderView functionality.
    /// Verifies:
    /// - Path finding between valid locations
    /// - Proper path data structure
    /// - Valid walking times and total cost
    func testPathFinderView() {
        let graph = DijkstraGraph<String, Double>()
        let viewModel = PathFinderViewModel(graph: graph)
        _ = PathFinderView(viewModel: viewModel)
        
        // Load data first
        XCTAssertNoThrow(try viewModel.readDataFromFile(filePath: "campus.dot"))
        
        // Test finding a valid path
        let result = try? viewModel.getShortestPath(
            from: "Memorial Union",
            to: "Science Hall"
        )
        XCTAssertNotNil(result)
        
        // Verify path components
        XCTAssertNotNil(result?.getPath())
        XCTAssertNotNil(result?.getWalkTimes())
        XCTAssertGreaterThan(result?.getTotalPathCost() ?? 0, 0)
    }
}

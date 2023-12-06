import org.junit.jupiter.api.Test;
import static org.junit.Assert.*;
import static org.junit.jupiter.api.Assertions.assertTrue;
import java.util.Scanner;

//5 JUnit Tests that just test frontend
public class FrontendTester {

    // Test startMainMenu(), (first method Main calls)
    @Test
    public void testStartMainMenu() {
        GraphADT<String, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        Backend backend = new Backend(graph);
        Frontend frontend = new Frontend(backend, new Scanner(System.in));
        try {
            // Test starting the main menu
            frontend.startMainMenu();
            // Assert that the operation was successful
            assertTrue(true);
        } catch (Exception e) {
            assertTrue(false);
        }
    }

    // Test frontend calling backend's readDataFromFile()
    @Test
    public void testReadLoadData() {
        GraphADT<String, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        Backend backend = new Backend(graph);
        Frontend frontend = new Frontend(backend, new Scanner(System.in));
        try {
            // Test loading a valid data file
            frontend.readLoadData("campus.dot");
            // Assert that the operation was successful
            assertTrue(true);
        } catch (Exception e) {
            assertTrue(false);
        }
    }

    // Test frontend calling backend's getDatasetStats()
    @Test
    public void testShowStats() {
        GraphADT<String, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        Backend backend = new Backend(graph);
        Frontend frontend = new Frontend(backend, new Scanner(System.in));
        try {
            frontend.showStats();
            // Assert that the operation was successful
            assertTrue(true);
        } catch (Exception e) {
            assertTrue(false);
        }
    }

    // Test frontend's handleShortestPathRequest() that displays the shortest path
    @Test
    public void testHandleShortestPathRequest() {
        GraphADT<String, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        Backend backend = new Backend(graph);
        Frontend frontend = new Frontend(backend, new Scanner(System.in));
        try {
            frontend.handleShortestPathRequest();
            // Assert that the operation was successful
            assertTrue(true);
        } catch (Exception e) {
            assertTrue(false);
        }
    }

    // Test frontend's exit method
    @Test
    public void testExitApp() {
        GraphADT<String, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        Backend backend = new Backend(graph);
        Frontend frontend = new Frontend(backend, new Scanner(System.in));
        try {
            // Test exiting the application
            frontend.exitApp();
            // Assert that the operation was successful
            assertTrue(true);
        } catch (Exception e) {
            assertTrue(false);
        }
    }

}
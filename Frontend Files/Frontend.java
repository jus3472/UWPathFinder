import java.io.IOException;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Scanner;

/**
 * The Frontend class implements the user interface for UW Path Finder,
 * providing interaction options to load data, display campus statistics,
 * find the shortest path between two locations, and exit the application.
 * It utilizes the Backend class to perform data processing and path finding.
 */
public class Frontend implements FrontendInterface {
    private Backend backend;
    private Scanner scanner;
    private boolean running;

    // Constructor to initialize Frontend with Backend and Scanner
    public Frontend(Backend backend, Scanner scanner) {
        this.backend = backend;
        this.scanner = scanner;
        this.running = true;
    }

    // Main menu for user interaction
    public void startMainMenu() {
        System.out.println("Welcome to UW Path Finder!");

        // Main loop for user input
        while (running) {
            System.out.println("\nPlease Select an Option Below!");
            System.out.println("1: Load File\n2: Show Data Stats\n3: Find Shortest Path\n4: Exit App");

            // Read user input
            String userInput = scanner.nextLine();

            // Process user input
            if (userInput.equals("1")) {
                System.out.println("\nPlease type file path: ");
                String filePath = scanner.nextLine();
                readLoadData(filePath);
            } else if (userInput.equals("2")) {
                showStats();
            } else if (userInput.equals("3")) {
                handleShortestPathRequest();
            } else if (userInput.equals("4")) {
                exitApp();
            } else {
                System.out.println("\nInvalid input, please select a valid command.");
            }
        }
    }

    // Method to read and load data from a file
    public void readLoadData(String fileName) {
        try {
            backend.readDataFromFile(fileName);
            System.out.println("\nLoading " + fileName);
            System.out.println("Success!");
        } catch (IOException e) {
            System.out.println("\nFile not found, invalid path. Please input a valid file path.");
        }
    }

    // Method to display campus statistics
    public void showStats() {
        System.out.println("\nCampus Statistics:");
        System.out.println("------------------");
        System.out.println(backend.getDatasetStats());
    }

    // Method to handle initial and final destinations for finding the shortest path
    public void handleShortestPathRequest() {
        System.out.println("\nEnter initial destination: ");
        String initial = scanner.nextLine().replaceAll("\"", "");

        System.out.println("Enter final destination: ");
        String destination = scanner.nextLine().replaceAll("\"", "");

        try {
            // Attempt to find the shortest path
            ShortestPathResult shortestPath = (ShortestPathResult) backend.getShortestPath(initial, destination);

            if (shortestPath == null) {
                System.out.println(
                        "\nEither initial or final destination is invalid. Please select new destinations and try again.");
            } else {
                // Display the shortest path details
                List<String> path = shortestPath.getPath();
                List<Double> walkTimes = shortestPath.getWalkTime();
                double cost = shortestPath.getTotalPathCost();

                System.out.println("\nList of buildings from " + initial + " to " + destination + ":");
                for (int i = 0; i < path.size() - 1; i++) {
                    System.out.print(path.get(i) + " --> ");
                }
                System.out.println(path.get(path.size() - 1)); // print out last building

                System.out.println("\nHere's the walking time for each segment from " + initial + " to "
                        + destination + ".\n");
                int j = 0;
                for (int i = 0; i < path.size() - 1; i++) {
                    System.out.println(path.get(i) + " to " + path.get(i + 1) + ": " + walkTimes.get(j) + " seconds.");
                    j++;
                }

                System.out.println(
                        "\nIt will take you " + cost + " seconds to get from " + initial + " to " + destination + ".");
            }
        } catch (NoSuchElementException e) {
            System.out.println("\nInvalid building names. Please select new locations and try again.");
        }
    }

    // Method to exit the application
    public void exitApp() {
        running = false;
        System.out.println("\nExiting app. Thank you for using UW Path Finder!");
    }

    // Main method that runs the program
    public static void main(String[] args) {
        GraphADT<String, Double> graph = new DijkstraGraph<>(new HashTableMap<>());
        Backend backend = new Backend(graph);
        Frontend frontend = new Frontend(backend, new Scanner(System.in));
        frontend.startMainMenu();
    }

}
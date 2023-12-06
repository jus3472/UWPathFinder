import java.io.File;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * The Backend class implements the BackendInterface and is responsible for
 * reading graph data from a file, inserting it into the graph data structure,
 * and providing functionalities to retrieve shortest paths and dataset
 * statistics.
 */
public class Backend implements BackendInterface {

    private GraphADT<String, Double> graph;
    // - String is NodeType or building, Double is EdgeType or cost of edge (time it
    // takes to walk from one building to another)
    // - graph is a DijkstraGraph object where you insert nodes and edges.
    // - DijkstraGraph extends BaseGraph so you have methods like insertNode() and
    // insertEdge(). insertNode() puts the building name (node) into "nodes", which
    // is a map. If a node is already in the map, it doesn't put it, so there are no
    // duplicates. insertEdge() puts the walking time (edge weight) into a list of
    // edges entering and edges leaving. When there is a duplicate edge, it updates
    // the weight.

    /**
     * Constructor for the IndividualBackendInterface.
     *
     * @param graph Reference to an object implementing GraphADT that
     *              represents the campus data.
     */
    public Backend(GraphADT<String, Double> graph) {
        this.graph = graph;
    }

    /**
     * Reads graph data from a file and inserts it into the graph data structure.
     *
     * @param filePath The path to the DOT file containing campus building and path
     *                 data.
     */
    public void readDataFromFile(String filePath) throws FileNotFoundException {
        File file = new File(filePath);
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            if (line.contains("--")) {
                processEdge(line);
            }
        }
        scanner.close();
    }

    // Helper method
    private void processEdge(String edgeLine) {
        /*
         * "Memorial Union" -- "Science Hall" [seconds=105.8];
         * "Memorial Union" -- "Brat Stand" [seconds=156.49999999999997];
         * "Memorial Union" -- "Helen C White Hall" [seconds=169.70000000000002];
         * "Memorial Union" -- "Radio Hall" [seconds=176.7];
         */
        // Splitting the line to extract building names and seconds data
        String[] parts = edgeLine.split("--");
        String building1 = parts[0].trim().replaceAll("\"", "");
        String building2 = parts[1].split("\\[")[0].trim().replaceAll("\"", "");
        Double seconds = Double.parseDouble(parts[1].split("=")[1].replaceAll("[^\\d.]", ""));

        graph.insertNode(building1);
        graph.insertNode(building2);
        graph.insertEdge(building1, building2, seconds);
        graph.insertEdge(building2, building1, seconds);

        // System.out.println(building1);
        // System.out.println(building2);
        // System.out.println(seconds);
        // System.out.println(graph.insertNode(building1));
        // System.out.println(graph.getNodeCount());
        // System.out.println(graph.containsNode(building1));
        // System.out.println(graph.insertNode(building2));
        // System.out.println(graph.getNodeCount());
        // System.out.println(graph.insertEdge(building1, building2, seconds));
        // System.out.println(graph.insertEdge(building2, building1, seconds));
        // System.out.println(graph.getEdgeCount());
    }

    /**
     * Gets the shortest path from a start building to a destination building in the
     * dataset.
     *
     * @param Building_Initial The name of the start building.
     * @param Building_Final   The name of the destination building.
     * @return An instance of the ShortestPathResultInterface containing path
     *         details.
     */
    public ShortestPathResultInterface getShortestPath(String Building_Initial, String Building_Final) {
        List<String> pathData = graph.shortestPathData(Building_Initial, Building_Final);
        List<Double> walkingTimes = graph.shortestPathWalkingTimes(Building_Initial, Building_Final);
        double pathCost = graph.shortestPathCost(Building_Initial, Building_Final);
        return new ShortestPathResult(pathData, walkingTimes, pathCost);
    }

    /**
     * Gets a string with statistics about the dataset, including the number of
     * nodes (buildings), the number of edges (connections between buildings), and
     * the total walking time (sum of weights of all edges in the graph)
     *
     * @return Statistics as a string in a specific format.
     */
    public String getDatasetStats() {
        int numNodes = graph.getNodeCount();
        int numEdges = graph.getEdgeCount();
        double totalWalkingTime = calculateTotalWalkingTime(); // Implement this method
        return String.format(
                "Number of Buildings (Nodes): %d\nNumber of Paths (Edges): %d\nTotal Walking Time: %.2f seconds",
                numNodes, numEdges,
                totalWalkingTime);
    }

    // Helper method to calculate the total walking time
    private double calculateTotalWalkingTime() {
        double totalWalkingTime = 0.0;
        Pattern pattern = Pattern.compile("\"[^\"]+\" -- \"[^\"]+\" \\[seconds=([\\d.]+)\\];");

        try (Scanner scanner = new Scanner(new File("campus.dot"))) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                Matcher matcher = pattern.matcher(line);

                if (matcher.find()) {
                    double walkingTime = Double.parseDouble(matcher.group(1));
                    totalWalkingTime += walkingTime;
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return totalWalkingTime;
    }

}
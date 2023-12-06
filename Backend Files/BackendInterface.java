import java.io.FileNotFoundException;

/**
 * The BackendInterface defines the contract for classes that handle graph data
 * and provide functionalities like reading data from a file, finding shortest
 * paths, and retrieving dataset statistics.
 */
public interface BackendInterface {

    /**
     * Reads graph data from a file and inserts it into the graph data structure.
     *
     * @param filePath The path to the DOT file containing campus building and path
     *                 data.
     * @throws FileNotFoundException If the specified file is not found.
     */
    public void readDataFromFile(String filePath) throws FileNotFoundException;

    /**
     * Gets the shortest path from a start building to a destination building in the
     * dataset.
     *
     * @param initialBuilding The name of the start building.
     * @param finalBuilding   The name of the destination building.
     * @return An instance of the ShortestPathResultInterface containing path
     *         details.
     */
    public ShortestPathResultInterface getShortestPath(String initialBuilding, String finalBuilding);

    /**
     * Gets a string with statistics about the dataset, including the number of
     * nodes (buildings),
     * the number of edges (connections between buildings), and the total walking
     * time.
     *
     * @return Statistics as a string in a specific format.
     */
    public String getDatasetStats();

}
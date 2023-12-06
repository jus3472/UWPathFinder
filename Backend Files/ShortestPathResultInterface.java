import java.util.List;

/**
 * The ShortestPathResultInterface defines the contract for classes that
 * represent the result of finding the shortest path in a graph. It provides
 * methods to access information about the path, including the list of buildings
 * in the path, the walking times for each segment, and the total estimated
 * walking time for the entire path.
 */
public interface ShortestPathResultInterface {

    /**
     * Get the path from the start building to the destination building.
     *
     * @return List of buildings representing the path.
     */
    List<String> getPath();

    /**
     * Get a list of walking times for each segment of the path (time it takes to
     * walk from one building to the next).
     *
     * @return List of walking times for each segment of the path.
     */
    List<Double> getWalkTime();

    /**
     * Get the total estimated walking time for the entire path from the start to
     * the destination building.
     *
     * @return Total path cost (estimated walking time).
     */
    double getTotalPathCost();

}
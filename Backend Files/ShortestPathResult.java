import java.util.List;

/**
 * ShortestPathResult represents the result of a shortest path search, storing the path,
 * walking times for each segment, and the total estimated walking time from the start to
 * the destination building.
 * The path is stored as a list of buildings, the walkTime is a list of walking times for
 * each segment of the path, and the cost represents the total estimated time to walk from
 * the start to the destination building.
 * This class implements the ShortestPathResultInterface, providing methods to retrieve
 * the path, walking times, and total path cost.
 */
public class ShortestPathResult implements ShortestPathResultInterface {

    // The list of buildings representing the path
    private final List<String> path;

    // The list of walking times for each segment of the path
    private final List<Double> walkTime;

    // The total estimated walking time from the start to the destination building
    private final double cost;

    /**
     * Constructs a ShortestPathResult with the given path, walkTime, and cost.
     *
     * @param path     List of buildings representing the path.
     * @param walkTime List of walking times for each segment of the path.
     * @param cost     Total path cost (estimated walking time).
     */
    public ShortestPathResult(List<String> path, List<Double> walkTime, double cost) {
        this.path = path;
        this.walkTime = walkTime;
        this.cost = cost;
    }

    /**
     * Get the path (stored as a list of buildings along the path).
     *
     * @return List of buildings representing the path.
     */
    @Override
    public List<String> getPath() {
        return path;
    }

    /**
     * Get a list of walking times of the path segments (time it takes to walk from
     * one building to the next).
     *
     * @return List of walking times for each segment of the path.
     */
    @Override
    public List<Double> getWalkTime() {
        return walkTime;
    }

    /**
     * Get the total path cost as the estimated time it takes to walk from the start
     * to the destination building.
     *
     * @return Total path cost (estimated walking time).
     */
    @Override
    public double getTotalPathCost() {
            return cost;
    }
    
}
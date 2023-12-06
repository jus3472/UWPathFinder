import java.util.LinkedList;
import java.util.NoSuchElementException;
import java.util.PriorityQueue;
import java.util.List;

/**
 * This class extends the BaseGraph data structure with additional methods for
 * computing the total cost and list of node data along the shortest path
 * connecting a provided starting to ending nodes. This class makes use of
 * Dijkstra's shortest path algorithm.
 */
// DijkstraGraph is a subclass of BaseGraph. It has access to BaseGraph's
// methods as well as its own
public class DijkstraGraph<NodeType, EdgeType extends Number>
        extends BaseGraph<NodeType, EdgeType>
        implements GraphADT<NodeType, EdgeType> {

    /**
     * While searching for the shortest path between two nodes, a SearchNode
     * contains data about one specific path between the start node and another
     * node in the graph. The final node in this path is stored in its node
     * field. The total cost of this path is stored in its cost field. And the
     * predecessor SearchNode within this path is referenced by the predecessor
     * field (this field is null within the SearchNode containing the starting
     * node in its node field).
     *
     * SearchNodes are Comparable and are sorted by cost so that the lowest cost
     * SearchNode has the highest priority within a java.util.PriorityQueue.
     */
    protected class SearchNode implements Comparable<SearchNode> {
        public Node node; // final node in path
        public double cost; // total cost of path from predecessor to node
        public SearchNode predecessor; // predecessor search node

        // Constuctor
        public SearchNode(Node node, double cost, SearchNode predecessor) {
            this.node = node;
            this.cost = cost;
            this.predecessor = predecessor;
        }

        public int compareTo(SearchNode other) {
            if (cost > other.cost)
                return +1;
            if (cost < other.cost)
                return -1;
            return 0; // same cost
        }
    }

    /**
     * Constructor that sets the map that the graph uses.
     * 
     * @param map the map that the graph uses to map a data object to the node
     *            object it is stored in
     */
    public DijkstraGraph(MapADT<NodeType, Node> map) {
        super(map);
    }

    /**
     * This helper method creates a network of SearchNodes while computing the
     * shortest path between the provided start and end locations. The
     * SearchNode that is returned by this method is represents the end of the
     * shortest path that is found: it's cost is the cost of that shortest path,
     * and the nodes linked together through predecessor references represent
     * all of the nodes along that shortest path (ordered from end to start).
     *
     * @param start the data item in the starting node for the path
     * @param end   the data item in the destination node for the path
     * @return SearchNode for the final end node within the shortest path
     * @throws NoSuchElementException when no path from start to end is found
     *                                or when either start or end data do not
     *                                correspond to a graph node
     */
    protected SearchNode computeShortestPath(NodeType start, NodeType end) {
        // Priority queue used to greedily explore shorter path possibilities
        PriorityQueue<SearchNode> priorityQueue = new PriorityQueue<>();
        // Map used to keep track of visited nodes and their shortest paths
        MapADT<NodeType, SearchNode> visitedNodes = new HashTableMap<>();

        SearchNode startNode = new SearchNode(nodes.get(start), 0, null);
        priorityQueue.add(startNode);
        visitedNodes.put(start, startNode);

        while (!priorityQueue.isEmpty()) {
            // Get node with the shortest known path
            SearchNode current = priorityQueue.poll();

            // See if we reached the destination
            if (current.node.data.equals(end)) {
                return current; // We found the shortest path
            }

            // Explore the neighbors
            for (Edge edge : current.node.edgesLeaving) {
                Node neighbor = edge.successor;

                // Calculate total cost to reach the neighbor through current node
                double newCost = current.cost + edge.data.doubleValue();

                if (!visitedNodes.containsKey(neighbor.data)) {
                    // Neighbor is not visited, add to the priority queue and visitedNodes
                    SearchNode newNode = new SearchNode(neighbor, newCost, current);
                    priorityQueue.add(newNode);
                    visitedNodes.put(neighbor.data, newNode);
                } else {
                    // Neighbor is already visited, update its info if new path is shorter
                    SearchNode existingNode = visitedNodes.get(neighbor.data);
                    if (newCost < existingNode.cost) {
                        existingNode.cost = newCost;
                        existingNode.predecessor = current;
                        // Priority queue needs to be updated too
                        priorityQueue.remove(existingNode);
                        priorityQueue.add(existingNode);
                    }
                }
            }
        }

        // If there is no path found to the end node
        throw new NoSuchElementException("There's no path from " + start.toString() + " to " + end.toString());
    }

    /**
     * Returns the list of data values from nodes along the shortest path
     * from the node with the provided start value through the node with the
     * provided end value. This list of data values starts with the start
     * value, ends with the end value, and contains intermediary values in the
     * order they are encountered while traversing this shortest path. This
     * method uses Dijkstra's shortest path algorithm to find this solution.
     *
     * @param start the data item in the starting node for the path
     * @param end   the data item in the destination node for the path
     * @return list of data item from node along this shortest path
     */
    // Returns the shortest path in a list of buildings
    public List<NodeType> shortestPathData(NodeType start, NodeType end) {
        SearchNode endNode = computeShortestPath(start, end);
        List<NodeType> pathData = new LinkedList<>();
        while (endNode != null) {
            pathData.add(0, endNode.node.data); // node.data gives you NodeType
            endNode = endNode.predecessor;
        }
        return pathData; // list of NodeTypes, the first being the first node's NodeType and the last
                         // being the last node's NodeType. The ones in between are the path.
    }

    /**
     * Finds the shortest path between the specified start and end nodes in the
     * graph, and returns a list of walking times for each segment of the path.
     *
     * @param start The starting node of the path.
     * @param end   The ending node of the path.
     * @return A list of walking times representing each segment of the shortest
     *         path from start to end.
     */
    public List<Double> shortestPathWalkingTimes(NodeType start, NodeType end) {
        SearchNode endNode = computeShortestPath(start, end);
        List<Double> listOfWalkingTimes = new LinkedList<>();
        while (endNode != null) {
            if (endNode.predecessor != null) {
                // If predecessor is not null, calculate walking time
                listOfWalkingTimes.add(0, endNode.cost - endNode.predecessor.cost);
            }
            endNode = endNode.predecessor;
        }
        return listOfWalkingTimes;
    }

    /**
     * Returns the cost of the path (sum over edge weights) of the shortest
     * path from the node containing the start data to the node containing the
     * end data. This method uses Dijkstra's shortest path algorithm to find
     * this solution.
     *
     * @param start the data item in the starting node for the path
     * @param end   the data item in the destination node for the path
     * @return the cost of the shortest path between these nodes
     */
    // Returns the cost of the shortest path
    public double shortestPathCost(NodeType start, NodeType end) {
        SearchNode endNode = computeShortestPath(start, end);
        return endNode.cost;
    }

}
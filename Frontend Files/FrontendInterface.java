import java.io.FileNotFoundException;
import java.io.IOException;

/**
 * The FrontendInterface defines the contract for classes that serve as the user
 * interface of the application. It includes methods to interact with the
 * backend, such as reading data from a dataset file, displaying dataset
 * statistics, finding the shortest path, and handling user inputs.
 */
public interface FrontendInterface {

    /**
     * Calls the backend method to read data from a specified dataset file.
     *
     * @param fileName The file path of the dataset.
     * @throws FileNotFoundException If the specified file is not found.
     * @throws IOException           If an I/O error occurs while reading the file.
     */
    public void readLoadData(String fileName) throws FileNotFoundException, IOException;

    /**
     * Displays statistics about the dataset, including the number of buildings
     * (nodes), the number of edges, and the total walking time (sum of all edge
     * weights) in the graph.
     */
    public void showStats();

    /**
     * Handles the user's request to find the shortest path between initial and
     * final destinations. Prompts the user to enter the initial and final
     * destinations, attempts to find the shortest path, and displays the path
     * details if found. If the destinations are invalid or no path is found,
     * appropriate error messages are displayed.
     */
    public void handleShortestPathRequest();

    /**
     * Exits the application.
     */
    public void exitApp();

    /**
     * Initiates the main menu options when called.
     *
     * @throws IOException           If an I/O error occurs.
     * @throws FileNotFoundException If a specified file is not found.
     */
    public void startMainMenu() throws FileNotFoundException, IOException;
}

// Assuming 'conn' is the open SqlConnection from the first part of your code
// and 'files1' is the array of files being iterated over.

int hhCount = 0; // Initialize the counter

foreach (string file in files1)
{
    string fileName = Path.GetFileNameWithoutExtension(file);
    
    // Check if the file meets the naming criteria
    if (fileName.Contains(todayDate1) && fileName.Contains("valuations"))
    {
        // Read all lines from the file
        string[] lines = File.ReadAllLines(file, Encoding.UTF8);
        
        // Process each line in the file
        foreach (string line in lines)
        {
            // Split the line into columns (assuming CSV, adjust delimiter if needed)
            string[] columns = line.Split(',');

            // Check if the line has at least 2 columns (index 0 and index 1)
            if (columns.Length >= 2)
            {
                // Get the value from the second column (index 1 in a zero-indexed array)
                string c2Value = columns[1].Trim(); // .Trim() removes leading/trailing spaces

                // Define the SQL query for this line
                // *** IMPORTANT: Use parameterized query to prevent SQL Injection ***
                string query_line = "SELECT TOP 1 c1 FROM t1 WHERE c2 = @c2Value";

                using (SqlCommand cmd_line = new SqlCommand(query_line, conn))
                {
                    // Add the parameter securely
                    cmd_line.Parameters.AddWithValue("@c2Value", c2Value);

                    // Execute the query to get the value of c1
                    object result = cmd_line.ExecuteScalar();
                    
                    if (result != null)
                    {
                        // Convert the result to a string and check if it equals "hh"
                        string c1Value = result.ToString();
                        
                        if (c1Value.Equals("hh", StringComparison.OrdinalIgnoreCase)) 
                        {
                            hhCount++; // Increment the counter
                        }
                    }
                }
            }
        }
    }
}

// After the loop, 'hhCount' holds the total count of matches.
// You can then use it for logging, display, or further processing.
Console.WriteLine($"Total 'hh' matches found: {hhCount}");

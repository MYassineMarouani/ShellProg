using System;
using System.Data.SqlClient;
using Microsoft.SqlServer.Dts.Runtime;

public void Main()
{
    long resultCount = 0;

    // 🔹 Random example connection string
    string connectionString =
        "Data Source=SQLTEST01\\INST_A;" +
        "Initial Catalog=SalesDB;" +
        "Integrated Security=SSPI;";

    // 🔹 Random example query
    string query = @"
        SELECT COUNT(*)
        FROM Orders
        WHERE OrderStatus = 'Completed'
          AND OrderDate >= '2025-01-01';
    ";

    try
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                resultCount = (long)cmd.ExecuteScalar();
            }
        }

        // Optional: save to SSIS variable
        // Dts.Variables["User::ResultCount"].Value = resultCount;

        Dts.TaskResult = (int)ScriptResults.Success;
    }
    catch (Exception ex)
    {
        Dts.Events.FireError(
            0,
            "SSIS Script Task Error",
            ex.Message,
            string.Empty,
            0);

        Dts.TaskResult = (int)ScriptResults.Failure;
    }
}

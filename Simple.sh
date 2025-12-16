using System;
using System.Data;
using System.Data.SqlClient;

int totalUsers = 0;

string connectionString =
    "Data Source=SERVER_XYZ\\SQL2022;" +
    "Initial Catalog=SalesManagementDB;" +
    "Integrated Security=SSPI;";

string query = @"
    SELECT COUNT(*) AS UserCount
    FROM APP_USERS
";

using (SqlConnection conn = new SqlConnection(connectionString))
{
    conn.Open();

    using (SqlCommand cmd = new SqlCommand(query, conn))
    {
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            if (reader.Read())
            {
                totalUsers = reader.IsDBNull(0) ? 0 : reader.GetInt32(0);
            }
        }
    }
}

// Example usage (HTML / log / console)
string output = totalUsers.ToString();

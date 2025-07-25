string final = "";

if (col97Values.Count > 0)
{
    // 1. Faire SELECT v1 FROM t1 (sans WHERE)
    HashSet<string> v1Values = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

    using (SqlConnection conn = new SqlConnection("Data Source=TON_SERVEUR;Initial Catalog=TA_BASE;Integrated Security=SSPI"))
    {
        conn.Open();

        using (SqlCommand cmd = new SqlCommand("SELECT v1 FROM t1", conn))
        {
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (!reader.IsDBNull(0))
                    {
                        string value = reader.GetString(0).Trim();
                        v1Values.Add(value);
                    }
                }
            }
        }
    }

    // 2. Comparer avec ta liste C#
    List<string> notFound = new List<string>();
    foreach (string val in ktpCol97Values)
    {
        if (!v1Values.Contains(val.Trim()))
        {
            notFound.Add(val.Trim());
        }
    }

    // 3. Concaténer les valeurs absentes dans v1
    final = string.Join(",", notFound);
}
else
{
    final = ""; // Liste vide
}

using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.OracleClient; // ou Oracle.ManagedDataAccess.Client si tu utilises ODP.NET
using System.Collections.Generic;
using Microsoft.SqlServer.Dts.Runtime;

public void Main()
{
    // === 1. Connexion Oracle et récupération des valeurs c1 ===
    List<string> oracleList = new List<string>();
    using (OracleConnection conn = new OracleConnection("Data Source=TON_TNS;User Id=UTILISATEUR;Password=MOTDEPASSE;"))
    {
        conn.Open();
        using (OracleCommand cmd = new OracleCommand("SELECT c1 FROM t1", conn))
        using (OracleDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read())
            {
                oracleList.Add(reader.GetString(0).Trim());
            }
        }
    }

    // === 2. Connexion SQL Server et récupération des valeurs c2 ===
    List<string> sqlList = new List<string>();
    using (SqlConnection conn = new SqlConnection("Server=TON_SERVEUR;Database=TA_BASE;User Id=UTILISATEUR;Password=MOTDEPASSE;"))
    {
        conn.Open();
        using (SqlCommand cmd = new SqlCommand("SELECT c2 FROM t2", conn))
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read())
            {
                sqlList.Add(reader.GetString(0).Trim());
            }
        }
    }

    // === 3. Comparaison : si c1 pas dans c2, on concatène dans la variable SSIS ===
    List<string> missing = new List<string>();
    foreach (string val in oracleList)
    {
        if (!sqlList.Contains(val))
        {
            missing.Add(val);
        }
    }

    // Création du résultat concaténé
    string result = string.Join(",", missing);
    
    // Affecter à la variable SSIS
    Dts.Variables["User::ResultDiff"].Value = result;

    Dts.TaskResult = (int)ScriptResults.Success;
}


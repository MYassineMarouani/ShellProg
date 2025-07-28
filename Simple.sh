using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.Odbc;
using System.Collections.Generic;
using Microsoft.SqlServer.Dts.Runtime;

public void Main()
{
    List<string> oracleList = new List<string>();
    List<string> sqlList = new List<string>();

    // === 1. Connexion ODBC à Oracle ===
    string oracleConnStr = "Driver={Oracle in OraClient11g_home1};Dbq=TON_TNS;Uid=UTILISATEUR;Pwd=MOTDEPASSE;";
    using (OdbcConnection odbcConn = new OdbcConnection(oracleConnStr))
    {
        odbcConn.Open();
        using (OdbcCommand cmd = new OdbcCommand("SELECT c1 FROM t1", odbcConn))
        using (OdbcDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read())
            {
                oracleList.Add(reader.GetString(0).Trim());
            }
        }
    }

    // === 2. Connexion SQL Server ===
    string sqlConnStr = "Server=TON_SERVEUR;Database=TA_BASE;User Id=UTILISATEUR;Password=MOTDEPASSE;";
    using (SqlConnection sqlConn = new SqlConnection(sqlConnStr))
    {
        sqlConn.Open();
        using (SqlCommand cmd = new SqlCommand("SELECT c2 FROM t2", sqlConn))
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read())
            {
                sqlList.Add(reader.GetString(0).Trim());
            }
        }
    }

    // === 3. Comparaison et concaténation des c1 manquants ===
    List<string> missing = new List<string>();
    foreach (string c1 in oracleList)
    {
        if (!sqlList.Contains(c1))
        {
            missing.Add(c1);
        }
    }

    string result = string.Join(",", missing);

    // === 4. Affectation à la variable SSIS ===
    Dts.Variables["User::ResultDiff"].Value = result;
    Dts.TaskResult = (int)ScriptResults.Success;
}

using System;
using System.Data;
using System.Data.Odbc;
using System.Data.SqlClient;
using System.Collections.Generic;
using Microsoft.SqlServer.Dts.Runtime;

public void Main()
{
    // === Informations de connexion Oracle ===
    string host = "your_hostname";
    string port = "1521";
    string sid = "your_sid";
    string username = "your_username";
    string password = "your_password";

    // === Chaîne de connexion Oracle ODBC (driver direct) ===
    string oracleConnStr = $"Driver={{Oracle in OraClient19Home1}};Dbq={host}:{port}/{sid};Uid={username};Pwd={password};";

    // === Récupérer la liste depuis Oracle (SELECT c1 FROM t1) ===
    List<string> oracleList = new List<string>();

    using (OdbcConnection oracleConn = new OdbcConnection(oracleConnStr))
    {
        oracleConn.Open();
        using (OdbcCommand cmd = new OdbcCommand("SELECT c1 FROM t1", oracleConn))
        using (OdbcDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read())
            {
                if (!reader.IsDBNull(0))
                    oracleList.Add(reader.GetString(0).Trim());
            }
        }
        oracleConn.Close();
    }

    // === Connexion SQL Server ===
    string sqlServerConnStr = "Server=your_sql_server;Database=your_database;User Id=your_sql_user;Password=your_sql_password;";
    List<string> sqlList = new List<string>();

    using (SqlConnection sqlConn = new SqlConnection(sqlServerConnStr))
    {
        sqlConn.Open();
        using (SqlCommand cmd = new SqlCommand("SELECT c2 FROM t2", sqlConn))
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read())
            {
                if (!reader.IsDBNull(0))
                    sqlList.Add(reader.GetString(0).Trim());
            }
        }
        sqlConn.Close();
    }

    // === Comparaison Oracle vs SQL Server ===
    List<string> missingList = new List<string>();

    foreach (string c1 in oracleList)
    {
        if (!sqlList.Contains(c1))
        {
            missingList.Add(c1);
        }
    }

    // === Concaténation du résultat (séparé par des virgules) ===
    string missingConcatenated = string.Join(",", missingList);

    // === Stockage du résultat dans la variable SSIS ===
    Dts.Variables["User::MissingC1List"].Value = missingConcatenated;

    Dts.TaskResult = (int)ScriptResults.Success;
}

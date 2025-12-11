/*
  SSIS Script Task C# Code
  ---
  Remember to add the following SSIS variables to the ReadOnlyVariables and ReadWriteVariables:
  ReadOnlyVariables: User::SourceDirectory
  ReadWriteVariables: User::FileCount
*/

using System;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using Microsoft.SqlServer.Dts.Runtime;

[Microsoft.SqlServer.Dts.Tasks.ScriptTask.SSISScriptTaskEntryPointAttribute]
public partial class ScriptMain : Microsoft.SqlServer.Dts.Tasks.ScriptTask.VSTARTScriptObjectModelBase
{
    public void Main()
    {
        // 1. Define Variables
        string sourceDirectory = Dts.Variables["User::SourceDirectory"].Value.ToString();
        int fileCount = 0;

        try
        {
            // 2. Check if the directory exists
            if (!Directory.Exists(sourceDirectory))
            {
                Dts.Events.FireError(0, "Script Task", $"Directory not found: {sourceDirectory}", string.Empty, 0);
                Dts.TaskResult = (int)ScriptResults.Failure;
                return;
            }

            // 3. Efficiently enumerate and filter files
            // Using EnumerateFiles for performance on large directories
            var matchingFiles = Directory.EnumerateFiles(
                sourceDirectory, 
                "*.csv", // Filter for CSV files first for a potential minor speed-up
                SearchOption.TopDirectoryOnly)
                .Where(fileName => 
                    // Use Path.GetFileName to check only the name, not the full path
                    Path.GetFileName(fileName).IndexOf("abc", StringComparison.OrdinalIgnoreCase) >= 0);

            // 4. Get the count
            fileCount = matchingFiles.Count();

            // 5. Store the result in the SSIS variable
            Dts.Variables["User::FileCount"].Value = fileCount;
            
            // Optional: Log the result
            Dts.Events.FireInformation(0, "Script Task", $"Found {fileCount} matching files in {sourceDirectory}", string.Empty, 0, ref isCancelled);
            
            Dts.TaskResult = (int)ScriptResults.Success;
        }
        catch (Exception ex)
        {
            Dts.Events.FireError(0, "Script Task", $"An error occurred: {ex.Message}", string.Empty, 0);
            Dts.TaskResult = (int)ScriptResults.Failure;
        }
    }

    enum ScriptResults
    {
        Success = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Success,
        Failure = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Failure
    }
}

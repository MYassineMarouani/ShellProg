bool searchSubDirectories = false;
var searchOption = searchSubDirectories
    ? SearchOption.AllDirectories
    : SearchOption.TopDirectoryOnly;

string ktpfolder = @"G:\KTP\APP\Custom\KTP2\out\emir\source";

int KTPRECMONTH = 0;

// Date range (UTC)
DateTime startOfMonth = new DateTime(DateTime.UtcNow.Year, DateTime.UtcNow.Month, 1);
DateTime startOfNextMonth = startOfMonth.AddMonths(1);

foreach (var file in Directory.EnumerateFiles(ktpfolder, "*.csv", searchOption))
{
    // 🔴 FILTER FILES FIRST (HUGE performance gain)
    DateTime lastWrite = File.GetLastWriteTimeUtc(file);
    if (lastWrite < startOfMonth || lastWrite >= startOfNextMonth)
        continue;

    // 🔴 Stream file (no full memory load)
    foreach (string line in File.ReadLines(file, Encoding.UTF8))
    {
        if (string.IsNullOrWhiteSpace(line))
            continue;

        string[] columns = line.Split(';');
        if (columns.Length <= 3)
            continue;

        if (columns[3].Trim()
            .Equals("969500219DJHZ3449066", StringComparison.OrdinalIgnoreCase))
        {
            KTPRECMONTH++;
        }
    }
}


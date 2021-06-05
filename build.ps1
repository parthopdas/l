python .\scripts\xlsx2csv.py .\_languages.xlsx ./build --all

Remove-Item "./build/* - notes.csv"

@("pāli", "čeština") | ForEach-Object {
  $lang = $_
  Get-ChildItem ./build -Filter "$($lang) - *.csv" | ForEach-Object {
    $file = $_
    $dstFileName = $file.Name.Replace("$lang - ", '')
    Copy-Item $file.FullName "./$lang/$dstFileName" -Force -Verbose
  }
}

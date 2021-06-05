$root = $PSScriptRoot
$alphabet = Import-Csv -Path "$root\alphabet.csv"

Write-Host -ForegroundColor Green "Generating html fragment for blog..."
$alphabet | ForEach-Object { $counter = 0 } {
  $grapheme = $_."roman"
  $phonemeId = $_."phoneme"
  $dpdId = $_."dpd id"
  $word = $_."r-word"
  $pronunciationId = $_."pronunciation"
  $closestEn = [System.Web.HttpUtility]::HtmlEncode($_."approx en")
  $ipa = $_."ipa"
  $ipaWikiId = $_."ipa wiki id"

  $isFirstVowel = $counter -eq 0
  $isFirstConsonant = $counter -eq 10
  $firstRowTemplate = @"
        <td rowspan="__ROWSPAN__" style="padding: 0.2rem;">
          <span style="writing-mode: vertical-lr; transform: rotate(180deg);">__TYPE__</span>
        </td>
"@

  if ($isFirstVowel) {
    $firstRow = $firstRowTemplate.Replace("__ROWSPAN__", "10").Replace("__TYPE__", "vowel")
  } elseif ($isFirstConsonant) {
    $firstRow = $firstRowTemplate.Replace("__ROWSPAN__", "33").Replace("__TYPE__", "consonant")
  } else {
    $firstRow = @"
        <!-- <td></td> -->
"@
  }

  @"
      <tr>
$firstRow
        <td>$($grapheme)</td>
        <td>
          <audio class="audio" controls src="https://raw.githubusercontent.com/parthopdas/l/master/pāli/audio/$phonemeId.mp3"></audio>
        </td>
        <td><a href="https://d.pali.tools/apps#/inflect/$dpdId" target="_blank">$word</a></td>
        <td>
          <audio class="audio" controls src="https://raw.githubusercontent.com/parthopdas/l/master/pāli/audio/$pronunciationId.mp3"></audio>
        </td>
        <td>$closestEn</td>
        <td><a href="https://en.wikipedia.org/wiki/$ipaWikiId" target="_blank">$ipa</a></td>
      </tr>
"@

  $counter++
} | Out-File "$root\..\build\htmlfragment.html"

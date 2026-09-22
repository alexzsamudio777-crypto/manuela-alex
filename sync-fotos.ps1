$img = Get-ChildItem -Path .\img -File

$fotos = $img | Where-Object { $_.Extension -match "^\.(jpg|jpeg|png|webp)$" } |
  Sort-Object Name | ForEach-Object { "img/" + ($_.Name -replace " ", "%20") }

$videos = $img | Where-Object { $_.Extension -match "^\.(mp4|mov|webm)$" } |
  Sort-Object Name | ForEach-Object { "img/" + ($_.Name -replace " ", "%20") }

$fotosJs = ($fotos | ForEach-Object { "    '$_'" }) -join ",`n"
$videosJs = ($videos | ForEach-Object { "    '$_'" }) -join ",`n"

$html = Get-Content .\index.html -Raw
$html = $html -replace "(?s)const fotos = \[.*?\];", "const fotos = [`n$fotosJs`n  ];"
$html = $html -replace "(?s)const videos = \[.*?\];", "const videos = [`n$videosJs`n  ];"
Set-Content -Path .\index.html -Value $html -Encoding UTF8

Write-Host "Fotos: $($fotos.Count)  Videos: $($videos.Count)"

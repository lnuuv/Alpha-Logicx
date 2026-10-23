@echo off
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=[IO.File]::ReadAllText('%~f0'); iex $s.Substring($s.IndexOf('#PS#'+'START')+9)"
pause
exit /b
#PS#START
$root = (Get-Location).Path
$main = 'index.html'
if (-not (Test-Path -LiteralPath (Join-Path $root $main))) {
  $h = Get-ChildItem -LiteralPath $root -Filter *.html | Sort-Object Length -Descending | Select-Object -First 1
  if ($h) { $main = $h.Name } else { Write-Host "  No .html file found in: $root"; return }
}
$port = 8080
while ($true) {
  $l = New-Object System.Net.HttpListener
  $l.Prefixes.Add("http://localhost:$port/")
  try { $l.Start(); break } catch { $port++ }
}
Write-Host ""
Write-Host "  Alpha LogicX is running:  http://localhost:$port/  ($main)"
Write-Host "  Keep this window open. Close it to stop the site."
Start-Process "http://localhost:$port/"
$types = @{ '.html'='text/html; charset=utf-8'; '.js'='application/javascript'; '.css'='text/css'; '.json'='application/json';
  '.png'='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.gif'='image/gif'; '.svg'='image/svg+xml'; '.ico'='image/x-icon';
  '.mp4'='video/mp4'; '.webm'='video/webm'; '.mp3'='audio/mpeg'; '.woff2'='font/woff2'; '.pdf'='application/pdf' }
while ($l.IsListening) {
  $c = $l.GetContext()
  try {
    $p = [Uri]::UnescapeDataString($c.Request.Url.AbsolutePath.TrimStart('/'))
    if ($p -eq '' -or ($p -eq 'index.html' -and -not (Test-Path -LiteralPath (Join-Path $root $p)))) { $p = $main }
    $f = [IO.Path]::GetFullPath((Join-Path $root $p))
    if ($f.StartsWith($root) -and (Test-Path -LiteralPath $f -PathType Leaf)) {
      $b = [IO.File]::ReadAllBytes($f)
      $ext = [IO.Path]::GetExtension($f).ToLower()
      $c.Response.ContentType = $(if ($types[$ext]) { $types[$ext] } else { 'application/octet-stream' })
      $c.Response.ContentLength64 = $b.Length
      $c.Response.OutputStream.Write($b, 0, $b.Length)
    } else { $c.Response.StatusCode = 404 }
  } catch { } finally { try { $c.Response.Close() } catch { } }
}

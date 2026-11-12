# Generates the dev-flavor launcher icons: the normal icons with an amber "DEV"
# banner, so testers never confuse a dev build with production (engineering
# standard §17.5). Writes to android/app/src/dev/res/, which Gradle merges over
# main/res for the dev flavor only.
#
# Uses only Windows PowerShell + .NET System.Drawing (offline). Re-run after
# tool/generate_icon.ps1 changes the main icon.
#
#   pwsh -File tool/generate_dev_icon.ps1

Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'

$root    = Split-Path -Parent $PSScriptRoot
$mainRes = Join-Path $root 'android/app/src/main/res'
$devRes  = Join-Path $root 'android/app/src/dev/res'

$banner = [System.Drawing.Color]::FromArgb(255, 0xE6, 0xA9, 0x4B)   # amber
$text   = [System.Drawing.Color]::FromArgb(255, 0x1F, 0x2A, 0x3A)   # dark slate

# Draws a horizontal banner across the lower part of the image with "DEV".
# For adaptive foregrounds the banner stays inside the 66% safe zone.
function Add-DevBanner([string]$src, [string]$dst, [double]$top, [double]$height, [double]$inset) {
  $img = [System.Drawing.Image]::FromFile($src)
  $bmp = New-Object System.Drawing.Bitmap($img.Width, $img.Height)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.TextRenderingHint = 'AntiAliasGridFit'
  $g.DrawImage($img, 0, 0, $img.Width, $img.Height)
  $img.Dispose()

  $w = $bmp.Width; $h = $bmp.Height
  $x = $w * $inset; $bw = $w - 2 * $x
  $y = $h * $top;   $bh = $h * $height
  $g.FillRectangle((New-Object System.Drawing.SolidBrush($banner)), [single]$x, [single]$y, [single]$bw, [single]$bh)

  $font = New-Object System.Drawing.Font('Arial', [single]($bh * 0.62), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $fmt = New-Object System.Drawing.StringFormat
  $fmt.Alignment = 'Center'; $fmt.LineAlignment = 'Center'
  $rect = New-Object System.Drawing.RectangleF([single]$x, [single]$y, [single]$bw, [single]$bh)
  $g.DrawString('DEV', $font, (New-Object System.Drawing.SolidBrush($text)), $rect, $fmt)

  $g.Dispose()
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
  $bmp.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}

foreach ($dir in Get-ChildItem -Path $mainRes -Directory -Filter 'mipmap-*dpi') {
  $outDir = Join-Path $devRes $dir.Name
  $legacy = Join-Path $dir.FullName 'ic_launcher.png'
  if (Test-Path $legacy) {
    Add-DevBanner $legacy (Join-Path $outDir 'ic_launcher.png') 0.62 0.20 0.12
  }
  $fg = Join-Path $dir.FullName 'ic_launcher_foreground.png'
  if (Test-Path $fg) {
    # Adaptive foreground: keep the banner inside the central safe zone.
    Add-DevBanner $fg (Join-Path $outDir 'ic_launcher_foreground.png') 0.58 0.12 0.26
  }
}
Write-Host "Dev icons written to $devRes"

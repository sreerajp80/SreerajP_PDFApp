# Generates the app launcher icon (adaptive + legacy) for SreerajP_PDFApp.
#
# Concept: a white PDF document sheet (folded corner) emerging from a small
# white printer, on a slate-blue gradient tile. Slate = app theme seed #3D5A80.
#
# Uses only Windows PowerShell + .NET System.Drawing (fully offline, no fonts
# strictly required). Re-run any time to tweak the design.
#
#   pwsh -File tool/generate_icon.ps1

Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'

$root   = Split-Path -Parent $PSScriptRoot
$resDir = Join-Path $root 'android/app/src/main/res'
$brand  = Join-Path $root 'assets/branding'
New-Item -ItemType Directory -Force -Path $brand | Out-Null

# ---- palette --------------------------------------------------------------
function C([int]$a,[int]$r,[int]$g,[int]$b){ [System.Drawing.Color]::FromArgb($a,$r,$g,$b) }

$gradTop    = C 255 0x4A 0x6A 0x94   # lighter slate
$gradBottom = C 255 0x2E 0x44 0x60   # darker slate
$paperWhite = C 255 0xFF 0xFF 0xFF
$paperShade = C 255 0xE6 0xEB 0xF2   # underside of the fold
$printWhite = C 255 0xF4 0xF7 0xFB
$printSlot  = C 255 0xC7 0xD0 0xDD
$lineSlate  = C 255 0x3D 0x5A 0x80   # theme seed, used for content lines + PDF
$lineLight  = C 255 0xB9 0xC4 0xD4
$led        = C 255 0xE6 0xA9 0x4B   # small amber status light
$shadow     = C 60  0x14 0x1E 0x2C   # soft drop shadow

# ---- helpers --------------------------------------------------------------
function New-RoundedPath([double]$x,[double]$y,[double]$w,[double]$h,[double]$r){
  $p = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = 2*$r
  $p.AddArc($x,        $y,        $d,$d, 180,90)
  $p.AddArc($x+$w-$d,  $y,        $d,$d, 270,90)
  $p.AddArc($x+$w-$d,  $y+$h-$d,  $d,$d,   0,90)
  $p.AddArc($x,        $y+$h-$d,  $d,$d,  90,90)
  $p.CloseFigure()
  return $p
}

function PtF([double]$x,[double]$y){ New-Object System.Drawing.PointF([single]$x,[single]$y) }

# Draws a pen laid diagonally, centred on (cx,cy), length L, thickness T,
# rotated by angleDeg. Amber barrel + light nib + darker cap.
function Draw-Pen([System.Drawing.Graphics]$g,[double]$cx,[double]$cy,[double]$L,[double]$T,[double]$angleDeg){
  $penBody = C 255 0xE6 0xA9 0x4B
  $penCap  = C 255 0xC9 0x8A 0x2E
  $penNib  = C 255 0xD9 0xE0 0xEA
  $nibTip  = C 255 0x3D 0x5A 0x80
  $st = $g.Save()
  $g.TranslateTransform([single]$cx,[single]$cy)
  $g.RotateTransform([single]$angleDeg)
  $h = $L/2.0; $t = $T/2.0
  # soft shadow under the pen
  $g.FillPath((New-Object System.Drawing.SolidBrush($shadow)), (New-RoundedPath (-$h+8) (-$t+16) $L $T ($t)))
  # nib (writing tip) at the left end
  $g.FillPolygon((New-Object System.Drawing.SolidBrush($penNib)), [System.Drawing.PointF[]]@(
    (PtF (-$h)      0),
    (PtF (-$h+82)  (-$t)),
    (PtF (-$h+82)  ( $t))
  ))
  $g.FillPolygon((New-Object System.Drawing.SolidBrush($nibTip)), [System.Drawing.PointF[]]@(
    (PtF (-$h)      0),
    (PtF (-$h+30)  (-$t*0.42)),
    (PtF (-$h+30)  ( $t*0.42))
  ))
  # barrel
  $g.FillPath((New-Object System.Drawing.SolidBrush($penBody)), (New-RoundedPath (-$h+78) (-$t) ($L-150) $T ($t)))
  # collar band near the nib
  $g.FillPath((New-Object System.Drawing.SolidBrush($penCap)),  (New-RoundedPath (-$h+78) (-$t) 26 $T 8))
  # end cap
  $g.FillPath((New-Object System.Drawing.SolidBrush($penCap)),  (New-RoundedPath ($h-84) (-$t) 84 $T ($t)))
  # subtle highlight along the barrel
  $g.FillPath((New-Object System.Drawing.SolidBrush((C 90 255 255 255))), (New-RoundedPath (-$h+96) (-$t+8) ($L-190) 12 6))
  $g.Restore($st)
}

# Draws the artwork in a 1024x1024 logical space. Caller sets the transform.
# Art bounds sit within ~[100..924] so it has padding for a tile and can be
# scaled down into the adaptive safe zone.
#
# Layout: a large PDF sheet is the hero (reader), a pen crosses its lower half
# (editor), and a small printer sits at the base (printer).
function Draw-Art([System.Drawing.Graphics]$g){
  # --- geometry (1024 reference) ---
  $px=312; $py=196; $pw=400; $ph=450; $fold=104          # hero paper sheet
  $bx=356; $by=612; $bw=312; $bh=150; $br=26             # small printer body

  # small printer (drawn first so the sheet overlaps its top = "emerging")
  $g.FillPath((New-Object System.Drawing.SolidBrush($printWhite)), (New-RoundedPath $bx $by $bw $bh $br))
  $g.FillPath((New-Object System.Drawing.SolidBrush($printSlot)),  (New-RoundedPath ($bx+52) ($by+$bh-52) ($bw-104) 26 12))
  $g.FillEllipse((New-Object System.Drawing.SolidBrush($led)), ($bx+$bw-56), ($by+28), 24, 24)
  $g.FillPath((New-Object System.Drawing.SolidBrush($printWhite)), (New-RoundedPath ($bx+22)     ($by+$bh) 52 20 10))
  $g.FillPath((New-Object System.Drawing.SolidBrush($printWhite)), (New-RoundedPath ($bx+$bw-74) ($by+$bh) 52 20 10))

  # soft shadow under the sheet
  $g.FillPolygon((New-Object System.Drawing.SolidBrush($shadow)), [System.Drawing.PointF[]]@(
    (PtF ($px+16)           ($py+20)),
    (PtF ($px+$pw-$fold+16) ($py+20)),
    (PtF ($px+$pw+16)       ($py+$fold+20)),
    (PtF ($px+$pw+16)       ($py+$ph+20)),
    (PtF ($px+16)           ($py+$ph+20))
  ))

  # hero paper sheet with a dog-eared top-right corner
  $g.FillPolygon((New-Object System.Drawing.SolidBrush($paperWhite)), [System.Drawing.PointF[]]@(
    (PtF $px             $py),
    (PtF ($px+$pw-$fold) $py),
    (PtF ($px+$pw)       ($py+$fold)),
    (PtF ($px+$pw)       ($py+$ph)),
    (PtF $px             ($py+$ph))
  ))
  # the folded corner (underside)
  $g.FillPolygon((New-Object System.Drawing.SolidBrush($paperShade)), [System.Drawing.PointF[]]@(
    (PtF ($px+$pw-$fold) $py),
    (PtF ($px+$pw)       ($py+$fold)),
    (PtF ($px+$pw-$fold) ($py+$fold))
  ))

  # content lines near the top of the sheet
  $ll = New-Object System.Drawing.SolidBrush($lineLight)
  $g.FillPath($ll, (New-RoundedPath ($px+48) ($py+58)  ($pw-170) 22 11))
  $g.FillPath($ll, (New-RoundedPath ($px+48) ($py+104) ($pw-110) 22 11))
  $ll.Dispose()

  # "PDF" label (real text if a font is available; harmless if not)
  try {
    $font = New-Object System.Drawing.Font('Segoe UI', 100, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $fmt  = New-Object System.Drawing.StringFormat
    $fmt.Alignment = [System.Drawing.StringAlignment]::Center
    $fmt.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = New-Object System.Drawing.RectangleF([single]$px,[single]($py+150),[single]$pw,[single]130)
    $g.DrawString('PDF', $font, (New-Object System.Drawing.SolidBrush($lineSlate)), $rect, $fmt)
    $font.Dispose()
  } catch {
    $sl = New-Object System.Drawing.SolidBrush($lineSlate)
    $g.FillPath($sl, (New-RoundedPath ($px+96)  ($py+168) 52 96 10))
    $g.FillPath($sl, (New-RoundedPath ($px+174) ($py+168) 52 96 10))
    $g.FillPath($sl, (New-RoundedPath ($px+252) ($py+168) 52 96 10))
    $sl.Dispose()
  }

  # pen across the lower half of the sheet (editor cue)
  Draw-Pen $g 508 512 360 48 -31
}

function New-Canvas([int]$size){
  $bmp = New-Object System.Drawing.Bitmap($size,$size,[System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.TextRenderingHint  = [System.Drawing.Text.TextRenderingHint]::AntiAlias
  return @($bmp,$g)
}

function Save-Png($bmp,[string]$path){
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $path) | Out-Null
  $bmp.Save($path,[System.Drawing.Imaging.ImageFormat]::Png)
}

# ---- renderers ------------------------------------------------------------
function Render-Legacy([int]$size,[string]$path){
  $c = New-Canvas $size; $bmp=$c[0]; $g=$c[1]
  $s = $size/1024.0
  $g.ScaleTransform($s,$s)
  # rounded slate tile with gradient
  $rect = New-Object System.Drawing.Rectangle(0,0,1024,1024)
  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,$gradTop,$gradBottom,90)
  $tile = New-RoundedPath 40 40 944 944 190
  $g.FillPath($grad,$tile)
  Draw-Art $g
  $g.Dispose(); Save-Png $bmp $path; $bmp.Dispose()
}

function Render-Foreground([int]$size,[string]$path){
  $c = New-Canvas $size; $bmp=$c[0]; $g=$c[1]
  # scale art into the adaptive safe zone (~66% centered)
  $s = ($size/1024.0)*0.72
  $g.TranslateTransform($size/2.0,$size/2.0)
  $g.ScaleTransform($s,$s)
  $g.TranslateTransform(-512,-512)
  Draw-Art $g
  $g.Dispose(); Save-Png $bmp $path; $bmp.Dispose()
}

function Render-Background([int]$size,[string]$path){
  $c = New-Canvas $size; $bmp=$c[0]; $g=$c[1]
  $rect = New-Object System.Drawing.Rectangle(0,0,$size,$size)
  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,$gradTop,$gradBottom,90)
  $g.FillRectangle($grad,$rect)
  $g.Dispose(); Save-Png $bmp $path; $bmp.Dispose()
}

# ---- density map ----------------------------------------------------------
$dens = @(
  @{ name='mdpi';    legacy=48;  adaptive=108 },
  @{ name='hdpi';    legacy=72;  adaptive=162 },
  @{ name='xhdpi';   legacy=96;  adaptive=216 },
  @{ name='xxhdpi';  legacy=144; adaptive=324 },
  @{ name='xxxhdpi'; legacy=192; adaptive=432 }
)

foreach($d in $dens){
  $dir = Join-Path $resDir ("mipmap-"+$d.name)
  Render-Legacy     $d.legacy   (Join-Path $dir 'ic_launcher.png')
  Render-Foreground $d.adaptive (Join-Path $dir 'ic_launcher_foreground.png')
  Render-Background $d.adaptive (Join-Path $dir 'ic_launcher_background.png')
  Write-Host ("  " + $d.name + " done")
}

# Play Store master
Render-Legacy 1024 (Join-Path $brand 'ic_launcher_1024.png')
Write-Host "  1024 master done"
Write-Host "All icons generated."

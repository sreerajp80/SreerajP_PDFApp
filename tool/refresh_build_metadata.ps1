# Refreshes app_version.g.dart and build_date.g.dart using Flutter's Dart SDK.
# Usage:  pwsh tool/refresh_build_metadata.ps1

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

Write-Host "Refreshing build metadata..." -ForegroundColor Cyan

dart run tool/generate_app_version.dart
dart run tool/generate_build_date.dart

Write-Host "Done." -ForegroundColor Green

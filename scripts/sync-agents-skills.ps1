# Sync harness-* skills into %USERPROFILE%\.agents\skills
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Src = Join-Path $Root "skills"
$Dest = if ($env:AGENTS_SKILLS_DIR) { $env:AGENTS_SKILLS_DIR } else { Join-Path $env:USERPROFILE ".agents\skills" }

New-Item -ItemType Directory -Force -Path $Dest | Out-Null
$count = 0
Get-ChildItem -Directory (Join-Path $Src "harness-*") | ForEach-Object {
  $target = Join-Path $Dest $_.Name
  if (Test-Path $target) { Remove-Item -Recurse -Force $target }
  Copy-Item -Recurse $_.FullName $target
  Write-Host "synced $($_.Name) → $target"
  $count++
}
Write-Host "Done. Synced $count harness skill(s) to $Dest"

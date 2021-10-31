if (-not(Test-Path -Path "~\bin\chezmoi.exe" -PathType Leaf)) {
  '$params = "-BinDir ~\bin init mmercurio --apply"', (iwr https://git.io/chezmoi.ps1).Content | powershell -c -
}

if (Test-Path -Path $PSScriptRoot\install.ps1) {
  ~\bin\chezmoi init --source="$PSScriptRoot" --apply
}
else {
  ~\bin\chezmoi init mmercurio --apply
}

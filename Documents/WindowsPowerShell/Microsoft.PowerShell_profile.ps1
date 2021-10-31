
# https://hodgkins.io/ultimate-powershell-prompt-and-git-setup

Import-Module -Name posh-git
#Import-Module -Name PSColor # This makes colored dir output very slow on Windows PowerShell v5.x

function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host

    if (Test-Administrator) {  # Use different username if elevated
        Write-Host "[Admin] " -NoNewline -ForegroundColor Red
    }

    #Write-Host "$ENV:USERNAME@" -NoNewline -ForegroundColor DarkYellow
    #Write-Host "$ENV:COMPUTERNAME" -NoNewline -ForegroundColor Magenta

    if ($null -ne $s) {  # color for PSSessions
        Write-Host " (`$s: " -NoNewline -ForegroundColor DarkGray
        Write-Host "$($s.Name)" -NoNewline -ForegroundColor Yellow
        Write-Host ") " -NoNewline -ForegroundColor DarkGray
    }

    #Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host $($(Get-Location) -replace ($env:USERPROFILE).Replace('\','\\'), "~") -NoNewline -ForegroundColor Blue
    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host (Get-Date -Format G) -NoNewline -ForegroundColor DarkMagenta
    Write-Host " : " -NoNewline -ForegroundColor DarkGray

    $global:LASTEXITCODE = $realLASTEXITCODE

    Write-VcsStatus

    Write-Host ""

    return "PS> "
}

# Function to run as Admin:
function Invoke-RunAsAdmin { Start-Process -Verb RunAs (Get-Process -Id $PID).Path }

# Alias for the function:
  Set-Alias psadmin Invoke-RunAsAdmin

$Env:Path="$HOME\bin;$Env:Path"

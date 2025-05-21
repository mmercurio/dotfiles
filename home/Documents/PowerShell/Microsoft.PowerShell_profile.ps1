# https://www.hanselman.com/blog/my-ultimate-powershell-prompt-with-oh-my-posh-and-the-windows-terminal

Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine

# https://ohmyposh.dev/docs
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_classic.omp.json" | Invoke-Expression

# Ensure git uses OpenSSH instead of the ssh that comes with git
# This can be set using global git config: core.sshcommand
$Env:GIT_SSH='C:\WINDOWS\System32\OpenSSH\ssh.exe'

# Function to run as Admin:
function Invoke-RunAsAdmin {
    # Specify what to run or relaunch current process by default.
    Param(
        [string] $FilePath = (Get-Process -Id $PID).Path
    )
    Start-Process -Verb RunAs $FilePath
}

# Alias for the function:
Set-Alias psadmin Invoke-RunAsAdmin

$Env:Path="$HOME\bin;$Env:Path"
function chezmoicd { cd $(chezmoi source-path) }
function cdc([String]$arg) {
<#
.Description
cdc changes directory and clears the screen.
#>
     Clear-Host; Set-Location $arg 
}

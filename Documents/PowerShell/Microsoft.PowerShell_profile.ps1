# https://www.hanselman.com/blog/my-ultimate-powershell-prompt-with-oh-my-posh-and-the-windows-terminal

Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine
Import-Module oh-my-posh

oh-my-posh --init --shell pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression

Set-PoshPrompt -Theme Paradox

# Ensure git uses OpenSSH instead of the ssh that comes with git
# This can be set using global git config: core.sshcommand
$Env:GIT_SSH='C:\WINDOWS\System32\OpenSSH\ssh.exe'

# Function to run as Admin:
function Invoke-RunAsAdmin { Start-Process -Verb RunAs (Get-Process -Id $PID).Path }

# Alias for the function:
Set-Alias psadmin Invoke-RunAsAdmin

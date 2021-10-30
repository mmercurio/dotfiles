# https://hodgkins.io/ultimate-powershell-prompt-and-git-setup

Import-Module -Name posh-git
Import-Module -Name oh-my-posh
Set-Theme Paradox
Import-Module -Name PSColor

# Ensure git uses OpenSSH instead of the ssh that comes with git
# This can be set using global git config: core.sshcommand
$Env:GIT_SSH='C:\WINDOWS\System32\OpenSSH\ssh.exe'

# Function to run as Admin:
function Invoke-RunAsAdmin { Start-Process -Verb RunAs (Get-Process -Id $PID).Path }

# Alias for the function:
Set-Alias psadmin Invoke-RunAsAdmin

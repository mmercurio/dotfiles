# dotfiles
My collection of dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

Inspired by [Tom Payne](https://github.com/twpayne/dotfiles), [renemarc](https://github.com/renemarc/dotfiles), [Mathias Bynens](https://github.com/mathiasbynens/dotfiles), and others.

Install dotfiles with:
```
chezmoi init --apply mmercurio
```

Or to start from scratch and also install chezmoi:
```
sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply mmercurio
```
## Windows

For best results on Windows, first ensure the latest version of [PowerShell (7.x) is installed](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.1):


```
'$params="init --apply mmercurio"', (iwr https://git.io/chezmoi.ps1).Content | pwsh -c -
```


### Windows Todos

- [ ] Install additional Nerd Fonts (downloaded, but not yet installed)
- [x] Configure PowerShell profile and prompt, including upgrading to pwsh Core
- [x] Install and configure git
- [x] Use winget on Windows 11
- [ ] Configure Windows Terminal
- [x] Install extra apps (winget with fallback to Chocolately)
- [ ] One-line install from GitHub repo
- [ ] Configure Windows defaults (themes, fonts, default apps, etc.)

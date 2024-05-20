# dotfiles
My collection of dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

Inspired by [Tom Payne](https://github.com/twpayne/dotfiles), [renemarc](https://github.com/renemarc/dotfiles), [Mathias Bynens](https://github.com/mathiasbynens/dotfiles), and others.

Install dotfiles with:

```shell
chezmoi init --apply mmercurio
```

Or to start from scratch and also install chezmoi:

```shell
sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply mmercurio
```

## 1Password, SSH, and tmux

This repo includes customization to support 1Password + SSH + tmux use cases I have.

Although I don't yet use [Chezmoi's support for 1Password](https://www.chezmoi.io/user-guide/password-managers/1password/), I make heavy use of 1Password, including [1Password SSH Agent](https://developer.1password.com/docs/ssh/agent/) and accessing secrets from scripts using the [1Password CLI](https://developer.1password.com/docs/cli). I also tend to login remotely via SSH to both Linux and macOS systems, including sessions managed by [tmux](https://github.com/tmux/tmux).

I've found that out of the box, 1Password SSH Agent and CLI don't provide the best user experience over SSH, especially when long-lived tmux sessions on are involved.

### Use Case

Assume I have 1Password installed on all of my macOS and Linux desktop systems, and I SSH from a Linux desktop into a macOS system. SSH agent forwarding will mostly take care of using 1Password SSH Agent over SSH with a [carefully configured tmux](https://blog.testdouble.com/posts/2016-11-18-reconciling-tmux-and-ssh-agent-forwarding/).

However, trying to use scripts that rely on 1Password CLI while logged in remotely over SSH will not work very well because the [1Password CLI communicates with the 1Password app](https://developer.1password.com/docs/cli/app-integration-security/#how-does-1password-cli-communicate-with-the-1password-app) running on the same host. In this example, the authorization prompt for CLI access goes to a the macOS desktop (i.e., the system I'm logged in remotely to) instead of the Linux desktop where I'm logged in locally and have access to the 1Password desktop app.

### Solution

I'd like to proxy the 1Password CLI (`op`) command back over the SSH session to the local desktop where I'm running 1Password, similarly to how SSH agent forwarding behaves.

Out of the box, 1Password doesn't support this, but nothing stops me from running `op` over SSH (e.g., to read a secret ACCESS_TOKEN stored in a 1Password vault):

```shell
ssh desktop-host op read op://dev/ACCESS_TOKEN
```

This works well enough, but I want to proxy the 1Passwrord CLI `op` command over SSH *automatically* so that scripts that use `op` work without modification.

In order to accomplish this I set up a wrapper for the  `op` command when I'm logged in remotely over SSH and I keep track of the desktop host where I'm logged in locally with an environment variable (`LC_DESKTOP_HOST`) which is forwarded to remote SSH sessions.

- **Note:** It's important to use a variable name beginning with `LC_` because the SSH server must be configured to accept additional environment variables from the client. Most OpenSSH server configurations (`/etc/sshd_config`) allow the client to send variable names beginning with `LC_` to support localization across SSH sessions.

Most of this is accomplished via [`~/.ssh/env_1password`](home/private_dot_ssh/private_env_1password) which is sourced by the login shell.

Additionally:

- on macOS, `~/.1password/agent.sock` is symlinked to the 1Password SSH Agent socket (typically `~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock` by default) so that this is consistent between macOS and Linux.
- `~/bin/op` is symlinked to 1Password CLI executable so this is consistent across all SSH sessions on all macOS and Linux hosts.
- [`~/.ssh/config`](home/private_dot_ssh/private_default_config) includes the option `SendEnv LC_DESKTOP_HOST`.
- [`~/.tmux.conf`](home/dot_tmux.conf) is configured to add `LC_DESKTOP_HOST` to the list of environment variables copied into the session via `update-environment`, so this works properly over tmux when reattaching to a session from a different desktop.

Now scripts using `op` to read secrets will continue to work as expected and the authorization will be sent to the 1Password app running on the desktop where I'm logged in locally. This has the added benefit of allowing `op` to work via SSH on remote systems where 1Password is not installed.

## Windows

For best results on Windows, first ensure the latest version of [PowerShell (7.x) is installed](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.1):

```powershell
(iwr https://git.io/chezmoi.ps1).Content | pwsh -c -
```



### Windows Todos

My use of Microsoft Windows has declined, so Windows support is not as complete as macOS and Linux. Some missing features and TODOs:

- [ ] Install additional Nerd Fonts (downloaded, but not yet installed)
- [x] Configure PowerShell profile and prompt, including upgrading to pwsh Core
- [x] Install and configure git
- [x] Use winget on Windows 11
- [ ] Configure Windows Terminal
- [x] Install extra apps (winget with fallback to Chocolately)
- [ ] One-line install from GitHub repo
- [ ] Configure Windows defaults (themes, fonts, default apps, etc.)

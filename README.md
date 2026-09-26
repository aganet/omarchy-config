# omarchy-config

My terminal on Omarchy: bash with ble.sh and a starship prompt.

![The prompt](docs/prompt.png)

## What is here

| Path | Goes to | What it is |
| --- | --- | --- |
| `home/bashrc` | `~/.bashrc` | Loads ble.sh, Omarchy's defaults, ghostty integration, fzf, atuin |
| `home/blerc` | `~/.blerc` | ble.sh: autosuggestions, syntax colours, Tab menu |
| `home/aliases` | `~/.bash_aliases` | Aliases and functions, ported from my zsh config |
| `config/starship.toml` | `~/.config/starship.toml` | The prompt |
| `config/ghostty/config` | `~/.config/ghostty/config` | Terminal: font, keys, shell integration |
| `home/bashrc.local.example` | `~/.bashrc.local` | Machine-specific bits. Copied by hand, not in git. |
| `docs/terminal-setup.md` | — | How it all fits together, and how to undo it |

## New machine

On a fresh Omarchy install:

```bash
git clone https://github.com/aganet/omarchy-config.git ~/omarchy-config
~/omarchy-config/install.sh      # links the files, backs up what is there
yay -S blesh-git                 # the only thing Omarchy does not ship
```

Open a new terminal. That is all.

For anything machine-specific (work hostnames, private aliases):

```bash
cp ~/omarchy-config/home/bashrc.local.example ~/.bashrc.local
```

`~/.bashrc.local` is not in git. `~/.bashrc` sources it last.

## Keeping it up to date

The files in `~` are symlinks into `~/omarchy-config`, so editing
`~/.bashrc` edits the repo. To publish a change:

```bash
cd ~/omarchy-config && git add -A && git commit -m "..." && git push
```

On another machine: `git pull`, then open a new terminal.

## Needs

- Omarchy (the bashrc sources `$OMARCHY_PATH/default/bash/rc`)
- starship, fzf, atuin, zoxide, mise — all installed by Omarchy
- ble.sh from the AUR: `yay -S blesh-git`
- a Nerd Font for the prompt icons

## Notes

Prompt colours are terminal palette names, not fixed hex values, so the
prompt follows whatever Omarchy theme is active.

`shell-integration = none` in the ghostty config is on purpose. The bashrc
sources ghostty's integration script itself, otherwise ble.sh attaches late
and the first prompt is drawn twice. See `docs/terminal-setup.md`.

## Also mine

[omarchy-sysmon](https://github.com/aganet/omarchy-sysmon) — a small
CPU/memory/network widget for the Omarchy bar.

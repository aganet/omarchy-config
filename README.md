# omarchy-config

My terminal on Omarchy: bash with ble.sh and a starship prompt.

![The prompt](docs/prompt.png)

## What is here

| Path | Goes to | What it is |
| --- | --- | --- |
| `home/bashrc` | `~/.bashrc` | Loads ble.sh, Omarchy's defaults, ghostty integration, fzf, atuin |
| `home/blerc` | `~/.blerc` | ble.sh: autosuggestions, syntax colours, Tab menu |
| `config/starship.toml` | `~/.config/starship.toml` | The prompt |
| `config/ghostty/config` | `~/.config/ghostty/config` | Terminal: font, keys, shell integration |
| `docs/terminal-setup.md` | — | How it all fits together, and how to undo it |

## Install

```bash
git clone https://github.com/aganet/omarchy-config.git ~/omarchy-config
~/omarchy-config/install.sh
yay -S blesh-git
```

Open a new terminal. The script backs up anything already in place.

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

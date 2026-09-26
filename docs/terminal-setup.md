# My terminal setup

What changed on 2026-09-26, why, and how to undo it.

## What I wanted

A terminal like oh-my-zsh with powerlevel10k: grey suggestions while typing,
coloured syntax, a Tab menu, and a prompt that shows git information.

I stayed on bash. Omarchy has no zsh support, and all its aliases and
functions are written for bash.

## The two pieces

| Piece | What it does | Replaces |
| --- | --- | --- |
| ble.sh | Autosuggestions, syntax colours, Tab menu | zsh-autosuggestions, zsh-syntax-highlighting |
| starship | The prompt itself | powerlevel10k |

Starship was already installed by Omarchy. ble.sh came from the AUR:
`yay -S blesh-git`. It installs to `/usr/share/blesh/ble.sh`.

## What the prompt shows

```
󰣇 │  gitdemo │  main 3eb205f ✚1 !1 ?2 │  v26.8.1   󱦟 4s      󰁿 59% 󰅐 11:51
❯
```

Connected coloured blocks, left to right:

- Arch icon
- folder, shortened to the last 3 parts. Documents, Downloads, Pictures,
  Music, Videos, Work and .config get their own icon.
- git branch and short commit hash
- change counts: `✚` staged, `!` modified, `?` untracked, `⇡` ahead,
  `⇣` behind, `≡` stashed, `✖` deleted, `»` renamed, `~` conflicted
- node / python / rust / go / java version, or docker context, only when
  the folder has one
- how long the last command took, when over 3 seconds

Second line: `❯`, turning red when a command fails. The exit code appears
before it, as `󰅙 1`. Background jobs show as `󰜎 2`.

Right edge: battery (red under 25%) and the clock.

Outside a git repo only the OS and folder blocks show.

Colours are terminal palette names (blue, green, purple), not fixed hex
values. They follow whatever Omarchy theme is active. The current theme is
warm, so the blocks come out orange, amber and red.

## While typing

- Grey text suggests the rest from history. `→` or `End` accepts it.
- Valid commands are green, unknown commands red.
- `Tab` opens a menu with descriptions. `Tab` again moves through it.
- `Ctrl-R` atuin history search, `Ctrl-T` fzf files, `Alt-C` fzf folders,
  `z` jumps to a folder. All of these still work.

## Files

| File | What is in it |
| --- | --- |
| `~/.bashrc` | Loads ble.sh first, Omarchy's rc, ghostty integration, fzf, history, atuin. Attaches ble.sh last. |
| `~/.blerc` | ble.sh settings: suggestion colour, Tab menu, glyph width, fzf integration. |
| `~/.config/starship.toml` | The prompt. |
| `~/.config/ghostty/config` | `shell-integration = none` (see below). |

Backups, all from 2026-09-26:

```
~/.bashrc.2026-09-26
~/.config/starship.toml.2026-09-26
~/.config/starship.toml.2026-09-26-2
~/.config/ghostty/config.2026-09-26
~/.config/starship.toml.lean        flat prompt, no coloured blocks
~/.config/starship.toml.blocks-v1   coloured blocks, fewer icons
```

## Problems and their fixes

**The first prompt was drawn twice.** Ghostty injects its bash integration
at startup. ble.sh notices and waits until the first prompt before
attaching, and bash prints the prompt once itself in that gap.

Fix: ghostty no longer injects. `~/.config/ghostty/config` has
`shell-integration = none`, and `~/.bashrc` sources the same script itself:

```bash
[[ -n ${GHOSTTY_RESOURCES_DIR-} ]] && builtin source "$GHOSTTY_RESOURCES_DIR/shell-integration/bash/ghostty.bash"
```

Window titles and "open terminal here" still work.

**The clock did not appear.** Starship 1.26 detects ble.sh and sets its
right prompt on every prompt. Anything set with `bleopt prompt_rps1` in
`.blerc` gets overwritten. The clock belongs in starship's `right_format`.

**Prompt drawn twice on long lines.** ble.sh counted Nerd Font glyphs as
two cells wide and thought the line had wrapped. Fixed with
`bleopt char_width_mode=west` in `.blerc`.

**A whole block had no colour.** Starship has no colour called `magenta`.
The name is `purple`. An unknown colour is ignored without an error, so the
language block printed as plain text.

**Battery would not load.** `charging_symbol` has to be a plain string, not
a `[battery.charging_symbol]` table. That one error made other modules fall
back to their defaults too.

## Small tweaks

- Suggestions too dark or too bright: change `fg=245` in `~/.blerc`.
  232 is dark, 255 is light.
- No clock: delete the `right_format` line in `starship.toml`.
- One line instead of two: remove `$character` from its own line in
  `format`.
- Flat prompt, no blocks: `cp ~/.config/starship.toml.lean ~/.config/starship.toml`
- Fewer icons, plain blocks: `cp ~/.config/starship.toml.blocks-v1 ~/.config/starship.toml`
- No battery: set `disabled = true` under `[battery]`.

## Undo everything

```bash
cp ~/.bashrc.2026-09-26 ~/.bashrc
cp ~/.config/starship.toml.2026-09-26 ~/.config/starship.toml
cp ~/.config/ghostty/config.2026-09-26 ~/.config/ghostty/config
rm ~/.blerc
yay -R blesh-git
```

Then open a new terminal.

## Note

Changes to these files only apply to new terminal windows. The window you
are in keeps the setup it started with.

#!/usr/bin/env bash
# Link the config files in this repo into place.
# Anything already there is backed up with today's date first.

set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
stamp=$(date +%F)

# --no-aliases skips my alias groups entirely. You can also keep them and
# switch individual groups off later with: aliasgroup off <name>
aliases=yes
[[ ${1-} == --no-aliases ]] && aliases=no

link() {
  local src="$repo/$1" dst="$2"

  if [[ -L $dst ]]; then
    rm "$dst"
  elif [[ -e $dst ]]; then
    mv "$dst" "$dst.$stamp"
    echo "backed up $dst -> $dst.$stamp"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "linked $dst"
}

link home/bashrc          "$HOME/.bashrc"
link home/blerc           "$HOME/.blerc"
if [[ $aliases == yes ]]; then
  link home/aliases.d     "$HOME/.bash_aliases.d"
else
  echo "skipped the alias groups (--no-aliases)"
fi
link config/starship.toml "$HOME/.config/starship.toml"
link config/ghostty/config "$HOME/.config/ghostty/config"

echo
if [[ -f /usr/share/blesh/ble.sh ]]; then
  echo "ble.sh is already installed."
else
  echo "ble.sh is missing. Install it with:"
  echo "  yay -S --needed blesh-git"
fi
echo
if [[ $aliases == yes ]]; then
  echo "Alias groups installed. See them with: aliasgroup"
  echo "Turn one off with:                    aliasgroup off kubernetes"
  echo
fi
echo "Open a new terminal to pick everything up."


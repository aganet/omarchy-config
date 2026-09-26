#!/usr/bin/env bash
# Link the config files in this repo into place.
# Anything already there is backed up with today's date first.

set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
stamp=$(date +%F)

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
link home/aliases         "$HOME/.bash_aliases"
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
echo "Open a new terminal to pick everything up."

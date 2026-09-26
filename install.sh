#!/usr/bin/env bash
# Link the parts of this repo you want into place.
# Anything already there is backed up with today's date first.
#
#   ./install.sh                 pick the parts from a menu
#   ./install.sh --all           everything, no questions
#   ./install.sh prompt aliases  just those parts
#   ./install.sh --list          show the parts and stop
#   ./install.sh --dry-run ...   say what it would do, change nothing
#
# The bashrc is always installed. It is the file that loads the rest.

set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
stamp=$(date +%F)

# --dry-run anywhere in the arguments: print what would happen, touch nothing.
dry=no
args=()
for a in "$@"; do
  if [[ $a == --dry-run || $a == -n ]]; then dry=yes; else args+=("$a"); fi
done
set -- ${args[@]+"${args[@]}"}

# name|source in repo|destination under ~|what it is
parts=(
  "prompt|config/starship.toml|.config/starship.toml|The starship prompt: folder, git state, versions, clock"
  "typing|home/blerc|.blerc|ble.sh: suggestions, syntax colours, Tab menu, Enter fix"
  "aliases|home/aliases.d|.bash_aliases.d|~90 aliases in groups you can switch on and off"
  "terminal|config/ghostty/config|.config/ghostty/config|Ghostty: font, padding, keys (opinionated)"
)

field() { printf '%s' "$1" | cut -d'|' -f"$2"; }

usage() {
  echo "usage: install.sh [--all | --list | --dry-run | <part>...]"
  echo
  echo "parts:"
  local p
  for p in "${parts[@]}"; do
    printf '  %-9s %s\n' "$(field "$p" 1)" "$(field "$p" 4)"
  done
  echo
  echo "The bashrc is always installed. It loads whichever parts you pick."
}

link() {
  local src="$repo/$1" dst="$HOME/$2"

  if [[ $dry == yes ]]; then
    if [[ -L $dst ]]; then
      echo "  would replace the link ~/$2"
    elif [[ -e $dst ]]; then
      echo "  would back up ~/$2 -> ~/$2.$stamp, then link it"
    else
      echo "  would link ~/$2"
    fi
    return
  fi

  if [[ -L $dst ]]; then
    rm "$dst"
  elif [[ -e $dst ]]; then
    mv "$dst" "$dst.$stamp"
    echo "  backed up ~/$2 -> ~/$2.$stamp"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "  linked ~/$2"
}

# ── decide what to install ──────────────────────────────────────────────────
chosen=()

case "${1-}" in
  --list|-l|--help|-h)
    usage
    exit 0
    ;;
  --all|-a)
    for p in "${parts[@]}"; do chosen+=("$(field "$p" 1)"); done
    ;;
  "")
    # No arguments: ask, if we can.
    if [[ -t 0 ]] && command -v gum >/dev/null; then
      echo "x to pick, Enter to confirm. Everything is optional."
      echo
      menu=$(for p in "${parts[@]}"; do
               printf '%-9s  %s\n' "$(field "$p" 1)" "$(field "$p" 4)"
             done | gum choose --no-limit --selected="*" \
                      --header="Which parts do you want?") ||
        { echo "cancelled"; exit 1; }
      while read -r line; do
        [[ -n $line ]] && chosen+=("${line%% *}")
      done <<< "$menu"
    else
      echo "Installing everything. Run --list to see the parts."
      for p in "${parts[@]}"; do chosen+=("$(field "$p" 1)"); done
    fi
    ;;
  -*)
    usage >&2
    exit 2
    ;;
  *)
    # Named parts, checked against the list.
    for want in "$@"; do
      found=no
      for p in "${parts[@]}"; do
        [[ $(field "$p" 1) == "$want" ]] && { chosen+=("$want"); found=yes; }
      done
      [[ $found == yes ]] || { echo "no such part: $want" >&2; echo; usage >&2; exit 2; }
    done
    ;;
esac

if ((${#chosen[@]} == 0)); then
  echo "Nothing picked. Nothing done."
  exit 0
fi

# ── install ─────────────────────────────────────────────────────────────────
echo
if [[ $dry == yes ]]; then
  echo "Dry run. Nothing will be changed."
  echo "Would install: ${chosen[*]}"
else
  echo "Installing: ${chosen[*]}"
fi
link home/bashrc .bashrc

for want in "${chosen[@]}"; do
  for p in "${parts[@]}"; do
    [[ $(field "$p" 1) == "$want" ]] || continue
    link "$(field "$p" 2)" "$(field "$p" 3)"
  done
done

# ── what is left to do ──────────────────────────────────────────────────────
echo
if [[ " ${chosen[*]} " == *" typing "* && ! -f /usr/share/blesh/ble.sh ]]; then
  echo "The typing part needs ble.sh, which is not installed:"
  echo "  yay -S --needed blesh-git"
  echo
fi

if [[ " ${chosen[*]} " == *" aliases "* ]]; then
  echo "See the alias groups with:  aliasgroup"
  echo "Turn one off with:          aliasgroup off kubernetes"
  echo
fi

if [[ $dry == yes ]]; then
  echo "Nothing was changed. Run it without --dry-run to do it for real."
else
  echo "Open a new terminal to pick everything up."
fi

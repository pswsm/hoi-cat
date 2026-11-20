#!/usr/bin/env bash
# Register this checkout as a local mod so the HoI4 launcher can load it.
# Usage: tools/link-dev-mod.sh [path-to-hoi4-user-dir]
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
user_dir="${1:-$HOME/.local/share/Paradox Interactive/Hearts of Iron IV}"
mod_dir="$user_dir/mod"
name="hoi-cat"

mkdir -p "$mod_dir"
{
	cat "$repo/descriptor.mod"
	printf 'path="%s"\n' "$repo"
} > "$mod_dir/$name.mod"

echo "Wrote $mod_dir/$name.mod -> $repo"
echo "Enable \"HoI IV - Catalunya\" in a launcher playset."

#!/data/data/com.termux/files/usr/bin/bash
# C25 PathFinder — Never get "No such file or directory" again
# Usage: source pathfinder.sh (adds to every bash session)
# Or:    c25_pathfinder <path>

H="/data/data/com.termux/files/home"
DB="$H/constellation-25/memoria.db"
MASTER="$H/C25-MASTER"
LOG="$H/constellation-25/artie/logs/pathfinder.log"
mkdir -p "$(dirname $LOG)"

# All known C25 search roots
ROOTS=(
  "$H/constellation-25"
  "$H/C25-Vault"
  "$H/C25-MASTER"
  "$H/c25-deploy-v3.0"
  "$H/total-recall-recovery-20260311_141422/ai-records"
  "$H/pathos"
  "$H/sovereign"
  "$H/TotalRecall"
  "$H/scripts"
  "$H/c25-deploy-v3.0"
  "$H/constellation25-mono"
  "$H"
  "/data/data/com.termux/files/usr/bin"
)

c25_resolve() {
  local target="$1"
  local action="${2:-find}"

  # Direct path check first
  if [ -e "$target" ]; then echo "$target"; return 0; fi

  # Search all roots
  for root in "${ROOTS[@]}"; do
    [ -d "$root" ] || continue
    local found=$(find "$root" -name "$(basename $target)" 2>/dev/null | head -1)
    if [ -n "$found" ]; then
      echo "$found"
      return 0
    fi
  done

  # Not found — auto-create
  local ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local dest="$H/constellation-25/$target"
  mkdir -p "$(dirname $dest)"

  # Create minimum viable file based on extension
  local ext="${target##*.}"
  case "$ext" in
    sh)   echo '#!/data/data/com.termux/files/usr/bin/bash' > "$dest"
          echo "# Auto-created by C25 PathFinder: $ts" >> "$dest"
          chmod +x "$dest" ;;
    py)   echo '#!/usr/bin/env python3' > "$dest"
          echo "# Auto-created by C25 PathFinder: $ts" >> "$dest" ;;
    js)   echo "// Auto-created by C25 PathFinder: $ts" > "$dest" ;;
    json) echo '{}' > "$dest" ;;
    md)   echo "# Auto-created by C25 PathFinder\n\nTimestamp: $ts" > "$dest" ;;
    *)    touch "$dest" ;;
  esac

  echo "[$ts] CREATED: $dest" >> "$LOG"
  sqlite3 "$DB" "INSERT INTO logs (agent,event,detail) VALUES ('PathFinder','AUTO_CREATED','$dest');" 2>/dev/null
  echo -e "\033[0;33m[PathFinder]\033[0m Auto-created: $dest"
  echo "$dest"
  return 0
}

c25_pathfinder() { c25_resolve "$1" "create"; }

export -f c25_resolve
export -f c25_pathfinder

#!/data/data/com.termux/files/usr/bin/bash

python3 memoria.py  # Init sync

while true; do
  clear
  cat <<'PROMPT'
╔════════════════════════════════════════════════════════════╗
║                  AGENT PROMPT BOX                          ║
╚════════════════════════════════════════════════════════════╝
Type your prompt (press Enter twice to submit):

PROMPT

  prompt=""
  while IFS= read -r line; do
    [[ -z "$line" ]] && break
    prompt="$prompt$line\n"
  done

  clear

  cat <<'MENU'
╔════════════════════════════════════════════════════════════╗
║           CONSTELLATION 25 - PLANETARY AGENTS              ║
║                Time: $(date '+%Y-%m-%d %H:%M:%S')          ║
║     Prompt: $prompt                                         ║
╠════════════════════════════════════════════════════════════╣
║  1  Earth      - Foundational code structure               ║
║  2  Moon       - Syntax error resolution                   ║
║  3  Sun        - Performance optimization                  ║
║  4  Mercury    - Unit test generation                      ║
║  5  Venus      - Regression testing                        ║
║  6  Mars       - Security vulnerability scanning           ║
║  7  Jupiter    - Code documentation & analysis             ║
║  8  Saturn     - Refactoring & modernization               ║
║  9  Uranus     - NLP documentation generation              ║
║ 10  Neptune    - Code deduplication                        ║
║ 11  Cygnus     - AI algorithm/model code                   ║
║ 12  Orion      - UI/UX optimization                        ║
║ 13  Andromeda  - External API/service integration          ║
║ 14  Pleiades   - Virtual env management                    ║
║ 15  Sirius     - Deployment & scaling                      ║
║ 16  Canis Major- Technical debt resolution                 ║
║ 17  Hydra      - CI/CD pipeline execution                  ║
╚════════════════════════════════════════════════════════════╝
🌌 Agent [1-17] or 'bash' or 'exit':
MENU

  read -p "  " choice

  if [[ "$choice" == "exit" ]]; then
    exit 0
  fi

  if [[ "$choice" == "bash" ]]; then
    bash
    clear
    continue
  fi

  if [[ "\( choice" =\~ ^[1-9] \)|^1[0-7]$ ]]; then
    python3 -c "from memoria import Memoria; Memoria().log('Earth', 'Routed: $prompt to $choice')"

    if [[ "$choice" == "11" ]] && echo "$prompt" | grep -qi "mars|ticket|hunt|game"; then
      echo "Cygnus: Generating..."
      # [Mars code as before]
    else
      echo "Agent $choice processing..."
    fi
  else
    echo "Invalid."
  fi

  sleep 3
  clear
done
